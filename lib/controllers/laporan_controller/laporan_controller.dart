import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:kasirsql/models/transaksi_model.dart';

class LaporanController extends GetxController {
  var totalPemasukan = 0.0.obs;
  var totalPengeluaran = 0.0.obs;
  var labaBersih = 0.0.obs;

  void fetchLaporan(String periode) async {
    final response = await http.post(
      Uri.parse('http://10.10.10.129/flutterapi/api_laporan.php'),
      body: {'periode': periode},
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      double pemasukan = 0;
      double pengeluaran = 0;

      for (var item in data) {
        Transaksi transaksi = Transaksi.fromJson(item);
        pemasukan += transaksi.totalHarga;
        pengeluaran += transaksi.totalHargaBeli;
      }

      totalPemasukan.value = pemasukan;
      totalPengeluaran.value = pengeluaran;
      labaBersih.value = pemasukan - pengeluaran;
    } else {
      Get.snackbar('Error', 'Gagal mengambil data laporan');
    }
  }

  String formatRupiah(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}';
  }
}
