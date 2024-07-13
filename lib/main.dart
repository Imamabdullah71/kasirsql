// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/data_bindings.dart';
import 'package:kasirsql/salomon_bottom_bar.dart';
import 'package:kasirsql/views/barang/barang.dart';
import 'package:kasirsql/views/barang/tambah_barang.dart';
import 'package:kasirsql/views/kategori/kategori_page.dart';
import 'package:kasirsql/views/supplier/suppliers_page.dart';
import 'package:kasirsql/views/supplier/tambah_supplier.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: BottomBar(),
      getPages: [
        // Barang
        GetPage(
          name: "/page_barang",
          page: () => BarangPage(),
          binding: DataBindings(),
        ),
        GetPage(
          name: "/tambah_barang",
          page: () => TambahBarang(),
          binding: DataBindings(),
        ),
        // Kategori
        GetPage(
          name: "/page_kategori",
          page: () => CategoriesPage(),
          binding: DataBindings(),
        ),
        // Supplier
        GetPage(
          name: "/page_supplier",
          page: () => SuppliersPage(),
          binding: DataBindings(),
        ),
        GetPage(
          name: "/add_supplier",
          page: () => AddSupplierPage(),
          binding: DataBindings(),
        ),
      ],
    );
  }
}