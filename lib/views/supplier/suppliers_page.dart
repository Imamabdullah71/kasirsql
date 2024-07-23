import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/supplier_controller/supplier_controller.dart';
import 'package:kasirsql/models/supplier_model.dart';
import 'package:kasirsql/views/supplier/supplier_detail_page.dart';

class SuppliersPage extends StatelessWidget {
  SuppliersPage({super.key});
  final SupplierController supplierController = Get.find<SupplierController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Kelola Supplier",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
      ),
      body: Obx(() {
        if (supplierController.supplierList.isEmpty) {
          return const Center(child: Text('Tidak ada supplier'));
        }
        return ListView.builder(
          itemCount: supplierController.supplierList.length,
          itemBuilder: (context, index) {
            final Supplier supplier = supplierController.supplierList[index];
            return ListTile(
              leading: supplier.gambar != null && supplier.gambar!.isNotEmpty
                  ? Image.network(
                      'http://10.0.171.198/flutterapi/uploads/${supplier.gambar}',
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    )
                  : const Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey,
                    ),
              title: Text(supplier.namaSupplier),
              subtitle: Text(supplier.namaTokoSupplier ?? '-'),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  supplierController.deleteSupplier(supplier.id);
                },
              ),
              onTap: () {
                Get.to(() => SupplierDetailPage(supplier: supplier));
              },
            );
          },
        );
      }),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 114, 94, 225),
            minimumSize: const Size(
              double.infinity, // Lebar
              48, // Tinggi
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          ),
          onPressed: () => Get.toNamed("/add_supplier"),
          child: const Text(
            "Tambah Supplier",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}
