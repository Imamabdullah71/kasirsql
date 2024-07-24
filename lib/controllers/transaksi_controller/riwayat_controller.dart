import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RiwayatController extends GetxController {
  final String apiUrl = 'http://10.10.10.129/flutterapi/api_transaksi.php';

  Future<List> getTransaksi() async {
    final response = await http.post(
      Uri.parse('$apiUrl?action=get_transaksi'),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      return data;
    } else {
      throw Exception('Failed to load transaksi');
    }
  }

  String formatRupiah(double amount) {
    return amount
        .toStringAsFixed(0)
        .replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.');
  }
}
