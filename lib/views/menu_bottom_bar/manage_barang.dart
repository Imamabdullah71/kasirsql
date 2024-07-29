// menu_bottom_bar\main_menu_barang.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

class ManageBarang extends StatelessWidget {
  const ManageBarang({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
        title: Text(
          "Manajemen".toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          ListTile(
            leading: const Icon(BootstrapIcons.grid),
            title: const Text("Kategori barang"),
            onTap: () {
              Get.toNamed("/page_kategori");
            },
          ),
          ListTile(
            leading: const Icon(BootstrapIcons.box_seam),
            title: const Text("Barang"),
            onTap: () {
              Get.toNamed("/page_barang");
            },
          ),
          ListTile(
            leading: const Icon(BootstrapIcons.boxes),
            title: const Text("Manajemen stok"),
            onTap: () => Get.toNamed("/kelola_stok_page"),
          ),
          ListTile(
            leading: const Icon(BootstrapIcons.cart4),
            title: const Text("Pembelian barang"),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(BootstrapIcons.person_vcard),
            title: const Text("Supplier"),
            onTap: () => Get.toNamed("/page_supplier"),
          ),
          ListTile(
            leading: const Icon(BootstrapIcons.bug_fill),
            title: const Text("TESTING"),
            onTap: () => Get.toNamed("/testing_page"),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed("/infaq_page");
        },
        child: const Icon(BootstrapIcons.plus_lg),
      ),
    );
  }
}
