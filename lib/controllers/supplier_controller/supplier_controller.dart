import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:kasirsql/models/supplier_model.dart';

class SupplierController extends GetxController {
  var supplierList = <Supplier>[].obs;
  final String apiUrl = 'http://10.10.10.80/flutterapi/api_supplier.php';

  @override
  void onInit() {
    fetchSupplier();
    super.onInit();
  }

  void fetchSupplier() async {
    try {
      final response = await http.get(Uri.parse('$apiUrl?action=read_supplier'));
      if (response.statusCode == 200) {
        var data = json.decode(response.body) as List;
        supplierList.value = data.map((supplier) => Supplier.fromJson(supplier)).toList();
      } else {
        Get.snackbar('Error', 'Failed to fetch supplier');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to parse supplier');
    }
  }

  void deleteSupplier(int id) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl?action=delete_supplier'),
        body: {'id': id.toString()},
      );
      if (response.statusCode == 200) {
        fetchSupplier();
        Get.snackbar('Success', 'Supplier deleted successfully');
      } else {
        Get.snackbar('Error', 'Failed to delete supplier');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete supplier');
    }
  }
}
