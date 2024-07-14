import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kasirsql/models/transaksi_model.dart';
import 'package:kasirsql/models/barang_model.dart';

class TransaksiController extends GetxController {
  var selectedBarangList = <Map<String, dynamic>>[].obs;
  var totalHarga = 0.0.obs;
  var totalBarang = 0.obs;
  var bayar = 0.0.obs;
  var kembali = 0.0.obs;
  final String apiUrl = 'http://10.10.10.80/flutterapi/api_transaksi.php';

  void addBarangToCart(Barang barang) {
    var existingBarang = selectedBarangList.firstWhere(
      (element) => element['id'] == barang.id,
      orElse: () => {'id': barang.id, 'jumlah': 0},
    );

    if (existingBarang['jumlah'] == 0) {
      selectedBarangList.add({
        'id': barang.id,
        'nama': barang.namaBarang,
        'harga': barang.hargaJual,
        'jumlah': 1,
        'jumlah_harga': barang.hargaJual,
        'kode_barang': barang.kodeBarang,
        'stok_barang': barang.stokBarang,
        'kategori_id': barang.kategoriId,
        'nama_kategori': barang.namaKategori,
        'harga_beli': barang.hargaBeli,
      });
    } else {
      existingBarang['jumlah'] += 1;
      existingBarang['jumlah_harga'] = existingBarang['jumlah'] * existingBarang['harga'];
    }

    totalHarga.value += barang.hargaJual;
    totalBarang.value += 1;
  }

  int getTotalBarang() {
    return totalBarang.value;
  }

  void removeBarangFromCart(Barang barang) {
    var detailBarang = selectedBarangList.firstWhere((element) => element['id'] == barang.id);
    selectedBarangList.remove(detailBarang);
    totalHarga.value -= barang.hargaJual;
    totalBarang.value -= 1;
    }

  void updateBarangQuantity(Barang barang, int quantity) {
    var detailBarang = selectedBarangList.firstWhere((element) => element['id'] == barang.id);
    totalHarga.value -= detailBarang['harga'] * detailBarang['jumlah'];
    detailBarang['jumlah'] = quantity;
    detailBarang['jumlah_harga'] = detailBarang['harga'] * detailBarang['jumlah'];
    totalHarga.value += detailBarang['harga'] * detailBarang['jumlah'];
    }

  void createTransaksi() async {
    var now = DateTime.now();
    var transaksi = Transaksi(
      detailBarang: selectedBarangList,
      totalBarang: totalBarang.value,
      totalHarga: totalHarga.value,
      bayar: bayar.value,
      kembali: bayar.value - totalHarga.value,
      createdAt: now,
      updatedAt: now,
    );

    try {
      var response = await http.post(
        Uri.parse('$apiUrl?action=create_transaksi'),
        body: transaksi.toJson(),
      );
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        if (result['status'] == 'success') {
          Get.snackbar('Success', 'Transaksi berhasil dilakukan');
        } else {
          Get.snackbar('Error', 'Transaksi gagal: ${result['message']}');
        }
      } else {
        Get.snackbar('Error', 'Failed to create transaksi');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create transaksi');
    }
  }
}
