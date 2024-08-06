import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/supplier_controller/supplier_controller.dart';
import 'package:kasirsql/models/supplier_model.dart';

class EditSupplierPage extends StatelessWidget {
  final Supplier supplier;
  final TextEditingController namaSupplierController;
  final TextEditingController namaTokoSupplierController;
  final TextEditingController noTeleponController;
  final TextEditingController alamatController;
  final SupplierController supplierController = Get.find<SupplierController>();

  EditSupplierPage({super.key, required this.supplier})
      : namaSupplierController =
            TextEditingController(text: supplier.namaSupplier),
        namaTokoSupplierController =
            TextEditingController(text: supplier.namaTokoSupplier),
        noTeleponController = TextEditingController(text: supplier.noTelepon),
        alamatController = TextEditingController(text: supplier.alamat);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 114, 94, 225),
        ),
        title: const Text(
          "Edit Supplier",
          style: TextStyle(
            color: Color.fromARGB(255, 114, 94, 225),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 10.0,
        shadowColor: Colors.black.withOpacity(0.5),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(top: 32, left: 16, right: 16, bottom: 16),
        child: Column(
          children: [
            // Stack(
            //   children: [
            //     Obx(() {
            //       if (supplierController.selectedImagePath.value == '' &&
            //           supplier.gambar == null) {
            //         return const Icon(
            //           Icons.broken_image_rounded,
            //           color: Colors.grey,
            //           size: 120,
            //         );
            //       } else {
            //         return Container(
            //           height: 100,
            //           width: 100,
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(8),
            //             color: Colors.grey[300],
            //           ),
            //           child: ClipRRect(
            //             borderRadius: BorderRadius.circular(8),
            //             child: supplierController
            //                     .selectedImagePath.value.isEmpty
            //                 ? Image.network(
            //                     'http://10.10.10.129/flutterapi/uploads/${supplier.gambar}',
            //                     fit: BoxFit.cover,
            //                   )
            //                 : Image.file(
            //                     File(supplierController.selectedImagePath.value),
            //                     fit: BoxFit.cover,
            //                   ),
            //           ),
            //         );
            //       }
            //     }),
            //     Positioned(
            //       bottom: 0,
            //       right: 0,
            //       child: IconButton(
            //         icon: const Icon(BootstrapIcons.pencil),
            //         color: Colors.white,
            //         onPressed: () {
            //           isEditingImage.value = !isEditingImage.value;
            //         },
            //       ),
            //     ),
            //   ],
            // ),
            // Obx(() {
            //   if (isEditingImage.value) {
            //     return Padding(
            //       padding: const EdgeInsets.only(top: 8),
            //       child: Row(
            //         mainAxisAlignment: MainAxisAlignment.center,
            //         children: [
            //           DecoratedBox(
            //             decoration: BoxDecoration(
            //               gradient: const LinearGradient(
            //                 colors: [
            //                   Color.fromARGB(255, 229, 135, 246),
            //                   Color.fromARGB(255, 114, 94, 225),
            //                 ],
            //               ),
            //               borderRadius: BorderRadius.circular(30),
            //             ),
            //             child: ElevatedButton(
            //               style: ElevatedButton.styleFrom(
            //                 padding: const EdgeInsets.symmetric(
            //                     vertical: 10, horizontal: 20),
            //                 shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(30),
            //                 ),
            //                 backgroundColor: Colors.transparent,
            //                 shadowColor: Colors.transparent,
            //               ),
            //               onPressed: () {
            //                 pickImage(ImageSource.camera);
            //               },
            //               child: const Row(
            //                 children: [
            //                   Icon(
            //                     Icons.camera_alt_rounded,
            //                     size: 18,
            //                     color: Colors.white,
            //                   ),
            //                   SizedBox(width: 5),
            //                   Text(
            //                     'Kamera',
            //                     style: TextStyle(color: Colors.white),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //           const SizedBox(width: 10),
            //           DecoratedBox(
            //             decoration: BoxDecoration(
            //               gradient: const LinearGradient(
            //                 colors: [
            //                   Color.fromARGB(255, 229, 135, 246),
            //                   Color.fromARGB(255, 114, 94, 225),
            //                 ],
            //               ),
            //               borderRadius: BorderRadius.circular(30),
            //             ),
            //             child: ElevatedButton(
            //               style: ElevatedButton.styleFrom(
            //                 padding: const EdgeInsets.symmetric(
            //                     vertical: 10, horizontal: 20),
            //                 shape: RoundedRectangleBorder(
            //                   borderRadius: BorderRadius.circular(30),
            //                 ),
            //                 backgroundColor: Colors.transparent,
            //                 shadowColor: Colors.transparent,
            //               ),
            //               onPressed: () {
            //                 pickImage(ImageSource.gallery);
            //               },
            //               child: const Row(
            //                 children: [
            //                   Icon(Icons.image, size: 18, color: Colors.white),
            //                   SizedBox(width: 5),
            //                   Text(
            //                     'Galeri',
            //                     style: TextStyle(color: Colors.white),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //         ],
            //       ),
            //     );
            //   } else {
            //     return const SizedBox.shrink();
            //   }
            // }),
            // const SizedBox(height: 20),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: namaSupplierController,
              decoration: InputDecoration(
                labelText: 'Nama Supplier',
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 114, 94, 225),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade500,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                ),
                contentPadding: const EdgeInsets.only(left: 20),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama Supplier tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: namaTokoSupplierController,
              decoration: InputDecoration(
                labelText: 'Nama Toko Supplier',
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 114, 94, 225),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade500,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                ),
                contentPadding: const EdgeInsets.only(left: 20),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama Toko Supplier tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            TextFormField(
              keyboardType: TextInputType.number,
              controller: noTeleponController,
              decoration: InputDecoration(
                labelText: 'No Telepon',
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 114, 94, 225),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade500,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                ),
                contentPadding: const EdgeInsets.only(left: 20),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'No Telepon tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            TextFormField(
              keyboardType: TextInputType.text,
              controller: alamatController,
              decoration: InputDecoration(
                labelText: 'Alamat',
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 114, 94, 225),
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade500,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(30)),
                ),
                contentPadding: const EdgeInsets.only(left: 20),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Alamat tidak boleh kosong';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            InkWell(
              onTap: () {
                supplierController.updateSupplier(
                  supplier.id,
                  namaSupplierController.text,
                  namaTokoSupplierController.text,
                  noTeleponController.text,
                  alamatController.text,
                );
                Get.back();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
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
                child: const Center(
                  child: Text(
                    'Simpan',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
