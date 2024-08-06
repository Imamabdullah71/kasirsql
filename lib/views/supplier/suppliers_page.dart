import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/supplier_controller/supplier_controller.dart';
import 'package:kasirsql/models/supplier_model.dart';
import 'package:kasirsql/views/supplier/supplier_detail_page.dart';

class SuppliersPage extends StatelessWidget {
  SuppliersPage({super.key});
  final SupplierController supplierController = Get.find<SupplierController>();
  final TextEditingController searchController = TextEditingController();
  final RxString sortOrder = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 114, 94, 225),
        ),
        title: const Text(
          "Kelola Supplier",
          style: TextStyle(
            color: Color.fromARGB(255, 114, 94, 225),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 10.0,
        shadowColor: Colors.black.withOpacity(0.5),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () => _showSortOptions(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  prefixIcon: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 229, 135, 246),
                          Color.fromARGB(255, 114, 94, 225)
                        ],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ).createShader(bounds);
                    },
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                  hintText: "Cari supplier...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  supplierController.searchSupplier(value);
                },
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (supplierController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              var filteredSupplierList = supplierController.supplierList;

              switch (sortOrder.value) {
                case 'name_asc':
                  filteredSupplierList
                      .sort((a, b) => a.namaSupplier.compareTo(b.namaSupplier));
                  break;
                case 'name_desc':
                  filteredSupplierList
                      .sort((a, b) => b.namaSupplier.compareTo(a.namaSupplier));
                  break;
              }

              if (filteredSupplierList.isEmpty) {
                return const Center(
                  child: Text(
                    'Tidak ada supplier',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                itemCount: filteredSupplierList.length,
                itemBuilder: (context, index) {
                  final Supplier supplier = filteredSupplierList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 3,
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 16.0),
                        leading: supplier.gambar != null &&
                                supplier.gambar!.isNotEmpty
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: SizedBox(
                                  width: 55,
                                  height: 55,
                                  child: Image.network(
                                    'http://10.10.10.129/flutterapi/uploads/${supplier.gambar}',
                                    fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context,
                                        Widget child,
                                        ImageChunkEvent? loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      } else {
                                        return Center(
                                            child: CircularProgressIndicator(
                                          value: loadingProgress
                                                      .expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  loadingProgress
                                                      .expectedTotalBytes!
                                              : null,
                                          backgroundColor: Colors.grey[
                                              200], // Warna latar belakang indikator
                                          color: Colors
                                              .blue, // Warna utama indikator
                                          valueColor: const AlwaysStoppedAnimation<
                                                  Color>(
                                              Colors
                                                  .purple), // Animasi warna progres
                                          strokeWidth:
                                              5.0, // Lebar garis indikator
                                          strokeAlign: BorderSide
                                              .strokeAlignCenter, // Penjajaran stroke (default)
                                          semanticsLabel:
                                              'Loading image', // Label semantik untuk aksesibilitas
                                          semanticsValue:
                                              '${(loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! * 100).toStringAsFixed(0)}%', // Nilai semantik untuk aksesibilitas
                                          strokeCap: StrokeCap
                                              .round, // Bentuk ujung garis indikator
                                        ));
                                      }
                                    },
                                    errorBuilder: (BuildContext context,
                                        Object error, StackTrace? stackTrace) {
                                      return const Icon(
                                        Icons.broken_image,
                                        size: 50,
                                        color: Colors.grey,
                                      );
                                    },
                                  ),
                                ),
                              )
                            : const Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Colors.grey,
                              ),
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              supplier.namaSupplier,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              supplier.namaTokoSupplier ?? '-',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          supplier.noTelepon ?? '-',
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            color: Colors.grey),
                        onTap: () {
                          Get.to(() => SupplierDetailPage(supplier: supplier));
                        },
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: InkWell(
          onTap: () => Get.toNamed("/add_supplier"),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color.fromARGB(255, 229, 135, 246),
                  Color.fromARGB(255, 114, 94, 225),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(30.0),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Tambah Supplier",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSortOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Urutkan berdasarkan...'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Nama A - Z'),
                onTap: () {
                  sortOrder.value = 'name_asc';
                  supplierController.sortSupplierList(sortOrder.value);
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('Nama Z - A'),
                onTap: () {
                  sortOrder.value = 'name_desc';
                  supplierController.sortSupplierList(sortOrder.value);
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
