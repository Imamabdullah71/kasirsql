import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/barang_controller/barang_controller.dart';
import 'package:kasirsql/controllers/switch_controller/switch_controller.dart';

class TesttingPage extends StatelessWidget {
  const TesttingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final SwitchController switchController = Get.find<SwitchController>();

    // Tambahkan controller untuk mengatur tampilan CircularProgressIndicator
    final RxBool isLoading = false.obs;

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "TESTING PAGE",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(
              () => Switch(
                value: switchController.isSwitched.value,
                onChanged: switchController.toggleSwitch,
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => ElevatedButton(
                onPressed: () {
                  isLoading.value = !isLoading.value;
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 114, 94, 225),
                ),
                child: const Text("Tampilkan Loading"),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => isLoading.value
                  ? CircularProgressIndicator(
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Colors.deepPurple,
                      ),
                      backgroundColor: Colors.purple.shade200,
                      strokeWidth: 6.0,
                    )
                  : Container(),
            ),
          ],
        ),
      ),
    );
  }
}

// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:kasirsql/controllers/barang_controller/barang_controller.dart';

// class BarangPage extends StatelessWidget {
//   BarangPage({super.key});
//   final BarangController barangController = Get.find<BarangController>();
//   final TextEditingController searchController = TextEditingController();
//   final List<String> categories = ['Category 1', 'Category 2', 'Category 3'];
//   final Map<String, bool> selectedCategories = {
//     'Category 1': false,
//     'Category 2': false,
//     'Category 3': false,
//   };

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: const IconThemeData(
//           color: Colors.white,
//         ),
//         title: const Text(
//           "Daftar Barang",
//           style: TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//         backgroundColor: const Color.fromARGB(255, 114, 94, 225),
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: Row(
//               children: [
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
//                         // Functionality to filter the list will be added later
//                       },
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 Container(
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     gradient: LinearGradient(
//                       colors: [
//                         Color.fromARGB(255, 229, 135, 246),
//                         Color.fromARGB(255, 114, 94, 225),
//                       ],
//                     ),
//                   ),
//                   child: IconButton(
//                     icon: const Icon(Icons.filter_list),
//                     color: Colors.white,
//                     onPressed: () {
//                       _showFilterModal(context);
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Expanded(
//             child: Obx(() {
//               if (barangController.filteredBarangList.isEmpty) {
//                 return const Center(child: Text('Tidak ada data barang'));
//               }
//               if (barangController.isLoading.value) {
//                 return const Center(child: CircularProgressIndicator());
//               }
//               return ListView.builder(
//                 itemCount: barangController.filteredBarangList.length,
//                 itemBuilder: (context, index) {
//                   final barang = barangController.filteredBarangList[index];
//                   return ListTile(
//                     onTap: () =>
//                         Get.toNamed("/page_detail_barang", arguments: barang),
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
//                                       backgroundColor: Colors.grey[200],
//                                       color: Colors.blue,
//                                       valueColor:
//                                           const AlwaysStoppedAnimation<Color>(
//                                               Colors.red),
//                                       strokeWidth: 5.0,
//                                       strokeAlign: BorderSide.strokeAlignCenter,
//                                       semanticsLabel: 'Loading image',
//                                       semanticsValue:
//                                           '${(loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! * 100).toStringAsFixed(0)}%',
//                                       strokeCap: StrokeCap.round,
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
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('${barang.kodeBarang}'),
//                         Text(
//                             'Harga Beli : ${barangController.formatRupiah(barang.hargaBeli)}'),
//                       ],
//                     ),
//                     trailing: Column(
//                       children: [
//                         Text(
//                           'Stok : ${barang.stokBarang}',
//                           style: const TextStyle(fontSize: 15),
//                         ),
//                         Text(
//                           barangController.formatRupiah(barang.hargaJual),
//                           style: const TextStyle(fontSize: 15),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               );
//             }),
//           ),
//         ],
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
//             Get.toNamed("/tambah_barang");
//           },
//           child: const Text(
//             "Tambah Barang",
//             style: TextStyle(color: Colors.white, fontSize: 20),
//           ),
//         ),
//       ),
//     );
//   }

//   void _showFilterModal(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       builder: (BuildContext context) {
//         return DraggableScrollableSheet(
//           expand: false,
//           builder: (BuildContext context, ScrollController scrollController) {
//             return Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: ListView(
//                 controller: scrollController,
//                 children: [
//                   const Text(
//                     'Filter',
//                     style: TextStyle(
//                       fontSize: 24,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     'Category',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Column(
//                     children: categories.map((String category) {
//                       return CheckboxListTile(
//                         title: Text(category),
//                         value: selectedCategories[category],
//                         onChanged: (bool? value) {
//                           selectedCategories[category] = value ?? false;
//                         },
//                       );
//                     }).toList(),
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     'Price Range',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   RangeSlider(
//                     values: const RangeValues(1000, 12000),
//                     min: 0,
//                     max: 20000,
//                     divisions: 100,
//                     labels: const RangeLabels('1000', '12000'),
//                     onChanged: (RangeValues values) {},
//                   ),
//                   const SizedBox(height: 20),
//                   const Text(
//                     'Rating',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Row(
//                     children: List.generate(5, (index) {
//                       return Icon(
//                         Icons.star,
//                         color: index < 3 ? Colors.orange : Colors.grey,
//                       );
//                     }),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: const Color.fromARGB(255, 114, 94, 225),
//                       minimumSize: const Size(
//                         double.infinity,
//                         48,
//                       ),
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 10, horizontal: 20),
//                     ),
//                     child: const Text(
//                       'Apply',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         );
//       },
//     );
//   }
// }