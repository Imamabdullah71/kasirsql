import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:kasirsql/models/supplier_model.dart';

class SupplierDetailPage extends StatelessWidget {
  final Supplier supplier;

  const SupplierDetailPage({required this.supplier, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Detail Supplier",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 114, 94, 225),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: supplier.gambar != null && supplier.gambar!.isNotEmpty
                  ? Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[300],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          'http://10.10.10.129/flutterapi/uploads/${supplier.gambar}',
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                  : const Icon(
                      Icons.image_not_supported,
                      size: 200,
                      color: Colors.grey,
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              supplier.namaSupplier,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              supplier.namaTokoSupplier ?? '-',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Text(
              'Alamat:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              supplier.alamat ?? '-',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'No Telepon:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  supplier.noTelepon ?? '-',
                  style: const TextStyle(fontSize: 16),
                ),
                Row(
                  children: [
                    IconButton(onPressed: () {}, icon: const Icon(Icons.phone)),
                    IconButton(
                        onPressed: () {},
                        icon: const Icon(BootstrapIcons.whatsapp)),
                  ],
                )
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Email:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  supplier.email ?? '-',
                  style: const TextStyle(fontSize: 16),
                ),
                IconButton(onPressed: () {}, icon: const Icon(Icons.email))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
