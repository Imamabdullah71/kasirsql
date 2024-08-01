import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:kasirsql/controllers/supplier_controller/add_supplier_controller.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class CropImagePageSupplier extends StatelessWidget {
  CropImagePageSupplier({super.key});
  final AddSupplierController controller = Get.find<AddSupplierController>();
  final CropController _cropController = CropController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crop Image"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              Get.defaultDialog(
                title: 'Processing...',
                content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Harap tunggu proses sedang berjalan'),
                  ],
                ),
                barrierDismissible: false,
              );
              _cropController.crop();
            },
          ),
        ],
      ),
      body: Center(
        child: Crop(
          image: File(controller.selectedImagePath.value).readAsBytesSync(),
          controller: _cropController,
          onCropped: (croppedData) async {
            // Simpan file yang di-crop ke direktori sementara
            final tempDir = await getTemporaryDirectory();
            final fileName =
                '${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.jpg';
            final tempFile = File('${tempDir.path}/$fileName');

            await tempFile.writeAsBytes(croppedData);

            // Tentukan jalur tujuan untuk kompresi
            final compressedFilePath = '${tempDir.path}/compressed_$fileName';

            // Kompresi gambar setelah cropping
            final compressedFile =
                await FlutterImageCompress.compressAndGetFile(
              tempFile.path,
              compressedFilePath,
              quality: 50,
            );

            if (compressedFile != null) {
              controller.croppedImage.value =
                  await compressedFile.readAsBytes();
              controller.selectedImagePath.value = compressedFile.path;
              Get.back(); // Close the loading dialog
              Get.back(); // Navigate back to the previous page
            } else {
              Get.back(); // Close the loading dialog
              Get.snackbar(
                'Error',
                'Gagal mengompres gambar',
                backgroundColor: Colors.red,
                colorText: Colors.white,
                borderRadius: 10,
                margin: const EdgeInsets.all(10),
                snackPosition: SnackPosition.TOP,
                icon: const Icon(Icons.error, color: Colors.white),
                duration: const Duration(seconds: 3),
                snackStyle: SnackStyle.FLOATING,
                boxShadows: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              );
            }
          },
          aspectRatio: 1.0,
        ),
      ),
    );
  }
}
