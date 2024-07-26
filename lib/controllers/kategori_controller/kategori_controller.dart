import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:kasirsql/models/kategori_model.dart';
import 'package:kasirsql/controllers/user_controller/user_controller.dart';
import 'package:kasirsql/views/kategori/crop_image_kategori.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class KategoriController extends GetxController {
  var kategoriList = <Kategori>[].obs;
  final String apiUrl = 'http://192.168.135.56/flutterapi/api_kategori.php';
  final UserController userController = Get.find<UserController>();

  var selectedImagePath = ''.obs;
  var croppedImage = Rx<Uint8List?>(null);
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    fetchKategori();
    super.onInit();
  }

  void fetchKategori() async {
    try {
      final response = await http.get(Uri.parse(
          '$apiUrl?action=read_kategori&user_id=${userController.currentUser.value?.id}'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        kategoriList.value =
            data.map((kategori) => Kategori.fromJson(kategori)).toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch kategori');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to parse kategori');
      print('Error = $e');
    }
  }

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
        Get.to(() => CropImagePageKategori());
      } else {
        Get.snackbar('Error', 'Failed to compress image');
      }
    } else {
      Get.snackbar('Error', 'No image selected');
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
        Get.snackbar('Error', 'Failed to upload image');
        return null;
      }
    } else {
      Get.snackbar('Error', 'Failed to upload image');
      return null;
    }
  }

  void createKategori(String namaKategori) async {
    try {
      String? gambar;
      if (croppedImage.value != null) {
        gambar = await uploadImage(croppedImage.value!);
      }

      final response = await http.post(
        Uri.parse('$apiUrl?action=create_kategori'),
        body: {
          'nama_kategori': namaKategori,
          'gambar': gambar ?? '',
          'user_id': userController.currentUser.value?.id.toString(),
        },
      );
      if (response.statusCode == 200) {
        fetchKategori();
        Get.back();
        Get.snackbar(
          "Berhasil menambahkan Kategori",
          "",
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.green,
          colorText: Colors.white,
          borderRadius: 10.0,
          margin: const EdgeInsets.all(16.0),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          snackPosition: SnackPosition.TOP,
          forwardAnimationCurve: Curves.easeOut,
          reverseAnimationCurve: Curves.easeIn,
          isDismissible: true,
          showProgressIndicator: false,
        );
      } else {
        Get.snackbar('Error', 'Failed to create kategori');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create kategori');
      print('Error = $e');
    }
  }

  void deleteKategori(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl?action=delete_kategori'),
        body: {'id': id.toString()},
      );
      if (response.statusCode == 200) {
        fetchKategori();
        Get.snackbar('Success', 'Kategori deleted successfully');
      } else {
        Get.snackbar('Error', 'Failed to delete kategori');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete kategori');
    }
  }
}
