import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:kasirsql/controllers/transaksi_controller/riwayat_controller.dart';
import 'transaksi_detail_page.dart';

class TransaksiHistoryPage extends StatelessWidget {
  final RiwayatController controller = Get.put(RiwayatController());
  final TextEditingController searchController = TextEditingController();
  final Rxn<DateTimeRange> selectedDateRange = Rxn<DateTimeRange>();
  final RxString sortOrder = ''.obs;

  TransaksiHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Riwayat Transaksi",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              _showSortOptions(context);
            },
            icon: const Icon(BootstrapIcons.three_dots_vertical),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
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
                        hintText: "Cari transaksi...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        _filterTransaksi();
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
                    onPressed: () => _showDateRangePicker(context),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.transaksiList.isEmpty) {
                return const Center(
                  child: Text(
                    'Belum ada transaksi',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                itemCount: controller.transaksiList.length,
                itemBuilder: (context, index) {
                  final transaksi = controller.transaksiList[index];
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
                        title: Text(
                          controller.formatTanggal(transaksi.createdAt),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          'Total: ${controller.formatRupiah(transaksi.totalHarga)}',
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            color: Colors.grey),
                        onTap: () {
                          controller.fetchDetailTransaksi(transaksi.id!);
                          Get.to(
                            () => TransaksiDetailPage(transaksi: transaksi),
                            transition: Transition.cupertino,
                          );
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
      _filterTransaksi();
    }
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
                title: const Text('Baru ditambahkan'),
                onTap: () {
                  sortOrder.value = 'newest';
                  _filterTransaksi();
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('Terlama ditambahkan'),
                onTap: () {
                  sortOrder.value = 'oldest';
                  _filterTransaksi();
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('Harga Terendah'),
                onTap: () {
                  sortOrder.value = 'lowest_price';
                  _filterTransaksi();
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('Harga Tertinggi'),
                onTap: () {
                  sortOrder.value = 'highest_price';
                  _filterTransaksi();
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _filterTransaksi() {
    final query = searchController.text.toLowerCase();
    final allTransaksi = controller.transaksiList;

    var filtered = allTransaksi.where((transaksi) {
      final matchesQuery = transaksi.totalBarang.toString().contains(query) ||
          transaksi.totalHarga.toString().contains(query) ||
          transaksi.totalHargaBeli.toString().contains(query) ||
          transaksi.bayar.toString().contains(query) ||
          transaksi.kembali.toString().contains(query) ||
          transaksi.userId.toString().contains(query);
      final matchesDateRange = selectedDateRange.value == null ||
          (transaksi.createdAt.isAfter(selectedDateRange.value!.start) &&
              transaksi.createdAt.isBefore(
                  selectedDateRange.value!.end.add(const Duration(days: 1))));
      return matchesQuery && matchesDateRange;
    }).toList();

    switch (sortOrder.value) {
      case 'newest':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'oldest':
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
      case 'lowest_price':
        filtered.sort((a, b) => a.totalHarga.compareTo(b.totalHarga));
        break;
      case 'highest_price':
        filtered.sort((a, b) => b.totalHarga.compareTo(a.totalHarga));
        break;
    }

    controller.transaksiList.value = filtered;
  }
}
