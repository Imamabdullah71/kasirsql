import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:kasirsql/controllers/barang_controller/barang_controller.dart';
import 'package:kasirsql/controllers/user_controller/user_controller.dart';
import 'package:kasirsql/models/harga_model.dart';
import 'package:kasirsql/models/kategori_model.dart';
import 'package:kasirsql/views/barang/edit_image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class TambahBarangController extends GetxController {
  var kategoriList = <Kategori>[].obs;
  var hargaList = <Harga>[].obs;
  var selectedImagePath = ''.obs;
  var croppedImage = Rx<Uint8List?>(null);
  final String apiUrl = 'http://192.168.135.56/flutterapi/api_barang.php';
  final ImagePicker _picker = ImagePicker();
  final UserController userController = Get.find<UserController>();

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
    try {
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
          Get.to(() => CropImagePage());
        } else {
          Get.snackbar('Error', 'Failed to compress image');
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image');
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

  void createBarang(String namaBarang, int kodeBarang, int stokBarang,
      int kategoriId, double hargaJual, double hargaBeli) async {
    try {
      String? gambar;
      if (croppedImage.value != null) {
        gambar = await uploadImage(croppedImage.value!);
      }

      final response = await http.post(
        Uri.parse('$apiUrl?action=create_barang'),
        body: {
          'nama_barang': namaBarang,
          'kode_barang': kodeBarang.toString(),
          'stok_barang': stokBarang.toString(),
          'kategori_id': kategoriId.toString(),
          'gambar': gambar ?? '',
        },
      );

      if (response.statusCode == 200) {
        var createdBarangId = json.decode(response.body)['id'];
        createHarga(hargaJual, hargaBeli, createdBarangId);
        Get.back();
        Get.snackbar('Berhasil', 'Berhasil menambahkan data barang');
        Get.find<BarangController>().fetchBarang();
      } else {
        Get.snackbar('Gagal', 'Gagal menambahkan data barang');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create barang');
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
        Get.snackbar('Gagal', 'Gagal menambahkan harga');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create harga');
    }
  }
}
