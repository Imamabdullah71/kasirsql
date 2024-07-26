import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kasirsql/models/barang_model.dart';
import 'dart:convert';
import 'package:kasirsql/controllers/user_controller/user_controller.dart';

class BarangController extends GetxController {
  var barangList = <Barang>[].obs;
  var selectedBarang = Rxn<Barang>();
  final String apiUrl = 'http://192.168.135.56/flutterapi/api_barang.php';
  final UserController userController = Get.find<UserController>();

  @override
  void onInit() {
    fetchBarang();
    super.onInit();
  }

  void fetchBarang() async {
    try {
      final response = await http.get(Uri.parse(
          '$apiUrl?action=read_barang&user_id=${userController.currentUser.value?.id}'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        barangList.value =
            data.map((barang) => Barang.fromJson(barang)).toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to parse data');
    }
  }

  void fetchHarga() async {
    try {
      final response = await http.get(Uri.parse(
          '$apiUrl?action=read_barang&user_id=${userController.currentUser.value?.id}'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        barangList.value =
            data.map((barang) => Barang.fromJson(barang)).toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to parse data');
    }
  }

  void editBarang(Barang barang) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl?action=update_barang'),
        body: {
          'id': barang.id.toString(),
          'nama_barang': barang.namaBarang,
          'kode_barang': barang.kodeBarang.toString(),
          'stok_barang': barang.stokBarang.toString(),
          'kategori_id': barang.kategoriId.toString(),
          'gambar': barang.gambar ?? '',
          'harga_jual': barang.hargaJual.toString(),
          'harga_beli': barang.hargaBeli.toString(),
          'updated_at': DateTime.now().toIso8601String(),
        },
      );

      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          fetchBarang();
          Get.back();
          Get.snackbar('Success', 'Barang berhasil diupdate');
        } else {
          Get.snackbar('Error', responseData['message']);
        }
      } else {
        Get.snackbar('Error', 'Failed to update barang');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update barang: $e');
    }
  }

  String formatRupiah(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}';
  }
}
