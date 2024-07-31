import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:kasirsql/views/supplier/crop_image_page.dart';
import 'package:kasirsql/controllers/supplier_controller/supplier_controller.dart';
import 'package:kasirsql/controllers/user_controller/user_controller.dart'; // Import UserController

class AddSupplierController extends GetxController {
  var selectedImagePath = ''.obs;
  var croppedImage = Rx<Uint8List?>(null);
  final String apiUrl = 'http://10.10.10.129/flutterapi/api_supplier.php';
  final ImagePicker _picker = ImagePicker();
  final UserController userController =
      Get.find<UserController>(); // Dapatkan UserController

  void pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final fileName =
          '${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.jpg';
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$fileName');

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        pickedFile.path,
        tempFile.path,
        quality: 50,
      );

      if (compressedFile != null) {
        selectedImagePath.value = compressedFile.path;
        Get.to(() => CropImagePageSupplier());
      } else {
        // Gagal / Error
        Get.snackbar(
          'Error',
          'Gagal kompress gambar',
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
    } else {
      // Gagal / Error
      Get.snackbar(
        'Dibatalkan',
        'Tidak ada gambar yang dipilih',
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
  }

  Future<String?> uploadImage(Uint8List imageBytes) async {
    final tempDir = await getTemporaryDirectory();
    final fileName =
        '${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.jpg';
    final file = File('${tempDir.path}/$fileName')
      ..writeAsBytesSync(imageBytes);

    var request =
        http.MultipartRequest('POST', Uri.parse('$apiUrl?action=upload_image'));
    request.files.add(await http.MultipartFile.fromPath('image', file.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var result = json.decode(responseData);
      if (result['status'] == 'success') {
        return result['path'];
      } else {
        // Gagal / Error
        Get.snackbar(
          'Error',
          'Gagal mengunggah gambar',
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
        return null;
      }
    } else {
      // Gagal / Error
      Get.snackbar(
        'Error',
        'Gagal mengunggah gambar',
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
      return null;
    }
  }

  void createSupplier(String namaSupplier, String namaTokoSupplier,
      String noTelepon, String email, String alamat) async {
    try {
      String? gambar;
      if (croppedImage.value != null) {
        gambar = await uploadImage(croppedImage.value!);
      }

      final response = await http.post(
        Uri.parse('$apiUrl?action=create_supplier'),
        body: {
          'nama_supplier': namaSupplier,
          'nama_toko_supplier': namaTokoSupplier,
          'no_telepon': noTelepon,
          'email': email,
          'alamat': alamat,
          'gambar': gambar ?? '',
          'user_id': userController.currentUser.value?.id.toString(),
        },
      );
      if (response.statusCode == 200) {
        Get.find<SupplierController>().fetchSupplier();
        Get.back();
        Get.snackbar(
          'Success',
          'Berhasil menambahkan supplier',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          snackPosition: SnackPosition.TOP,
          icon: const Icon(Icons.check_circle, color: Colors.white),
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
      } else {
        // Gagal / Error
        Get.snackbar(
          'Error',
          'Gagal menambahkan supplier',
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
    } catch (e) {
      // Gagal / Error
      Get.snackbar(
        'Error',
        '$e',
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
  }
}
