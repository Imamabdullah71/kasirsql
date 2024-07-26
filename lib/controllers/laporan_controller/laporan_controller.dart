import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LaporanController extends GetxController {
  var totalPemasukan = 0.0.obs;
  var totalPengeluaran = 0.0.obs;
  var labaBersih = 0.0.obs;

  Future<void> getLaporan({required String startDate, required String endDate}) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.135.56/flutterapi/api_laporan.php?action=get_laporan'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"start_date": startDate, "end_date": endDate}),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        totalPemasukan.value = data['total_pemasukan'];
        totalPengeluaran.value = data['total_pengeluaran'];
        labaBersih.value = totalPemasukan.value - totalPengeluaran.value;
      } else {
        Get.snackbar('Error', 'Failed to fetch report');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
    }
  }
}
