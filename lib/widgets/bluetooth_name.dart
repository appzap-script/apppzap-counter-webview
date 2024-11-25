import 'package:flutter/material.dart';

class BluetoothName extends StatelessWidget {
  const BluetoothName({super.key, this.width});

  final double? width;

  @override
  Widget build(BuildContext context) {
    return Container(
        // width: double.infinity,
        height: 150,
        decoration: ShapeDecoration(
          color: Colors.black26,
          shape: RoundedRectangleBorder(
            side: const BorderSide(
              width: 1.5,
              color: Colors.black26,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          shadows: const [
            BoxShadow(
              color: Color(0x11000000),
              blurRadius: 32,
              offset: Offset(0, 20),
              spreadRadius: -8,
            ),
          ],
        ));
  }
}
