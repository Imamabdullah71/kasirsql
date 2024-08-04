import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kasirsql/controllers/kategori_controller/kategori_controller.dart';
import 'package:kasirsql/models/kategori_model.dart';
import 'package:bootstrap_icons/bootstrap_icons.dart';

class CategoriesPage extends StatelessWidget {
  CategoriesPage({super.key});
  final KategoriController kategoriController = Get.find<KategoriController>();
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
          "Kelola Kategori",
          style: TextStyle(
            color: Color.fromARGB(255, 114, 94, 225),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              _showSortOptions(context);
            },
            icon: const Icon(BootstrapIcons.three_dots_vertical),
          )
        ],
        elevation: 10.0,
        shadowColor: Colors.black.withOpacity(0.5),
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
                keyboardType: TextInputType.text,
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
                  hintText: "Cari kategori...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (value) {
                  _filterCategories();
                },
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (kategoriController.kategoriList.isEmpty) {
                return const Center(child: Text('Tidak ada kategori'));
              }
              return ListView.builder(
                itemCount: kategoriController.kategoriList.length,
                itemBuilder: (context, index) {
                  final Kategori kategori =
                      kategoriController.kategoriList[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      elevation: 3,
                      child: ListTile(
                        title: Text(kategori.namaKategori),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            _showDeleteConfirmationDialog(context, kategori.id);
                          },
                        ),
                        onTap: () {
                          _showEditDialog(context, kategori);
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
          onPressed: () => _showAddKategoriDialog(context),
          child: const Text(
            "Tambah Kategori",
            style: TextStyle(color: Colors.white, fontSize: 20),
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
          title: const Text('Urutkan menurut...'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Nama A - Z'),
                onTap: () {
                  sortOrder.value = 'name_asc';
                  _filterCategories();
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('Nama Z - A'),
                onTap: () {
                  sortOrder.value = 'name_desc';
                  _filterCategories();
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('Baru ditambahkan'),
                onTap: () {
                  sortOrder.value = 'newest';
                  _filterCategories();
                  Get.back();
                },
              ),
              ListTile(
                title: const Text('Terlama ditambahkan'),
                onTap: () {
                  sortOrder.value = 'oldest';
                  _filterCategories();
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _filterCategories() {
    final query = searchController.text.toLowerCase();
    final allKategori = kategoriController.allKategoriList;

    var filtered = allKategori.where((kategori) {
      final matchesQuery = kategori.namaKategori.toLowerCase().contains(query);
      return matchesQuery;
    }).toList();

    switch (sortOrder.value) {
      case 'name_asc':
        filtered.sort((a, b) => a.namaKategori.compareTo(b.namaKategori));
        break;
      case 'name_desc':
        filtered.sort((a, b) => b.namaKategori.compareTo(a.namaKategori));
        break;
      case 'newest':
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case 'oldest':
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }

    kategoriController.kategoriList.value = filtered;
  }

  void _showEditDialog(BuildContext context, Kategori kategori) {
    final TextEditingController namaKategoriController =
        TextEditingController(text: kategori.namaKategori);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Kategori'),
          content: TextFormField(
            controller: namaKategoriController,
            decoration: InputDecoration(
              labelText: 'Nama Kategori',
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
                return 'Nama Kategori tidak boleh kosong';
              }
              return null;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                kategoriController.createKategori(namaKategoriController.text);
                Get.back();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showAddKategoriDialog(BuildContext context) {
    final TextEditingController namaKategoriController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Kategori'),
          content: TextFormField(
            controller: namaKategoriController,
            decoration: InputDecoration(
              labelText: 'Nama Kategori',
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
                return 'Nama Kategori tidak boleh kosong';
              }
              return null;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                kategoriController.createKategori(namaKategoriController.text);
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Penghapusan'),
          content:
              const Text('Apakah Anda yakin ingin menghapus kategori ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                kategoriController.deleteKategori(id);
                Get.back();
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}
