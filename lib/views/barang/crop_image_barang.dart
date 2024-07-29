import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:kasirsql/controllers/barang_controller/tambah_barang_controller.dart';

class CropImageBarang extends StatelessWidget {
  CropImageBarang({super.key});
  final TambahBarangController controller = Get.find<TambahBarangController>();
  final CropController _cropController = CropController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Crop Image"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
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
          onCropped: (croppedData) {
            controller.croppedImage.value = croppedData;
            Get.back();  // Close the loading dialog
            Get.back();  // Navigate back to the previous page
          },
          aspectRatio: 1.0,
        ),
      ),
    );
  }
}
