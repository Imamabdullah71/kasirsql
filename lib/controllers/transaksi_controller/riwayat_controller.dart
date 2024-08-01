import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:kasirsql/models/detail_transaksi_model.dart';
import 'package:kasirsql/models/transaksi_model.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class RiwayatController extends GetxController {
  var isLoading = false.obs;
  var transaksiList = <Transaksi>[].obs;
  var detailTransaksiList = <DetailTransaksi>[].obs;
  var isPressed = false.obs; // Observable for button press state

  @override
  void onInit() {
    super.onInit();
    fetchTransaksi();
  }

  void fetchTransaksi() async {
    isLoading.value = true;
    try {
      final response = await http
          .get(Uri.parse('http://10.10.10.129/flutterapi/api_riwayat.php'));

      if (response.statusCode == 200) {
        final responseBody = response.body;

        print("Response Body: $responseBody"); // Log response body

        if (isJson(responseBody)) {
          List jsonResponse = json.decode(responseBody);
          transaksiList.value =
              jsonResponse.map((data) => Transaksi.fromJson(data)).toList();
          transaksiList.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load transaksi: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching transaksi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void fetchDetailTransaksi(int transaksiId) async {
    try {
      final response = await http.get(Uri.parse(
          'http://10.10.10.129/flutterapi/api_riwayat.php?transaksi_id=$transaksiId'));

      if (response.statusCode == 200) {
        final responseBody = response.body;

        print("Response Body: $responseBody"); // Log response body

        if (isJson(responseBody)) {
          List jsonResponse = json.decode(responseBody);
          detailTransaksiList.value = jsonResponse
              .map((data) => DetailTransaksi.fromJson(data))
              .toList();
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception(
            'Failed to load detail transaksi: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching detail transaksi: $e');
    }
  }

  bool isJson(String str) {
    try {
      json.decode(str);
      return true;
    } catch (e) {
      return false;
    }
  }

  String formatTanggal(DateTime date) {
    final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');
    return formatter.format(date);
  }

  String formatRupiah(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}';
  }

  void toggleButtonPress() {
    isPressed.value = !isPressed.value;
  }
}
