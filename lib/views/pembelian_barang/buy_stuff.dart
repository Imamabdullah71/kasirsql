// import 'package:bootstrap_icons/bootstrap_icons.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:kasirsql/controllers/barang_controller/barang_controller.dart';

// class BuyStuff extends StatelessWidget {
//   BuyStuff({super.key});
//   final BarangController barangController = Get.find<BarangController>();
//   final TextEditingController searchController = TextEditingController();
//   final RxList<String> selectedCategories = <String>[].obs;
//   final Rxn<DateTimeRange> selectedDateRange = Rxn<DateTimeRange>();
//   final RxString sortOrder = ''.obs;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(
//           color: Color.fromARGB(255, 114, 94, 225),
//         ),
//         title: const Text(
//           "Pembelian Barang",
//           style: TextStyle(
//             color: Color.fromARGB(255, 114, 94, 225),
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         actions: [
//           IconButton(
//             onPressed: () {
//               _showSortOptions(context);
//             },
//             icon: const Icon(BootstrapIcons.three_dots_vertical),
//           )
//         ],
//         elevation: 10.0, // Add this line to set the shadow
//         shadowColor: Colors.black.withOpacity(0.5), // Customize shadow color
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     gradient: const LinearGradient(
//                       colors: [
//                         Color.fromARGB(255, 229, 135, 246),
//                         Color.fromARGB(255, 114, 94, 225),
//                       ],
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 2,
//                         blurRadius: 7,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: IconButton(
//                     icon: const Icon(Icons.filter_list),
//                     color: Colors.white,
//                     onPressed: () {
//                       _showFilterModal(context);
//                     },
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(30),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.grey.withOpacity(0.5),
//                           spreadRadius: 2,
//                           blurRadius: 7,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: TextField(
//                       controller: searchController,
//                       decoration: InputDecoration(
//                         prefixIcon: ShaderMask(
//                           shaderCallback: (Rect bounds) {
//                             return const LinearGradient(
//                               colors: [
//                                 Color.fromARGB(255, 229, 135, 246),
//                                 Color.fromARGB(255, 114, 94, 225)
//                               ],
//                               begin: Alignment.centerLeft,
//                               end: Alignment.centerRight,
//                             ).createShader(bounds);
//                           },
//                           child: const Icon(
//                             Icons.search,
//                             color: Colors.white,
//                           ),
//                         ),
//                         hintText: "Cari barang...",
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(8),
//                           borderSide: BorderSide.none,
//                         ),
//                       ),
//                       onChanged: (value) {
//                         _filterBarang();
//                       },
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     shape: BoxShape.circle,
//                     gradient: const LinearGradient(
//                       colors: [
//                         Color.fromARGB(255, 229, 135, 246),
//                         Color.fromARGB(255, 114, 94, 225),
//                       ],
//                     ),
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.5),
//                         spreadRadius: 2,
//                         blurRadius: 7,
//                         offset: const Offset(0, 3),
//                       ),
//                     ],
//                   ),
//                   child: IconButton(
//                     icon: const Icon(BootstrapIcons.calendar4_week),
//                     color: Colors.white,
//                     onPressed: () async {
//                       final DateTimeRange? picked = await showDateRangePicker(
//                         context: context,
//                         firstDate: DateTime(2000),
//                         lastDate: DateTime.now(),
//                         initialDateRange: selectedDateRange.value,
//                       );
//                       if (picked != null && picked != selectedDateRange.value) {
//                         selectedDateRange.value = picked;
//                         _filterBarang();
//                       }
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Obx(() {
//             return SingleChildScrollView(
//               scrollDirection: Axis.horizontal,
//               child: Row(
//                 children: barangController.kategoriList.map((kategori) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                     child: FilterChip(
//                       label: Text(kategori),
//                       selected: selectedCategories.contains(kategori),
//                       onSelected: (bool selected) {
//                         if (selected) {
//                           selectedCategories.add(kategori);
//                         } else {
//                           selectedCategories.remove(kategori);
//                         }
//                         _filterBarang();
//                       },
//                     ),
//                   );
//                 }).toList(),
//               ),
//             );
//           }),
//           Expanded(
//             child: Obx(() {
//               if (barangController.filteredBarangList.isEmpty) {
//                 return const Center(child: Text('Tidak ada barang.'));
//               }
//               return ListView.builder(
//                 itemCount: barangController.filteredBarangList.length,
//                 itemBuilder: (context, index) {
//                   final barang = barangController.filteredBarangList[index];
//                   return ListTile(
//                     leading: barang.gambar != null && barang.gambar!.isNotEmpty
//                         ? ClipRRect(
//                             borderRadius: BorderRadius.circular(8),
//                             child: SizedBox(
//                               width: 55,
//                               height: 55,
//                               child: Image.network(
//                                 'http://10.10.10.129/flutterapi/uploads/${barang.gambar}',
//                                 fit: BoxFit.cover,
//                                 loadingBuilder: (BuildContext context,
//                                     Widget child,
//                                     ImageChunkEvent? loadingProgress) {
//                                   if (loadingProgress == null) {
//                                     return child;
//                                   } else {
//                                     return Center(
//                                         child: CircularProgressIndicator(
//                                       value:
//                                           loadingProgress.expectedTotalBytes !=
//                                                   null
//                                               ? loadingProgress
//                                                       .cumulativeBytesLoaded /
//                                                   loadingProgress
//                                                       .expectedTotalBytes!
//                                               : null,
//                                       backgroundColor: Colors.grey[
//                                           200], // Warna latar belakang indikator
//                                       color:
//                                           Colors.blue, // Warna utama indikator
//                                       valueColor: const AlwaysStoppedAnimation<
//                                               Color>(
//                                           Colors
//                                               .purple), // Animasi warna progres
//                                       strokeWidth: 5.0, // Lebar garis indikator
//                                       strokeAlign: BorderSide
//                                           .strokeAlignCenter, // Penjajaran stroke (default)
//                                       semanticsLabel:
//                                           'Loading image', // Label semantik untuk aksesibilitas
//                                       semanticsValue:
//                                           '${(loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! * 100).toStringAsFixed(0)}%', // Nilai semantik untuk aksesibilitas
//                                       strokeCap: StrokeCap
//                                           .round, // Bentuk ujung garis indikator
//                                     ));
//                                   }
//                                 },
//                                 errorBuilder: (BuildContext context,
//                                     Object error, StackTrace? stackTrace) {
//                                   return const Icon(
//                                     Icons.broken_image,
//                                     size: 50,
//                                     color: Colors.grey,
//                                   );
//                                 },
//                               ),
//                             ),
//                           )
//                         : const Icon(
//                             Icons.image_not_supported,
//                             size: 50,
//                             color: Colors.grey,
//                           ),
//                     title: Text(barang.namaBarang),
//                     subtitle: Text(
//                         'Harga Beli : ${barangController.formatRupiah(barang.hargaBeli)}'),
//                     trailing: Column(
//                       children: [
//                         Text('Stok : ${barang.stokBarang}'),
//                         Text(barangController.formatRupiah(barang.hargaJual)),
//                       ],
//                     ),
//                     onTap: () {},
//                   );
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//       floatingActionButton: Obx(() {
//         return GestureDetector(
//           onTapDown: (_) {
//             barangController.toggleButtonPress();
//           },
//           onTapUp: (_) {
//             barangController.toggleButtonPress();
//             Get.toNamed("/tambah_barang");
//           },
//           child: AnimatedContainer(
//             duration: const Duration(milliseconds: 200),
//             padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 100),
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(30.0),
//               gradient: barangController.isPressed.value
//                   ? const LinearGradient(
//                       colors: [
//                         Color.fromARGB(255, 229, 135, 246),
//                         Color.fromARGB(255, 114, 94, 225),
//                       ],
//                     )
//                   : const LinearGradient(
//                       colors: [
//                         Color.fromARGB(255, 114, 94, 225),
//                         Color.fromARGB(255, 229, 135, 246),
//                       ],
//                     ),
//             ),
//             child: const Text(
//               'Tambah Barang',
//               style: TextStyle(color: Colors.white, fontSize: 16),
//             ),
//           ),
//         );
//       }),
//     );
//   }

//   void _showFilterModal(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Pilih Kategori'),
//           content: SingleChildScrollView(
//             child: Obx(() {
//               return Wrap(
//                 spacing: 8.0,
//                 children: barangController.kategoriList.map((kategori) {
//                   return FilterChip(
//                     label: Text(kategori),
//                     selected: selectedCategories.contains(kategori),
//                     onSelected: (bool selected) {
//                       if (selected) {
//                         selectedCategories.add(kategori);
//                       } else {
//                         selectedCategories.remove(kategori);
//                       }
//                       _filterBarang();
//                     },
//                   );
//                 }).toList(),
//               );
//             }),
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Get.back();
//               },
//               child: const Text('Selesai'),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   void _showSortOptions(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Urutkan menurut...'),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 title: const Text('Nama A - Z'),
//                 onTap: () {
//                   sortOrder.value = 'name_asc';
//                   _filterBarang();
//                   Get.back();
//                 },
//               ),
//               ListTile(
//                 title: const Text('Nama Z - A'),
//                 onTap: () {
//                   sortOrder.value = 'name_desc';
//                   _filterBarang();
//                   Get.back();
//                 },
//               ),
//               ListTile(
//                 title: const Text('Baru ditambahkan'),
//                 onTap: () {
//                   sortOrder.value = 'newest';
//                   _filterBarang();
//                   Get.back();
//                 },
//               ),
//               ListTile(
//                 title: const Text('Terlama ditambahkan'),
//                 onTap: () {
//                   sortOrder.value = 'oldest';
//                   _filterBarang();
//                   Get.back();
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   void _filterBarang() {
//     final query = searchController.text.toLowerCase();
//     final selected = selectedCategories.toList();
//     final allBarang = barangController.allBarangList;

//     var filtered = allBarang.where((barang) {
//       final matchesQuery = barang.namaBarang.toLowerCase().contains(query);
//       final matchesCategory =
//           selected.isEmpty || selected.contains(barang.namaKategori);
//       final matchesDateRange = selectedDateRange.value == null ||
//           (barang.createdAt.isAfter(selectedDateRange.value!.start) &&
//               barang.createdAt.isBefore(
//                   selectedDateRange.value!.end.add(const Duration(days: 1))));
//       return matchesQuery && matchesCategory && matchesDateRange;
//     }).toList();

//     switch (sortOrder.value) {
//       case 'name_asc':
//         filtered.sort((a, b) => a.namaBarang.compareTo(b.namaBarang));
//         break;
//       case 'name_desc':
//         filtered.sort((a, b) => b.namaBarang.compareTo(a.namaBarang));
//         break;
//       case 'newest':
//         filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
//         break;
//       case 'oldest':
//         filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
//         break;
//     }

//     barangController.filteredBarangList.value = filtered;
//   }
// }
