// controllers\barang_controller.dart
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/barang_model.dart';

class BarangController extends GetxController {
  var barangList = <Barang>[].obs;
  final String apiUrl = 'http://10.10.10.162/flutterapi/api.php';

  @override
  void onInit() {
    fetchBarang();
    super.onInit();
  }

  void fetchBarang() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl?action=read_barang'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        barangList.value =
            data.map((barang) => Barang.fromJson(barang)).toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to parse data');
      print(e);
    }
  }
}

