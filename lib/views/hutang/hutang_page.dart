import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kasirsql/controllers/barang_controller/rupiah_input_formatter.dart';
import 'package:kasirsql/controllers/hutang_controller/hutang_controller.dart';
import 'package:kasirsql/models/hutang_model.dart';
import 'package:kasirsql/views/hutang/lunas_page.dart';
import 'package:kasirsql/views/hutang/riwayat_bayar_page.dart';

class HutangPage extends StatelessWidget {
  final HutangController hutangController = Get.put(HutangController());
  final TextEditingController searchController = TextEditingController();
  final Rxn<DateTimeRange> selectedDateRange = Rxn<DateTimeRange>();
  final RxBool isPressed = false.obs;
  final RxString sortOrder = ''.obs; // Menyimpan status urutan

  HutangPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 114, 94, 225),
        ),
        title: const Text(
          "Hutang",
          style: TextStyle(
            color: Color.fromARGB(255, 114, 94, 225),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Obx(() {
              return GestureDetector(
                onTapDown: (_) {
                  isPressed.value = true;
                },
                onTapUp: (_) {
                  isPressed.value = false;
                  Get.to(() => LunasPage());
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
                    'Lunas',
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              );
            }),
          ),
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
                IconButton(
                  icon: const Icon(Icons.more_vert),
                  onPressed: () =>
                      _showSortOptions(context), // Menambahkan ikon titik tiga
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
                        hintText: "Cari hutang...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isEmpty) {
                          hutangController.hutangList.value =
                              hutangController.allHutangList;
                        } else {
                          _filterHutang();
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
                    onPressed: () {
                      _showDateRangePicker(context);
                    },
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

              var filteredHutangList = hutangController.hutangList;

              if (searchController.text.isNotEmpty ||
                  selectedDateRange.value != null) {
                filteredHutangList = hutangController.hutangList
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
                  filteredHutangList.sort((a, b) => a.nama.compareTo(b.nama));
                  break;
                case 'name_desc':
                  filteredHutangList.sort((a, b) => b.nama.compareTo(a.nama));
                  break;
                case 'date_asc':
                  filteredHutangList
                      .sort((a, b) => a.tanggalMulai.compareTo(b.tanggalMulai));
                  break;
                case 'date_desc':
                  filteredHutangList
                      .sort((a, b) => b.tanggalMulai.compareTo(a.tanggalMulai));
                  break;
              }

              if (filteredHutangList.isEmpty) {
                return const Center(
                  child: Text(
                    'Belum ada hutang',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                );
              }

              return ListView.builder(
                itemCount: filteredHutangList.length,
                itemBuilder: (context, index) {
                  var hutang = filteredHutangList[index];
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
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Sisa Hutang: ${formatRupiah(hutang.sisaHutang)}',
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        subtitle: Text(
                          formatTanggal(hutang.tanggalMulai),
                          style: const TextStyle(fontSize: 14),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios,
                            color: Colors.grey),
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
      _filterHutang();
    }
  }

  void _filterHutang() {
    final query = searchController.text.toLowerCase();
    final allHutang = hutangController.allHutangList;

    var filtered = allHutang.where((hutang) {
      final matchesQuery = hutang.nama.toLowerCase().contains(query) ||
          hutang.sisaHutang.toString().contains(query);
      final matchesDateRange = selectedDateRange.value == null ||
          (hutang.tanggalMulai.isAfter(selectedDateRange.value!.start) &&
              hutang.tanggalMulai.isBefore(
                  selectedDateRange.value!.end.add(const Duration(days: 1))));
      return matchesQuery && matchesDateRange;
    }).toList();

    hutangController.hutangList.value = filtered;
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
                  _filterHutang();
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('Nama Z - A'),
                onTap: () {
                  sortOrder.value = 'name_desc';
                  _filterHutang();
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('Baru ditambahkan'),
                onTap: () {
                  sortOrder.value = 'date_desc';
                  _filterHutang();
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('Terlama ditambahkan'),
                onTap: () {
                  sortOrder.value = 'date_asc';
                  _filterHutang();
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
    final TextEditingController inputBayarController = TextEditingController();
    final RxBool isPressed = false.obs;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Detail Hutang'),
              Divider(
                color: Colors.grey, // Warna garis
                thickness: 1, // Ketebalan garis
              )
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nama: ${hutang.nama}'),
              Text('Sisa Hutang: ${formatRupiah(hutang.sisaHutang)}'),
              Text('Tanggal Mulai: ${formatTanggal(hutang.tanggalMulai)}'),
              const SizedBox(height: 5),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: inputBayarController,
                decoration: InputDecoration(
                  labelText: 'Uang bayar',
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
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  RupiahInputFormatter(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Input Bayar tidak boleh kosong';
                  }
                  if (double.tryParse(value.replaceAll('.', '')) == null) {
                    return 'Input Bayar harus berupa angka';
                  }
                  return null;
                },
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
                  onTapUp: (_) async {
                    isPressed.value = false;
                    if (double.tryParse(
                            inputBayarController.text.replaceAll('.', '')) !=
                        null) {
                      double inputBayar = double.parse(
                          inputBayarController.text.replaceAll('.', ''));
                      double sisaHutangSebelum = hutang.sisaHutang;
                      double sisaHutangSekarang =
                          sisaHutangSebelum - inputBayar;

                      if (inputBayar <= sisaHutangSebelum.abs()) {
                        await hutangController.updateHutang(hutang.id!,
                            inputBayar, sisaHutangSebelum, hutang.transaksiId);
                        if (!context.mounted) return;
                        if (sisaHutangSekarang == 0) {
                          hutangController.updateStatusHutang(
                              hutang.id!, 'lunas');
                        }
                        Get.back();
                      } else {
                        double kembali = inputBayar - sisaHutangSebelum.abs();
                        sisaHutangSekarang = 0;
                        await hutangController.updateHutang(hutang.id!,
                            inputBayar, sisaHutangSebelum, hutang.transaksiId);
                        hutangController.updateStatusHutang(
                            hutang.id!, 'lunas');
                        if (!context.mounted) return;
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Kembali ${formatRupiah(kembali)}'),
                              actions: [
                                Center(
                                  child: Obx(() {
                                    return GestureDetector(
                                      onTapDown: (_) {
                                        isPressed.value = true;
                                      },
                                      onTapUp: (_) {
                                        isPressed.value = false;
                                        Get.back();
                                        Get.back();
                                      },
                                      child: AnimatedContainer(
                                        duration:
                                            const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15, horizontal: 40),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          gradient: isPressed.value
                                              ? const LinearGradient(
                                                  colors: [
                                                    Color.fromARGB(
                                                        255, 229, 135, 246),
                                                    Color.fromARGB(
                                                        255, 114, 94, 225),
                                                  ],
                                                )
                                              : const LinearGradient(
                                                  colors: [
                                                    Color.fromARGB(
                                                        255, 114, 94, 225),
                                                    Color.fromARGB(
                                                        255, 229, 135, 246),
                                                  ],
                                                ),
                                        ),
                                        child: const Text(
                                          'OK',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                      ),
                                    );
                                  }),
                                )
                              ],
                            );
                          },
                          barrierDismissible: false,
                        );
                      }
                    }
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
                      'Bayar',
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
