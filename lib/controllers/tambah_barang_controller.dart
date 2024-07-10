import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/kategori_model.dart';
import '../models/harga_model.dart';

class TambahBarangController extends GetxController {
  var kategoriList = <Kategori>[].obs;
  var hargaList = <Harga>[].obs;
  final String apiUrl = 'http://10.10.10.162/flutterapi/api.php';

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

  void createBarang(String namaBarang, int kodeBarang, int stokBarang, int kategoriId, double hargaJual, double hargaBeli) async {
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
        // Get the created barang ID
        var createdBarangId = json.decode(response.body)['id'];
        
        // Create harga for the barang
        createHarga(hargaJual, hargaBeli, createdBarangId);

        Get.back();
        Get.snackbar('Success', 'Barang created successfully');
      } else {
        Get.snackbar('Error', 'Failed to create barang');
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
        fetchHarga();
        Get.snackbar('Success', 'Harga created successfully');
      } else {
        Get.snackbar('Error', 'Failed to create harga');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create harga');
    }
  }

  void fetchHarga() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl?action=read_harga'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        hargaList.value = data.map((harga) => Harga.fromJson(harga)).toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch harga');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to parse harga');
    }
  }

  void updateHarga(int id, double hargaJual, double hargaBeli) async {
  try {
    final response = await http.post(
      Uri.parse('$apiUrl?action=update_harga'),
      body: {
        'id': id.toString(),
        'harga_jual': hargaJual.toString(),
        'harga_beli': hargaBeli.toString(),
      },
    );
    if (response.statusCode == 200) {
      fetchHarga();
      Get.snackbar('Success', 'Harga updated successfully');
    } else {
      Get.snackbar('Error', 'Failed to update harga');
    }
  } catch (e) {
    Get.snackbar('Error', 'Failed to update harga');
    print('Error updating harga: $e');
  }
}

void deleteHarga(int id) async {
  try {
    final response = await http.post(
      Uri.parse('$apiUrl?action=delete_harga'),
      body: {'id': id.toString()},
    );
    if (response.statusCode == 200) {
      fetchHarga();
      Get.snackbar('Success', 'Harga deleted successfully');
    } else {
      Get.snackbar('Error', 'Failed to delete harga');
    }
  } catch (e) {
    Get.snackbar('Error', 'Failed to delete harga');
    print('Error deleting harga: $e');
  }
}
}
