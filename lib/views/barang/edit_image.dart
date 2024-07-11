import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crop_your_image/crop_your_image.dart';
import 'package:kasirsql/controllers/tambah_barang_controller.dart';

class CropImagePage extends StatelessWidget {
  CropImagePage({super.key});
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
            onPressed: () => _cropController.crop(),
          ),
        ],
      ),
      body: Center(
        child: Crop(
          image: File(controller.selectedImagePath.value).readAsBytesSync(),
          controller: _cropController,
          onCropped: (croppedData) {
            controller.croppedImage.value = croppedData;
            Get.back();
          },
          aspectRatio: 1.0,
        ),
      ),
    );
  }
}
