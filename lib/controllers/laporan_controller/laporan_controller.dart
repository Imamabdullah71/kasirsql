import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LaporanController extends GetxController {
  var totalPemasukan = 0.0.obs;
  var totalPengeluaran = 0.0.obs;
  var labaBersih = 0.0.obs;
  var years = <int>[].obs;
  var months = <String>[].obs;

  Future<void> getLaporan({required String startDate, required String endDate}) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.10.10.129/flutterapi/api_laporan.php?action=get_laporan'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"start_date": startDate, "end_date": endDate}),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        
        // Konversi nilai ke double
        totalPemasukan.value = double.parse(data['total_pemasukan'].toString());
        totalPengeluaran.value = double.parse(data['total_pengeluaran'].toString());
        labaBersih.value = totalPemasukan.value - totalPengeluaran.value;
      } else {
        Get.snackbar('Error', 'Failed to fetch report');
      }
    } catch (e) {
      Get.snackbar('Error', 'GET LAPORAN : $e');
      print("Error', 'GET LAPORAN : $e");
    }
  }

  Future<void> fetchYears() async {
    try {
      final response = await http.get(
        Uri.parse('http://10.10.10.129/flutterapi/api_laporan.php?action=get_years'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        years.value = List<int>.from(data['years'].map((year) => int.parse(year.toString()))); // Konversi data menjadi integer
      } else {
        Get.snackbar('Error', 'Failed to fetch years');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
      print("Error', 'FETCH Year : $e");
    }
  }

  Future<void> fetchMonths(int year) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.10.10.129/flutterapi/api_laporan.php?action=get_months&year=$year'),
      );

      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        months.value = List<String>.from(data['months']);
      } else {
        Get.snackbar('Error', 'Failed to fetch months');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e');
      print("Error', 'FETCH Months : $e");
    }
  }
}
