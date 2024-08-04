import 'dart:typed_data';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:kasirsql/controllers/barang_controller/barang_controller.dart';
import 'package:kasirsql/controllers/user_controller/user_controller.dart';
import 'package:kasirsql/models/barang_model.dart';
import 'package:kasirsql/models/harga_model.dart';
import 'package:kasirsql/models/kategori_model.dart';
import 'package:kasirsql/views/barang/crop_image_barang.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class TambahBarangController extends GetxController {
  var isLoading = false.obs;
  var kategoriList = <Kategori>[].obs;
  var hargaList = <Harga>[].obs;
  var selectedImagePath = ''.obs;
  var croppedImage = Rx<Uint8List?>(null);
  final String apiUrl = 'http://10.10.10.129/flutterapi/api_barang.php';
  final ImagePicker _picker = ImagePicker();
  final UserController userController = Get.find<UserController>();
  var barcodeUntukBarang = <Barang>[].obs;
  final TextEditingController kodeBarangController = TextEditingController();

  @override
  void onInit() {
    fetchKategori();
    super.onInit();
  }

  void fetchKategori() async {
    isLoading.value = true;
    try {
      final response = await http.get(Uri.parse(
          '$apiUrl?action=read_kategori&user_id=${userController.currentUser.value?.id}'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        kategoriList.value =
            data.map((kategori) => Kategori.fromJson(kategori)).toList();
      } else {
        Get.snackbar(
          'Error',
          'Gagal mengambil data kategori',
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
    } finally {
      isLoading.value = false;
    }
  }

  void pickImage(ImageSource source) async {
    isLoading.value = true;
    Get.defaultDialog(
      title: 'Loading...',
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
        ],
      ),
      barrierDismissible: false,
    );
    try {
      final pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        selectedImagePath.value = pickedFile.path;
        Get.back();
        Get.to(() => CropImageBarang());
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal mengambil gambar',
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
    } finally {
      isLoading.value = false;
      if (Get.isDialogOpen!) {
        Get.back();
      }
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

  void createBarang(String namaBarang, int barcodeBarang, int stokBarang,
      int kategoriId, double hargaJual, double hargaBeli) async {
    isLoading.value = true;
    Get.defaultDialog(
      title: 'Loading...',
      content: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
        ],
      ),
      barrierDismissible: false,
    );
    try {
      String? gambar;
      if (croppedImage.value != null) {
        gambar = await uploadImage(croppedImage.value!);
      }

      final response = await http.post(
        Uri.parse('$apiUrl?action=create_barang'),
        body: {
          'nama_barang': namaBarang,
          'barcode_barang': barcodeBarang.toString(),
          'stok_barang': stokBarang.toString(),
          'kategori_id': kategoriId.toString(),
          'gambar': gambar ?? '',
        },
      );

      var responseData = json.decode(response.body);
      if (response.statusCode == 200 && responseData['status'] == 'success') {
        var createdBarangId = responseData['id'];
        createHarga(hargaJual, hargaBeli, createdBarangId);
        Get.find<BarangController>().fetchBarang();
        Get.back(); // Menutup dialog loading pertama
        Get.back(); // Menutup halaman tambah barang
        Get.snackbar(
          'Success',
          'Berhasil menambahkan data barang',
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

        await Future.delayed(const Duration(seconds: 3));
      } else if (responseData['status'] == 'error' &&
          responseData['message'] == 'Barcode sudah tersedia') {
        Get.back(); // Menutup dialog loading pertama
        Get.snackbar(
          'Peringatan',
          'Barcode sudah tersedia.',
          backgroundColor: const Color.fromARGB(255, 235, 218, 63),
          colorText: Colors.black,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          snackPosition: SnackPosition.TOP,
          icon: const Icon(BootstrapIcons.exclamation_triangle_fill,
              color: Colors.black),
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
        Get.back(); // Menutup dialog loading pertama
        Get.snackbar(
          'Error',
          'Gagal menambahkan data barang',
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
      Get.back(); // Menutup dialog loading pertama
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
    } finally {
      isLoading.value = false;
    }
  }

  void createHarga(double hargaJual, double hargaBeli, int barangId) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl?action=create_harga'),
        body: {
          'harga_jual': hargaJual.toString(),
          'harga_beli': hargaBeli.toString(),
          'barang_id': barangId.toString(),
        },
      );
      if (response.statusCode == 200) {
        Get.find<BarangController>().fetchBarang();
      } else {
        Get.snackbar(
          'Error',
          'Gagal menambahkan harga',
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
      Get.snackbar(
        'Error',
        'Gagal membuat harga',
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

  void setBarcode(String barcode) {
    kodeBarangController.text = barcode;
  }
}
