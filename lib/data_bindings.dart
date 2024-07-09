// data_bindings.dart
import 'package:get/get.dart';
import 'package:kasirsql/controllers/barang_controller.dart';
import 'package:kasirsql/controllers/tambah_barang_controller.dart';

class DataBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BarangController>(() => BarangController());
    Get.lazyPut<TambahBarangController>(() => TambahBarangController());
  }
}
