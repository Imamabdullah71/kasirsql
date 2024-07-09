// controllers\barang\tambah_barang_controller.dart
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kasirsql/models/barang_model.dart';
import 'package:kasirsql/models/kategori_model.dart';
import 'dart:convert';

class TambahBarangController extends GetxController {
  var barangList = <Barang>[].obs;
  var kategoriList = <Kategori>[].obs;
  final String apiUrl = 'http://10.10.10.162/flutterapi/api.php';

  @override
  void onInit() {
    fetchKategori();
    super.onInit();
  }

  void fetchKategori() async {
    try {
      final response =
          await http.get(Uri.parse('$apiUrl?action=read_kategori'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        kategoriList.value =
            data.map((kategori) => Kategori.fromJson(kategori)).toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch kategori');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to parse kategori');
    }
  }

  void createBarang(
      String namaBarang, int kodeBarang, int stokBarang, int kategoriId) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl?action=create_barang'),
        body: {
          'nama_barang': namaBarang,
          'kode_barang': kodeBarang.toString(),
          'stok_barang': stokBarang.toString(),
          'kategori_id': kategoriId.toString(),
        },
      );
      if (response.statusCode == 200) {
        Get.back();
        Get.snackbar('Success', 'Barang created successfully');
      } else {
        Get.snackbar('Error', 'Failed to create barang');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create barang');
    }
  }
}
