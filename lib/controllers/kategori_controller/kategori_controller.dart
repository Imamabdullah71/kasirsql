import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kasirsql/models/kategori_model.dart';
import 'dart:convert';

class KategoriController extends GetxController {
  var kategoriList = <Kategori>[].obs;
  final String apiUrl = 'http://10.10.10.80/flutterapi/api_kategori.php';

  @override
  void onInit() {
    fetchKategori();
    super.onInit();
  }

  void fetchKategori() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl?action=read_kategori'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        kategoriList.value = data.map((kategori) => Kategori.fromJson(kategori)).toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch kategori');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to parse kategori');
    }
  }

  void createKategori(String namaKategori) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl?action=create_kategori'),
        body: {'nama_kategori': namaKategori},
      );
      if (response.statusCode == 200) {
        fetchKategori();
        Get.snackbar('Success', 'Kategori created successfully');
      } else {
        Get.snackbar('Error', 'Failed to create kategori');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create kategori');
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
