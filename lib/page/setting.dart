import 'dart:developer';

import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:appzap_counter_web_app/contanst.dart';
import 'package:appzap_counter_web_app/widgets/bluetooth_name.dart';
import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  String? selectedPrinterType;
  String? selectedPaperSize;
  final OverlayPortalController _tooltipController = OverlayPortalController();
  final _link = LayerLink();

  /// width of the button after the widget rendered
  double? _buttonWidth;

  @override
  void initState() {
    selectedPaperSize = "";
    selectedPrinterType = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    const List<String> _printer_type = [
      'ETHERNET',
      'BLUETOOTH',
    ];
    const List<String> _paper_list = [
      '58 mm',
      '80 mm',
    ];

    bool? isBluetooth = false;

    void onTap() {
      _tooltipController.toggle();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Setting Connecting'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Create Printer",
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  readOnly: selectedPrinterType == "BLUETOOTH" ? true : false,
                  decoration: InputDecoration(
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                    hintText: 'Name',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomDropdown(
                  items: _paper_list,
                  onChanged: (val) {
                    setState(() {
                      selectedPaperSize = val;
                    });
                    log("Selected paper size: $val");
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomDropdown(
                  hintText: "Select type printer",
                  items: _printer_type,
                  onChanged: (value) {
                    setState(() {
                      selectedPrinterType = value;
                    });
                    log('Selected printer type: $value');
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                selectedPrinterType == "BLUETOOTH"
                    ? Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black54,
                                    elevation: 0,
                                    side:
                                        const BorderSide(color: Colors.black45),
                                    minimumSize: const Size(
                                      double.infinity,
                                      45,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () async {},
                                  child: const Text(
                                    'Search',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.red.withOpacity(0.8),
                                    elevation: 0,
                                    side: const BorderSide(color: Colors.white),
                                    minimumSize: const Size(
                                      double.infinity,
                                      45,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  onPressed: () async {},
                                  child: const Text(
                                    'Disconnect',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                            child: Divider(
                              indent: 150,
                              endIndent: 150,
                            ),
                          ),
                          Container(
                              padding: const EdgeInsets.all(16),
                              // height: 150,
                              decoration: BoxDecoration(
                                color: Colors.black12,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListView.separated(
                                separatorBuilder: (context, index) {
                                  return const Divider();
                                },
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: model.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Name:",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(model[index]["name"].toString())
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Model: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(model[index]['model'].toString())
                                        ],
                                      ),
                                    ],
                                  );
                                },
                              ))
                          // CompositedTransformTarget(
                          //     link: _link,
                          //     child: OverlayPortal(
                          //       controller: _tooltipController,
                          //       overlayChildBuilder: (BuildContext context) {
                          //         return CompositedTransformFollower(
                          //           link: _link,
                          //           targetAnchor: Alignment.bottomLeft,
                          //           child: const Align(
                          //             alignment: AlignmentDirectional.topStart,
                          //             child: BluetoothName(),
                          //           ),
                          //         );
                          //       },
                          //     )),
                        ],
                      )
                    : TextFormField(
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                          hintText: 'Printer IP Address',
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(16),
        height: 50,
        child: Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  elevation: 0,
                  side: const BorderSide(color: Colors.white),
                  minimumSize: const Size(
                    double.infinity,
                    45,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {},
                child: const Text(
                  'Test Print',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  elevation: 0,
                  side: const BorderSide(color: Colors.white),
                  minimumSize: const Size(
                    double.infinity,
                    45,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {},
                child: const Text(
                  'Save',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
