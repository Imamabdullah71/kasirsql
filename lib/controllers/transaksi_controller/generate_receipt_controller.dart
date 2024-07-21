import 'dart:io';
import 'dart:ui';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/user_controller/user_controller.dart';
import 'package:kasirsql/models/transaksi_model.dart';

class GenerateReceiptController extends GetxController {
  final UserController userController = Get.find<UserController>();
  Future<void> generateReceipt(Transaksi transaksi, int transaksiId) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();

    final user = userController.currentUser.value;

    print('USER ID : ${userController.currentUser.value?.id}');

    try {
      const double width = 300;
      double height = 400;

      canvas.drawRect(
          Rect.fromLTWH(0, 0, width, height), paint..color = Colors.white);

      const textStyle = TextStyle(color: Colors.black, fontSize: 12);
      final textPainter = TextPainter(
        textDirection: TextDirection.ltr,
      );

      textPainter.text = TextSpan(
        text: '${user?.namaToko ?? 'Toko'}\n${user?.alamat ?? 'Alamat'}\n',
        style: textStyle,
      );
      textPainter.layout();
      textPainter.paint(canvas, const Offset(10, 10));

      textPainter.text = TextSpan(
        text: 'Waktu: ${transaksi.createdAt}\n',
        style: textStyle,
      );
      textPainter.layout();
      textPainter.paint(canvas, const Offset(10, 50));

      textPainter.text = const TextSpan(
        text: '----------------------------------------\n',
        style: textStyle,
      );
      textPainter.layout();
      textPainter.paint(canvas, const Offset(10, 70));

      double yOffset = 90;
      for (var barang in transaksi.detailBarang) {
        textPainter.text = TextSpan(
          text:
              '${barang['nama']} x ${barang['jumlah']} @ ${barang['hjb']} = ${barang['harga_total']}\n',
          style: textStyle,
        );
        textPainter.layout();
        textPainter.paint(canvas, Offset(10, yOffset));
        yOffset += 20;
      }

      textPainter.text = const TextSpan(
        text: '----------------------------------------\n',
        style: textStyle,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(10, yOffset));
      yOffset += 20;

      textPainter.text = TextSpan(
        text:
            'Subtotal: ${transaksi.totalHarga}\nBayar: ${transaksi.bayar}\nKembali: ${transaksi.kembali}\n',
        style: textStyle,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(10, yOffset));
      yOffset += 60;

      textPainter.text = TextSpan(
        text: '${user?.noTelepon ?? 'No Telepon'}\nTerima Kasih\n',
        style: textStyle,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(10, yOffset));

      final picture = recorder.endRecording();
      final img = await picture.toImage(width.toInt(), height.toInt());
      final byteData = await img.toByteData(format: ImageByteFormat.png);
      final buffer = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/receipt_$transaksiId.png');
      await file.writeAsBytes(buffer);
      print('Receipt saved: ${file.path}');

      Get.defaultDialog(
        title: 'Receipt',
        content: SingleChildScrollView(
          child: Text(file.path),
        ),
        textConfirm: 'Okay',
        onConfirm: () => Get.back(),
      );
    } catch (e) {
      print('Error generating receipt: $e');
      Get.defaultDialog(
        title: 'Error',
        content: SingleChildScrollView(
          child: Text('$e'),
        ),
        textConfirm: 'Okay',
        onConfirm: () => Get.back(),
      );
    }
  }
}
