import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/hutang_controller/hutang_controller.dart';
import 'package:intl/intl.dart';
import 'package:kasirsql/models/hutang_model.dart';
import 'package:kasirsql/views/hutang/riwayat_bayar_page.dart';

class LunasPage extends StatelessWidget {
  final HutangController hutangController = Get.find();
  final TextEditingController searchController = TextEditingController();
  final Rxn<DateTimeRange> selectedDateRange = Rxn<DateTimeRange>();
  final RxString sortOrder = ''.obs;
  final RxBool isPressed = false.obs;

  LunasPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 114, 94, 225),
        ),
        title: const Text(
          "Daftar Lunas",
          style: TextStyle(
            color: Color.fromARGB(255, 114, 94, 225),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 10.0, // Set the shadow
        shadowColor: Colors.black.withOpacity(0.5), // Customize shadow color
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () =>
                _showSortOptions(context), // Menambahkan ikon titik tiga
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
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
                        prefixIcon: const Icon(Icons.search),
                        hintText: "Cari hutang lunas...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          hutangController.lunasList.value =
                              hutangController.allLunasList;
                        } else {
                          _filterLunas();
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
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
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _showDateRangePicker(context),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (hutangController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              var filteredLunasList = hutangController.lunasList;

              if (searchController.text.isNotEmpty ||
                  selectedDateRange.value != null) {
                filteredLunasList = hutangController.lunasList
                    .where((hutang) {
                      final matchesQuery = hutang.nama
                          .toLowerCase()
                          .contains(searchController.text.toLowerCase());
                      final matchesDateRange = selectedDateRange.value ==
                              null ||
                          (hutang.tanggalMulai
                                  .isAfter(selectedDateRange.value!.start) &&
                              hutang.tanggalMulai.isBefore(selectedDateRange
                                  .value!.end
                                  .add(const Duration(days: 1))));
                      return matchesQuery && matchesDateRange;
                    })
                    .toList()
                    .obs;
              }

              switch (sortOrder.value) {
                case 'name_asc':
                  filteredLunasList.sort((a, b) => a.nama.compareTo(b.nama));
                  break;
                case 'name_desc':
                  filteredLunasList.sort((a, b) => b.nama.compareTo(a.nama));
                  break;
                case 'date_asc':
                  filteredLunasList
                      .sort((a, b) => a.tanggalMulai.compareTo(b.tanggalMulai));
                  break;
                case 'date_desc':
                  filteredLunasList
                      .sort((a, b) => b.tanggalMulai.compareTo(a.tanggalMulai));
                  break;
              }

              if (filteredLunasList.isEmpty) {
                return const Center(
                  child: Text(
                    'Belum ada hutang lunas',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                itemCount: filteredLunasList.length,
                itemBuilder: (context, index) {
                  var hutang = filteredLunasList[index];
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
                        title: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hutang.nama,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              formatTanggal(hutang.tanggalSelesai),
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        trailing: const Icon(
                          Icons.check,
                          color: Colors.green,
                          size: 30,
                        ),
                        onTap: () => _showDetailDialog(context, hutang),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      backgroundColor: Colors.white,
    );
  }

  void _showDateRangePicker(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDateRange: selectedDateRange.value,
    );
    if (picked != null && picked != selectedDateRange.value) {
      selectedDateRange.value = picked;
      _filterLunas();
    }
  }

  void _filterLunas() {
    final query = searchController.text.toLowerCase();
    final allLunas = hutangController.allLunasList;

    var filtered = allLunas.where((hutang) {
      final matchesQuery = hutang.nama.toLowerCase().contains(query);
      final matchesDateRange = selectedDateRange.value == null ||
          (hutang.tanggalMulai.isAfter(selectedDateRange.value!.start) &&
              hutang.tanggalMulai.isBefore(
                  selectedDateRange.value!.end.add(const Duration(days: 1))));
      return matchesQuery && matchesDateRange;
    }).toList();

    hutangController.lunasList.value = filtered;
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
                  _filterLunas();
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('Nama Z - A'),
                onTap: () {
                  sortOrder.value = 'name_desc';
                  _filterLunas();
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('Baru ditambahkan'),
                onTap: () {
                  sortOrder.value = 'date_desc';
                  _filterLunas();
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('Terlama ditambahkan'),
                onTap: () {
                  sortOrder.value = 'date_asc';
                  _filterLunas();
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showDetailDialog(BuildContext context, Hutang hutang) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
              child: Column(
            children: [
              Text('Detail Lunas'),
              Divider(
                color: Colors.grey, // Warna garis
                thickness: 1, // Ketebalan garis
              )
            ],
          )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Nama',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                hutang.nama,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tanggal Mulai',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                formatTanggal(hutang.tanggalMulai),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tanggal Selesai',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                formatTanggal(hutang.tanggalSelesai),
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ],
          ),
          actions: [
            Center(
              child: Obx(() {
                return GestureDetector(
                  onTapDown: (_) {
                    isPressed.value = true;
                  },
                  onTapUp: (_) {
                    isPressed.value = false;
                    Get.to(() => RiwayatBayarPage(hutangId: hutang.id!));
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      gradient: isPressed.value
                          ? const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 229, 135, 246),
                                Color.fromARGB(255, 114, 94, 225),
                              ],
                            )
                          : const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 114, 94, 225),
                                Color.fromARGB(255, 229, 135, 246),
                              ],
                            ),
                    ),
                    child: const Text(
                      'Riwayat Bayar',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 5),
            Center(
              child: Obx(() {
                return GestureDetector(
                  onTapDown: (_) {
                    isPressed.value = true;
                  },
                  onTapUp: (_) {
                    isPressed.value = false;
                    Navigator.of(context).pop();
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      gradient: isPressed.value
                          ? const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 229, 135, 246),
                                Color.fromARGB(255, 114, 94, 225),
                              ],
                            )
                          : const LinearGradient(
                              colors: [
                                Color.fromARGB(255, 114, 94, 225),
                                Color.fromARGB(255, 229, 135, 246),
                              ],
                            ),
                    ),
                    child: const Text(
                      'Tutup',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                );
              }),
            )
          ],
        );
      },
    );
  }

  String formatTanggal(DateTime date) {
    final DateFormat formatter = DateFormat('dd MMMM yyyy HH:mm', 'id_ID');
    return formatter.format(date);
  }

  String formatRupiah(double amount) {
    // Menggunakan nilai absolut untuk menghilangkan simbol minus
    double absoluteAmount = amount.abs();
    return 'Rp ${absoluteAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (match) => '.')}';
  }
}
