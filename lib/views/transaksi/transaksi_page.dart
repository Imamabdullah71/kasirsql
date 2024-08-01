import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/barang_controller/barang_controller.dart';
import 'package:kasirsql/controllers/transaksi_controller/transaksi_controller.dart';

class TransaksiPage extends StatelessWidget {
  TransaksiPage({super.key});
  final BarangController barangController = Get.find<BarangController>();
  final TransaksiController transaksiController =
      Get.find<TransaksiController>();
  final TextEditingController searchController = TextEditingController();
  final RxList<String> selectedCategories = <String>[].obs;
  final Rxn<DateTimeRange> selectedDateRange = Rxn<DateTimeRange>();
  final RxString sortOrder = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 114, 94, 225),
        ),
        title: const Text(
          "Pilih Barang",
          style: TextStyle(
            color: Color.fromARGB(255, 114, 94, 225),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              _showSortOptions(context);
            },
            icon: const Icon(BootstrapIcons.three_dots_vertical),
          )
        ],
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 10.0, // Add this line to set the shadow
        shadowColor: Colors.black.withOpacity(0.5), // Customize shadow color
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 229, 135, 246),
                        Color.fromARGB(255, 114, 94, 225),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.filter_list),
                    color: Colors.white,
                    onPressed: () {
                      _showFilterModal(context);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
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
                        hintText: "Cari barang...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        _filterBarang();
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [
                        Color.fromARGB(255, 229, 135, 246),
                        Color.fromARGB(255, 114, 94, 225),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(BootstrapIcons.calendar4_week),
                    color: Colors.white,
                    onPressed: () async {
                      final DateTimeRange? picked = await showDateRangePicker(
                        context: context,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        initialDateRange: selectedDateRange.value,
                      );
                      if (picked != null && picked != selectedDateRange.value) {
                        selectedDateRange.value = picked;
                        _filterBarang();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Obx(() {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: barangController.kategoriList.map((kategori) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: FilterChip(
                      label: Text(kategori),
                      selected: selectedCategories.contains(kategori),
                      onSelected: (bool selected) {
                        if (selected) {
                          selectedCategories.add(kategori);
                        } else {
                          selectedCategories.remove(kategori);
                        }
                        _filterBarang();
                      },
                    ),
                  );
                }).toList(),
              ),
            );
          }),
          Expanded(
            child: Obx(() {
              if (barangController.filteredBarangList.isEmpty) {
                return const Center(child: Text('Tidak ada barang.'));
              }
              if (barangController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                itemCount: barangController.filteredBarangList.length,
                itemBuilder: (context, index) {
                  final barang = barangController.filteredBarangList[index];
                  return Obx(() {
                    var detailBarang =
                        transaksiController.selectedBarangList.firstWhere(
                      (element) => element['id'] == barang.id,
                      orElse: () => {'jumlah_barang': 0},
                    );

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        leading: SizedBox(
                          width: 55,
                          height: 55,
                          child: barang.gambar != null &&
                                  barang.gambar!.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    'http://10.10.10.129/flutterapi/uploads/${barang.gambar}',
                                    width: 55,
                                    height: 55,
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
                                            backgroundColor: Colors.grey[200],
                                            color: Colors.blue,
                                            valueColor:
                                                const AlwaysStoppedAnimation<
                                                    Color>(Colors.purple),
                                            strokeWidth: 5.0,
                                            strokeAlign:
                                                BorderSide.strokeAlignCenter,
                                            semanticsLabel: 'Loading image',
                                            semanticsValue:
                                                '${(loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! * 100).toStringAsFixed(0)}%',
                                            strokeCap: StrokeCap.round,
                                          ),
                                        );
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
                                )
                              : const Icon(
                                  Icons.image_not_supported,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                        ),
                        title: Text(
                          barang.namaBarang,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          barang.kodeBarang.toString(),
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        trailing: Text(
                          "X${detailBarang['jumlah_barang'] ?? 0}",
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        onTap: () {
                          transaksiController.addBarangToCart(barang);
                        },
                      ),
                    );
                  });
                },
              );
            }),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 114, 94, 225),
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          onPressed: () => Get.toNamed("/cart_page"),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                BootstrapIcons.cart3,
                color: Colors.white,
              ),
              Obx(() {
                return Text(
                  " (${transaksiController.totalBarang.value})",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                );
              }),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }

  void _showFilterModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Pilih Kategori'),
          content: SingleChildScrollView(
            child: Obx(() {
              return Wrap(
                spacing: 8.0,
                children: barangController.kategoriList.map((kategori) {
                  return FilterChip(
                    label: Text(kategori),
                    selected: selectedCategories.contains(kategori),
                    onSelected: (bool selected) {
                      if (selected) {
                        selectedCategories.add(kategori);
                      } else {
                        selectedCategories.remove(kategori);
                      }
                      _filterBarang();
                    },
                  );
                }).toList(),
              );
            }),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Selesai'),
            ),
          ],
        );
      },
    );
  }

  void _showSortOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Urutkan menurut...'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Nama A - Z'),
                onTap: () {
                  sortOrder.value = 'name_asc';
                  _filterBarang();
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('Nama Z - A'),
                onTap: () {
                  sortOrder.value = 'name_desc';
                  _filterBarang();
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('Baru ditambahkan'),
                onTap: () {
                  sortOrder.value = 'newest';
                  _filterBarang();
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('Terlama ditambahkan'),
                onTap: () {
                  sortOrder.value = 'oldest';
                  _filterBarang();
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _filterBarang() {
    final query = searchController.text.toLowerCase();
    final selected = selectedCategories.toList();
    final allBarang = barangController.allBarangList;

    var filtered = allBarang.where((barang) {
      final matchesQuery = barang.namaBarang.toLowerCase().contains(query);
      final matchesCategory =
          selected.isEmpty || selected.contains(barang.namaKategori);
      final matchesDateRange = selectedDateRange.value == null ||
          (barang.createdAt.isAfter(selectedDateRange.value!.start) &&
              barang.createdAt.isBefore(
                  selectedDateRange.value!.end.add(const Duration(days: 1))));
      return matchesQuery && matchesCategory && matchesDateRange;
    }).toList();

    switch (sortOrder.value) {
      case 'name_asc':
        filtered.sort((a, b) => a.namaBarang.compareTo(b.namaBarang));
        break;
      case 'name_desc':
        filtered.sort((a, b) => b.namaBarang.compareTo(a.namaBarang));
        break;
      case 'newest':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'oldest':
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }

    barangController.filteredBarangList.value = filtered;
  }
}
