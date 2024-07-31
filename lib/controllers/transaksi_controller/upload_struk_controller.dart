import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UploadStrukController extends GetxController {
  final String apiUrl = 'http://10.10.10.129/flutterapi/api_transaksi.php';

  Future<void> uploadStruk(File strukFile, int transaksiId) async {
    try {
      // Get the application directory
      final directory = await getApplicationDocumentsDirectory();
      final newFilePath = '${directory.path}/struk_$transaksiId.png';
      final newFile = await strukFile.copy(newFilePath);

      // Create multipart request
      var request = http.MultipartRequest(
          'POST', Uri.parse('$apiUrl?action=upload_struk'));
      request.files
          .add(await http.MultipartFile.fromPath('struk', newFile.path));
      request.fields['transaksi_id'] = transaksiId.toString();

      // Send request
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var result = json.decode(responseData);

        if (result['status'] == 'success') {
          Get.snackbar(
            'Success',
            'Berhasil mengunggah struk',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            borderRadius: 10,
            margin: const EdgeInsets.all(10),
            snackPosition: SnackPosition.TOP,
            icon: const Icon(Icons.check_circle, color: Colors.white),
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
        } else {
          // Gagal / Error
          Get.snackbar(
            'Error',
            'Gagal mengunggah struk',
            backgroundColor: Colors.red,
            colorText: Colors.white,
            borderRadius: 10,
            margin: const EdgeInsets.all(10),
            snackPosition: SnackPosition.TOP,
            icon: const Icon(Icons.error, color: Colors.white),
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
      } else {
        // Gagal / Error
        Get.snackbar(
          'Error',
          'Gagal mengunggah struk',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          snackPosition: SnackPosition.TOP,
          icon: const Icon(Icons.error, color: Colors.white),
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
    } catch (e) {
      // Gagal / Error
        Get.snackbar('Error', '$e',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          borderRadius: 10,
          margin: const EdgeInsets.all(10),
          snackPosition: SnackPosition.TOP,
          icon: const Icon(Icons.error, color: Colors.white),
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
}
