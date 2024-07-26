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
  List<Map<String, dynamic>> printQueue = [];

  void handleData(Map<String, dynamic> billData) {
    printQueue.add(billData);
    processQueue();
  }

  Future<void> processQueue() async {
    if (isPrinting || printQueue.isEmpty) return;

    setState(() {
      isPrinting = true;
    });

    final billData = printQueue.removeAt(0);
    ipData = billData['ip'].toString();
    String base64Image = billData['image'].split(',')[1];
    imageBytes = base64Decode(base64Image);
    
    await printTicketBillData();

    setState(() {
      isPrinting = false;
    });

    // Process the next item in the queue
    processQueue();
  }

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

  Future<List<int>> generateTicket() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: InAppWebView(
          onCreateWindow: (controller, createWindowAction) async {
            return true;
          },
          initialUrlRequest: URLRequest(
            url: WebUri('http://localhost:3000/'),
          ),
          onWebViewCreated: (controller) {
            _webViewController = controller;
            _webViewController!.addJavaScriptHandler(
              handlerName: 'handlerFoo',
              callback: (arguments) {
                final billData = arguments[0];
                handleData(billData);
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
