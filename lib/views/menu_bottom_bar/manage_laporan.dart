// menu_bottom_bar\manage_laporan.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

class ManageLaporan extends StatelessWidget {
  const ManageLaporan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
        title: Text(
          "Laporan".toUpperCase(),
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
            leading: const Icon(BootstrapIcons.graph_up),
            title: const Text("Laporan Laba Rugi"),
            onTap: () => Get.toNamed("/laporan_page"),
          ),
          ListTile(
            leading: const Icon(BootstrapIcons.file_earmark_text),
            title: const Text("Hutang"),
            onTap: () {
              Get.toNamed("/hutang_page");
            },
          ),
        ],
      ),
    );
  }
}
