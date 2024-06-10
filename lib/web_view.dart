import 'dart:collection';
import 'dart:convert';
import 'dart:typed_data';

import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:image/image.dart' as img;

class WebViewAppCounter extends StatefulWidget {
  const WebViewAppCounter({super.key});

  @override
  State<WebViewAppCounter> createState() => _WebViewAppCounterState();
}

class _WebViewAppCounterState extends State<WebViewAppCounter> {
  InAppWebViewController? _webViewController;
  String? ipData = "";
  int? port;
  Uint8List? imageBytes;
  bool isPrinting = false;
  final Queue<Map<String, dynamic>> _printQueue = Queue();

  void handleData(Map<String, dynamic> billData) {}

  Future<void> printTicketBillData() async {
    List<int> ticket = await generateTicket();
    await printTicket(ticket, ipData);
  }

  Future<void> printTicket(List<int> ticket, String? ip) async {
    final printer = PrinterNetworkManager(ip!);
    PosPrintResult printConnect = await printer.connect();
    if (printConnect == PosPrintResult.success) {
      PosPrintResult printing = await printer.printTicket(ticket);
      debugPrint(printing.msg);
      printer.disconnect();
    }
  }

  Future generateTicket() async {
    List<int> ticket = [];
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);

    final image = img.decodeImage(imageBytes!);
    if (image != null) {
      img.adjustColor(image,
          contrast: 1); // Adjust the contrast factor as needed
      final grayscaleImage = img.grayscale(image);
      final resizedImage =
          img.copyResize(grayscaleImage, width: 550); // Adjust width as needed
      ticket += generator.imageRaster(resizedImage);
    }

    ticket += generator.cut();

    return ticket;
  }

  void _enqueuePrintRequest(Map<String, dynamic> billData) {
    _printQueue.add(billData);
    if (!isPrinting) {
      _processNextPrintRequest();
    }
  }

  Future<void> _processNextPrintRequest() async {
    if (_printQueue.isEmpty) {
      return;
    }

    isPrinting = true; // Set the flag to indicate printing in progress
    final billData = _printQueue.removeFirst();
    ipData = billData['ip'].toString();
    port = billData['port'];
    String base64Image = billData['image'].split(',')[1];
    imageBytes = base64Decode(base64Image);

    try {
      List<int> ticket = await generateTicket();
      await printTicket(ticket, ipData);
    } finally {
      isPrinting = false; // Reset the flag after printing is done
      _processNextPrintRequest(); // Process the next print request
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
          onCreateWindow: (controller, createWindowAction) async {
            return true;
          },
          initialUrlRequest: URLRequest(
            url: WebUri('https://staging.restaurant.appzap.la/'),
          ),
          onWebViewCreated: (controller) {
            _webViewController = controller;
            _webViewController!.addJavaScriptHandler(
              handlerName: 'handlerFoo',
              callback: (arguments) {
                if (!isPrinting) {
                  setState(() {
                    isPrinting = true;
                  });

                  final billData = arguments[0];
                  setState(() {
                    ipData = billData['ip'].toString();
                    port = billData['port'];
                    String base64Image = billData['image'].split(',')[1];
                    imageBytes = base64Decode(base64Image);
                    printTicketBillData();
                  });
                  setState(() {
                    isPrinting = false;
                  });
                }
                return {"status": "success", "data": arguments};
              },
            );
          },
          onConsoleMessage: (controller, consoleMessage) {
            debugPrint(consoleMessage.message);
          },
        ),
      ),
    );
  }
}
