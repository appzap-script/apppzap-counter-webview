import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';

Future<List<int>> printTestNetwork(drawer) async {
  // final List<int> bytes = [];
  // Using default profile
  final profile = await CapabilityProfile.load();
  final generator = Generator(PaperSize.mm80, profile);
  List<int> bytes = [];

  // bytes += generator.text('heelo');
  // bytes += generator.text(
  //   'ມື້ນ້ເປັນແນວໃດ',
  // );
  // bytes += generator.text(
  //   'Special 2: blåbærgrød',
  // );
  // bytes += generator.beep(n: 1, duration: PosBeepDuration.beep450ms);

  // bytes += generator.text('Bold text', styles: PosStyles(bold: true));
  // bytes += generator.text('Reverse text', styles: PosStyles(reverse: true));
  // bytes += generator.text('Underlined text',
  //     styles: PosStyles(underline: true), linesAfter: 1);
  // bytes +=
  //     generator.text('Align left', styles: PosStyles(align: PosAlign.left));
  // bytes +=
  //     generator.text('Align center', styles: PosStyles(align: PosAlign.center));
  // bytes += generator.text('Align right',
  //     styles: PosStyles(align: PosAlign.right), linesAfter: 1);
  if (drawer) {
    bytes += generator.drawer(pin: PosDrawer.pin2);
  }
  // bytes += generator.text('Text size 200%',
  //     styles: PosStyles(
  //       height: PosTextSize.size2,
  //       width: PosTextSize.size2,
  //     ));

  // bytes += generator.feed(2);
  // bytes += generator.cut();
  return bytes;
}
