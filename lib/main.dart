// main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/data_bindings.dart';
import 'package:kasirsql/views/barang/tambah_barang.dart';
import 'views/barang/barang_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: BarangView(),
      getPages: [
        GetPage(
          name: "/tambah_barang",
          page: () => TambahBarang(),
          binding: DataBindings(),
        ),
      ],
    );
  }
}
