import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/data_bindings.dart';
import 'package:kasirsql/models/barang_model.dart';
import 'package:kasirsql/salomon_bottom_bar.dart';
import 'package:kasirsql/views/auth/auth_middleware.dart';
import 'package:kasirsql/views/auth/login.dart';
import 'package:kasirsql/views/auth/register.dart';
import 'package:kasirsql/views/barang/barang.dart';
import 'package:kasirsql/views/barang/detail_barang.dart';
import 'package:kasirsql/views/barang/edit_barang.dart';
import 'package:kasirsql/views/barang/tambah_barang.dart';
import 'package:kasirsql/views/kategori/kategori_page.dart';
import 'package:kasirsql/views/kelola_stok/kelola_stok.dart';
import 'package:kasirsql/views/profile/profile_page.dart';
import 'package:kasirsql/views/riwayat_transaksi/transaksi_history_page.dart';
import 'package:kasirsql/views/supplier/suppliers_page.dart';
import 'package:kasirsql/views/supplier/tambah_supplier.dart';
import 'package:kasirsql/views/transaksi/cart_page.dart';
import 'package:kasirsql/views/transaksi/transaksi_page.dart';
import 'package:kasirsql/controllers/user_controller/user_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final UserController userController = Get.put(UserController());
  await userController.loadUserFromPreferences();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final UserController userController = Get.find();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: userController.currentUser.value != null
          ? '/halaman_utama'
          : '/login',
      getPages: [
        GetPage(
          name: "/login",
          page: () => LoginPage(),
          binding: DataBindings(),
        ),
        GetPage(name: "/register", page: () => RegisterPage()),
        GetPage(
            name: "/halaman_utama",
            page: () => BottomBar(),
            middlewares: [AuthMiddleware()]),
        // Profile
        GetPage(
            name: "/profile",
            page: () => ProfilePage(),
            binding: DataBindings(),
            middlewares: [AuthMiddleware()]),
        // Barang
        GetPage(
            name: "/page_barang",
            page: () => BarangPage(),
            binding: DataBindings(),
            middlewares: [AuthMiddleware()]),
        GetPage(
            name: "/page_detail_barang",
            page: () => BarangDetailPage(),
            binding: DataBindings(),
            middlewares: [AuthMiddleware()]),
        GetPage(
            name: "/edit_barang",
            page: () => EditBarangPage(barang: Get.arguments as Barang),
            middlewares: [AuthMiddleware()]),
        // Kelola Stok Barang
        GetPage(
            name: "/kelola_stok_page",
            page: () => KelolaStokPage(),
            binding: DataBindings(),
            middlewares: [AuthMiddleware()]),
        GetPage(
            name: "/tambah_barang",
            page: () => TambahBarang(),
            binding: DataBindings(),
            middlewares: [AuthMiddleware()]),
        // Kategori
        GetPage(
            name: "/page_kategori",
            page: () => CategoriesPage(),
            binding: DataBindings(),
            middlewares: [AuthMiddleware()]),
        // Supplier
        GetPage(
            name: "/page_supplier",
            page: () => SuppliersPage(),
            binding: DataBindings(),
            middlewares: [AuthMiddleware()]),
        GetPage(
            name: "/add_supplier",
            page: () => AddSupplierPage(),
            binding: DataBindings(),
            middlewares: [AuthMiddleware()]),
        // Transaksi
        GetPage(
            name: "/transaksi_page",
            page: () => TransaksiPage(),
            binding: DataBindings(),
            middlewares: [AuthMiddleware()]),
        GetPage(
            name: "/cart_page",
            page: () => CartPage(),
            binding: DataBindings(),
            middlewares: [AuthMiddleware()]),
        // Riwayat Transaksi
        GetPage(
            name: "/riwayat_transaksi",
            page: () => TransaksiHistoryPage(),
            binding: DataBindings(),
            middlewares: [AuthMiddleware()]),
      ],
    );
  }
}
