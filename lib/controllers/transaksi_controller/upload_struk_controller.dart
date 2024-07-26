import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UploadStrukController extends GetxController {
  final String apiUrl = 'http://192.168.135.56/flutterapi/api_transaksi.php';

  Future<void> uploadStruk(File strukFile, int transaksiId) async {
    try {
      // Get the application directory
      final directory = await getApplicationDocumentsDirectory();
      final newFilePath = '${directory.path}/struk_$transaksiId.png';
      final newFile = await strukFile.copy(newFilePath);

      // Create multipart request
      var request = http.MultipartRequest(
          'POST', Uri.parse('$apiUrl?action=upload_struk'));
      request.files.add(await http.MultipartFile.fromPath('struk', newFile.path));
      request.fields['transaksi_id'] = transaksiId.toString();

      // Send request
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        var result = json.decode(responseData);

        if (result['status'] == 'success') {
          Get.snackbar('Success', 'Struk uploaded successfully');
        } else {
          Get.snackbar('Error', 'Failed to upload struk: ${result['message']}');
        }
      } else {
        Get.snackbar('Error', 'Failed to upload struk: ${response.reasonPhrase}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error uploading struk: $e');
    }
  }
}
