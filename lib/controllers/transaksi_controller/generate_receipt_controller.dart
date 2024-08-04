import 'dart:io';
import 'dart:ui' as ui;
import 'package:kasirsql/controllers/transaksi_controller/riwayat_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/user_controller/user_controller.dart';
import 'package:kasirsql/models/transaksi_model.dart';
import 'package:kasirsql/models/detail_transaksi_model.dart';
import 'package:intl/intl.dart';

class GenerateReceiptController extends GetxController {
  final UserController userController = Get.find<UserController>();
  final RiwayatController riwayatC = Get.find<RiwayatController>();

  Future<void> generateReceipt(Transaksi transaksi,
      List<DetailTransaksi> detailTransaksiList, int transaksiId) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final paint = Paint();

    final user = userController.currentUser.value;

    try {
      const double width = 300;
      double yOffset = 10;

      // Calculate canvas height dynamically based on content
      double height = 120 + detailTransaksiList.length * 80 + 100;

      // Nama Toko dan Alamat
      const textStyle = TextStyle(color: Colors.black, fontSize: 12);
      String tokoInfo =
          '${user?.namaToko ?? 'Toko'}\n${user?.alamat ?? 'Alamat'}';
      double tokoInfoHeight = calculateTextHeight(tokoInfo, textStyle, width);

      // Waktu
      String waktu = '${riwayatC.formatTanggal(transaksi.createdAt)}\n';
      double waktuHeight = calculateTextHeight(waktu, textStyle, width);

      // Garis pembatas
      String garis =
          '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~\n';
      double garisHeight = calculateTextHeight(garis, textStyle, width);

      // Detail Barang
      double detailHeight = 0;
      for (var detail in detailTransaksiList) {
        // Nama Barang
        final itemName = detail.namaBarang;
        detailHeight += calculateTextHeight(itemName, textStyle, width);

        // Jumlah x Harga Barang dan Harga Total
        final itemDetail =
            '${detail.jumlahBarang} x ${formatRupiahNoRP(detail.hargaBarang)}';
        detailHeight += calculateTextHeight(itemDetail, textStyle, width);

        // Add extra space
        detailHeight += 10;
      }

      // Subtotal, Bayar, Kembali
      String pembayaran =
          'Subtotal : ${formatRupiahWithRP(transaksi.totalHarga)}\nBayar : ${formatRupiahWithRP(transaksi.bayar)}\nKembali : ${formatRupiahWithRP(transaksi.kembali)}\n';
      double pembayaranHeight =
          calculateTextHeight(pembayaran, textStyle, width);

      // Nomor Telepon dan Ucapan Terima Kasih
      String terimaKasih = '${user?.noTelepon ?? 'No Telepon'}\nTerima Kasih\n';
      double terimaKasihHeight =
          calculateTextHeight(terimaKasih, textStyle, width);

      // Calculate total height
      height = tokoInfoHeight +
          waktuHeight +
          garisHeight +
          detailHeight +
          garisHeight +
          pembayaranHeight +
          terimaKasihHeight +
          50;

      // Draw canvas background
      canvas.drawRect(
          Rect.fromLTWH(0, 0, width, height), paint..color = Colors.white);

      final textPainter = TextPainter(
        textDirection: ui.TextDirection.ltr,
        textAlign: TextAlign.left,
      );

      // Nama Toko dan Alamat
      textPainter.textAlign = TextAlign.center;
      textPainter.text = TextSpan(
        text: tokoInfo,
        style: textStyle,
      );
      textPainter.layout(minWidth: width);
      textPainter.paint(canvas, Offset(0, yOffset));
      yOffset += tokoInfoHeight;

      // Waktu
      textPainter.textAlign = TextAlign.center;
      textPainter.text = TextSpan(
        text: waktu,
        style: textStyle,
      );
      textPainter.layout(minWidth: width);
      textPainter.paint(canvas, Offset(0, yOffset));
      yOffset += waktuHeight;

      // Garis pembatas
      textPainter.text = TextSpan(
        text: garis,
        style: textStyle,
      );
      textPainter.layout(minWidth: width);
      textPainter.paint(canvas, Offset(0, yOffset));
      yOffset += garisHeight;

      // Detail Barang
      const double itemDetailWidth = 150; // Set a fixed width for item details

      for (var detail in detailTransaksiList) {
        // Nama Barang
        textPainter.textAlign = TextAlign.left; // Ensure left alignment
        final itemName = detail.namaBarang;
        textPainter.text = TextSpan(
          text: itemName,
          style: textStyle,
        );
        textPainter.layout(minWidth: width);
        textPainter.paint(canvas, Offset(10, yOffset));
        yOffset += calculateTextHeight(itemName, textStyle, width);

        // Jumlah x Harga Barang dan Harga Total
        final itemDetail =
            '${detail.jumlahBarang} x ${formatRupiahNoRP(detail.hargaBarang)}';
        textPainter.textAlign = TextAlign.left; // Ensure left alignment
        textPainter.text = TextSpan(
          text: itemDetail,
          style: textStyle,
        );
        textPainter.layout(minWidth: itemDetailWidth);
        textPainter.paint(canvas, Offset(10, yOffset));

        final itemTotal = formatRupiahWithRP(detail.jumlahHarga);
        textPainter.textAlign = TextAlign.right; // Ensure right alignment
        textPainter.text = TextSpan(
          text: itemTotal,
          style: textStyle,
        );
        textPainter.layout(minWidth: width - itemDetailWidth - 20);
        textPainter.paint(
            canvas, Offset(width - itemDetailWidth - 10, yOffset));

        yOffset += calculateTextHeight(itemDetail, textStyle, itemDetailWidth) +
            10; // Added extra space
      }

      // Garis pembatas
      textPainter.textAlign = TextAlign.center; // Ensure center alignment
      textPainter.text = TextSpan(
        text: garis,
        style: textStyle,
      );
      textPainter.layout(minWidth: width);
      textPainter.paint(canvas, Offset(0, yOffset));
      yOffset += calculateTextHeight(garis, textStyle, width);

      // Subtotal, Bayar, Kembali
      textPainter.textAlign = TextAlign.right; // Ensure right alignment
      textPainter.text = TextSpan(
        text: pembayaran,
        style: textStyle,
      );
      textPainter.layout(minWidth: width - 20);
      textPainter.paint(canvas, Offset(10, yOffset));
      yOffset += pembayaranHeight;

      // Nomor Telepon dan Ucapan Terima Kasih
      textPainter.textAlign = TextAlign.center; // Ensure center alignment
      textPainter.text = TextSpan(
        text: terimaKasih,
        style: textStyle,
      );
      textPainter.layout(minWidth: width);
      textPainter.paint(canvas, Offset(0, yOffset));

      final picture = recorder.endRecording();
      final img = await picture.toImage(width.toInt(), height.toInt());
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      final buffer = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();
      String formattedDate =
          DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final file = File('${directory.path}/$formattedDate.png');
      await file.writeAsBytes(buffer);
      print('Receipt saved: ${file.path}');
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

  double calculateTextHeight(String text, TextStyle style, double width) {
    final TextPainter tp = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: ui.TextDirection.ltr,
    );
    tp.layout(minWidth: width);
    return tp.height;
  }

  String formatRupiahNoRP(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
  }

  String formatRupiahWithRP(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}';
  }
}
