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
      double yOffset = 10;

      // Calculate canvas height dynamically based on content
      double height = 120 + transaksi.detailBarang.length * 60 + 100;

      canvas.drawRect(
          Rect.fromLTWH(0, 0, width, height), paint..color = Colors.white);

      const textStyle = TextStyle(color: Colors.black, fontSize: 12);
      final textPainter = TextPainter(
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );

      // Store and calculate the height of each text span
      double calculateTextHeight(String text, TextStyle style, double width) {
        final TextPainter tp = TextPainter(
          text: TextSpan(text: text, style: style),
          textDirection: TextDirection.ltr,
        );
        tp.layout(minWidth: width);
        return tp.height;
      }

      // Nama Toko dan Alamat
      String tokoInfo = '${user?.namaToko ?? 'Toko'}\n${user?.alamat ?? 'Alamat'}';
      textPainter.text = TextSpan(
        text: tokoInfo,
        style: textStyle,
      );
      textPainter.layout(minWidth: width);
      textPainter.paint(canvas, Offset(0, yOffset));
      yOffset += calculateTextHeight(tokoInfo, textStyle, width);

      // Waktu
      String waktu = '${transaksi.createdAt}\n';
      textPainter.text = TextSpan(
        text: waktu,
        style: textStyle,
      );
      textPainter.layout(minWidth: width);
      textPainter.paint(canvas, Offset(0, yOffset));
      yOffset += calculateTextHeight(waktu, textStyle, width);

      // Garis pembatas
      String garis = '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n';
      textPainter.text = TextSpan(
        text: garis,
        style: textStyle,
      );
      textPainter.layout(minWidth: width);
      textPainter.paint(canvas, Offset(0, yOffset));
      yOffset += calculateTextHeight(garis, textStyle, width);

      // Detail Barang
      textPainter.textAlign = TextAlign.left;
      const double itemDetailWidth = 200; // Set a fixed width for item details

      for (var barang in transaksi.detailBarang) {
        // Nama Barang
        final itemName = '${barang['nama']}';
        textPainter.text = TextSpan(
          text: itemName,
          style: textStyle,
        );
        textPainter.layout(minWidth: width);
        textPainter.paint(canvas, Offset(10, yOffset));
        yOffset += calculateTextHeight(itemName, textStyle, width);

        // Jumlah x HJB
        final itemDetail = '${barang['jumlah']} x ${barang['hjb']}';
        textPainter.textAlign = TextAlign.left;
        textPainter.text = TextSpan(
          text: itemDetail,
          style: textStyle,
        );
        textPainter.layout(minWidth: itemDetailWidth);
        textPainter.paint(canvas, Offset(10, yOffset));

        // Harga Total
        final itemTotal = '${barang['harga_total']}';
        textPainter.textAlign = TextAlign.right;
        textPainter.text = TextSpan(
          text: itemTotal,
          style: textStyle,
        );
        textPainter.layout(minWidth: width - itemDetailWidth - 20);
        textPainter.paint(canvas, Offset(width - itemDetailWidth - 10, yOffset));
        
        yOffset += calculateTextHeight(itemDetail, textStyle, itemDetailWidth);
      }

      // Garis pembatas
      textPainter.textAlign = TextAlign.center;
      textPainter.text = TextSpan(
        text: garis,
        style: textStyle,
      );
      textPainter.layout(minWidth: width);
      textPainter.paint(canvas, Offset(0, yOffset));
      yOffset += calculateTextHeight(garis, textStyle, width);

      // Subtotal, Bayar, Kembali
      String pembayaran = 'Subtotal : ${transaksi.totalHarga}\nBayar : ${transaksi.bayar}\nKembali : ${transaksi.kembali}\n';
      textPainter.textAlign = TextAlign.right;
      textPainter.text = TextSpan(
        text: pembayaran,
        style: textStyle,
      );
      textPainter.layout(minWidth: width - 20);
      textPainter.paint(canvas, Offset(10, yOffset));
      yOffset += calculateTextHeight(pembayaran, textStyle, width - 20);

      // Nomor Telepon dan Ucapan Terima Kasih
      String terimaKasih = '${user?.noTelepon ?? 'No Telepon'}\nTerima Kasih\n';
      textPainter.textAlign = TextAlign.center;
      textPainter.text = TextSpan(
        text: terimaKasih,
        style: textStyle,
      );
      textPainter.layout(minWidth: width);
      textPainter.paint(canvas, Offset(0, yOffset));

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
          child: Image.memory(buffer),
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
