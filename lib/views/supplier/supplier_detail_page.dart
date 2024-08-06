import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:kasirsql/models/supplier_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get.dart';

class SupplierDetailPage extends StatelessWidget {
  final Supplier supplier;

  const SupplierDetailPage({required this.supplier, super.key});

  String _formatPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith('0')) {
      phoneNumber = '+62${phoneNumber.substring(1)}';
    }
    return phoneNumber;
  }

  _launchWhat() async {
    var whatsapp = "+6282257514936";
    var whatsappAndroid = Uri.parse("https://wa.me/$whatsapp");
    if (await canLaunchUrl(whatsappAndroid)) {
      await launchUrl(whatsappAndroid);
    } else {
      Get.snackbar(
        'Peringatan',
        'Nomor WA tidak terdaftar.',
        backgroundColor: const Color.fromARGB(255, 235, 218, 63),
        colorText: Colors.black,
        borderRadius: 10,
        margin: const EdgeInsets.all(10),
        snackPosition: SnackPosition.TOP,
        icon: const Icon(Icons.error, color: Colors.black),
        duration: const Duration(seconds: 3),
        snackStyle: SnackStyle.FLOATING,
        boxShadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      );
    }
  }

  Future<void> _launchWhatsApp(String phoneNumber) async {
    final formattedPhoneNumber = _formatPhoneNumber(phoneNumber);
    final Uri url = Uri.parse('https://wa.me/$formattedPhoneNumber');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _testPhoneNumber(String phoneNumber) async {
    final formattedPhoneNumber = _formatPhoneNumber(phoneNumber);
    print('Formatted Phone Number: $formattedPhoneNumber');
  }

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
        actions: [
          IconButton(
            onPressed: () {
              _launchWhat();
            },
            icon: const Icon(
              BootstrapIcons.bug,
              color: Colors.white,
            ),
          ),
        ],
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
                IconButton(
                  onPressed: () {
                    final phoneNumber = supplier.noTelepon;
                    if (phoneNumber != null && phoneNumber.isNotEmpty) {
                      _launchWhatsApp(phoneNumber);
                    } else {
                      Get.snackbar(
                        'Peringatan',
                        'Nomor WA tidak terdaftar.',
                        backgroundColor:
                            const Color.fromARGB(255, 235, 218, 63),
                        colorText: Colors.black,
                        borderRadius: 10,
                        margin: const EdgeInsets.all(10),
                        snackPosition: SnackPosition.TOP,
                        icon: const Icon(Icons.error, color: Colors.black),
                        duration: const Duration(seconds: 3),
                        snackStyle: SnackStyle.FLOATING,
                        boxShadows: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      );
                    }
                  },
                  icon: const Icon(BootstrapIcons.whatsapp),
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
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.email),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
