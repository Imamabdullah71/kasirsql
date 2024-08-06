// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:kasirsql/controllers/kategori_controller/kategori_controller.dart';

// class AddKategoriPage extends StatelessWidget {
//   AddKategoriPage({super.key});
//   final KategoriController kategoriController = Get.find<KategoriController>();
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   final TextEditingController namaKategoriController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(
//           color: Color.fromARGB(255, 114, 94, 225),
//         ),
//         title: const Text(
//           "Tambah Kategori",
//           style: TextStyle(
//             color: Color.fromARGB(255, 114, 94, 225),
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 10.0,
//         shadowColor: Colors.black.withOpacity(0.5),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(10),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: TextFormField(
//                   controller: namaKategoriController,
//                   decoration: InputDecoration(
//                     labelText: 'Nama Kategori',
//                     filled: true,
//                     fillColor: Colors.white,
//                     border: const OutlineInputBorder(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(30),
//                       ),
//                     ),
//                     focusedBorder: const OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(30)),
//                       borderSide: BorderSide(
//                         color: Color.fromARGB(255, 114, 94, 225),
//                       ),
//                     ),
//                     enabledBorder: OutlineInputBorder(
//                       borderSide: BorderSide(
//                         color: Colors.grey.shade500,
//                       ),
//                       borderRadius: const BorderRadius.all(Radius.circular(30)),
//                     ),
//                     contentPadding: const EdgeInsets.only(left: 20),
//                   ),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Nama Kategori tidak boleh kosong';
//                     }
//                     return null;
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.only(left: 30),
//         child: ElevatedButton(
//           style: ElevatedButton.styleFrom(
//             backgroundColor: const Color.fromARGB(255, 114, 94, 225),
//             minimumSize: const Size(
//               double.infinity, // Lebar
//               48, // Tinggi
//             ),
//             padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//           ),
//           onPressed: () {
//             if (_formKey.currentState!.validate()) {
//               kategoriController.createKategori(
//                 namaKategoriController.text,
//               );
//             }
//           },
//           child: const Text(
//             "Tambahkan",
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//         ),
//       ),
//     );
//   }
// }
