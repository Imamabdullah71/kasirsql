import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/hutang_controller/hutang_controller.dart';

class LunasPage extends StatelessWidget {
  final HutangController hutangController = Get.find();

  LunasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Lunas'),
      ),
      body: Obx(() {
        if (hutangController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: hutangController.lunasList.length,
          itemBuilder: (context, index) {
            var hutang = hutangController.lunasList[index];
            return ListTile(
              title: Text(hutang.tanggalMulai.toIso8601String()),
              subtitle: Text(hutang.status),
            );
          },
        );
      }),
    );
  }
}
