// data_bindings.dart
import 'package:get/get.dart';
import 'package:kasirsql/controllers/barang_controller/barang_controller.dart';
import 'package:kasirsql/controllers/barang_controller/tambah_barang_controller.dart';
import 'package:kasirsql/controllers/kategori_controller/kategori_controller.dart';
import 'package:kasirsql/controllers/kelola_stok_controller/kelola_stok_page_controller.dart';
import 'package:kasirsql/controllers/supplier_controller/add_supplier_controller.dart';
import 'package:kasirsql/controllers/supplier_controller/supplier_controller.dart';
import 'package:kasirsql/controllers/transaksi_controller/transaksi_controller.dart';

class DataBindings extends Bindings {
  @override
  void dependencies() {
    // Barang
    Get.lazyPut<BarangController>(() => BarangController());
    Get.lazyPut<TambahBarangController>(() => TambahBarangController());
    // Kelola Stok
    Get.lazyPut<KelolaStokPageController>(() => KelolaStokPageController());
    // Kategori
    Get.lazyPut<KategoriController>(() => KategoriController());
    // Supplier
    Get.lazyPut<SupplierController>(() => SupplierController());
    Get.lazyPut<AddSupplierController>(() => AddSupplierController());
    // Transaksi
    Get.lazyPut<TransaksiController>(() => TransaksiController());
  }
}