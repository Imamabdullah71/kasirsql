import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'package:kasirsql/views/supplier/crop_image_page.dart';
import 'package:kasirsql/controllers/supplier_controller/supplier_controller.dart';

class AddSupplierController extends GetxController {
  var selectedImagePath = ''.obs;
  var croppedImage = Rx<Uint8List?>(null);
  final String apiUrl = 'http://10.10.10.80/flutterapi/api_supplier.php';
  final ImagePicker _picker = ImagePicker();

  void pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      final fileName = '${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.jpg';
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$fileName');

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        pickedFile.path,
        tempFile.path,
        quality: 50,
      );

      if (compressedFile != null) {
        selectedImagePath.value = compressedFile.path;
        Get.to(() => CropImagePageSupplier());
      } else {
        Get.snackbar('Error', 'Failed to compress image');
      }
    } else {
      Get.snackbar('Error', 'No image selected');
    }
  }

  Future<String?> uploadImage(Uint8List imageBytes) async {
    final tempDir = await getTemporaryDirectory();
    final fileName = '${DateFormat('yyyyMMddHHmmss').format(DateTime.now())}.jpg';
    final file = File('${tempDir.path}/$fileName')..writeAsBytesSync(imageBytes);

    var request = http.MultipartRequest('POST', Uri.parse('$apiUrl?action=upload_image'));
    request.files.add(await http.MultipartFile.fromPath('image', file.path));

    var response = await request.send();
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var result = json.decode(responseData);
      if (result['status'] == 'success') {
        return result['path'];
      } else {
        Get.snackbar('Error', 'Failed to upload image');
        return null;
      }
    } else {
      Get.snackbar('Error', 'Failed to upload image');
      return null;
    }
  }

  void createSupplier(String namaSupplier, String namaTokoSupplier, String noTelepon, String email, String alamat) async {
    try {
      String? gambar;
      if (croppedImage.value != null) {
        gambar = await uploadImage(croppedImage.value!);
      }

      final response = await http.post(
        Uri.parse('$apiUrl?action=create_supplier'),
        body: {
          'nama_supplier': namaSupplier,
          'nama_toko_supplier': namaTokoSupplier,
          'no_telepon': noTelepon,
          'email': email,
          'alamat': alamat,
          'gambar': gambar ?? '',
        },
      );
      if (response.statusCode == 200) {
        Get.find<SupplierController>().fetchSupplier();
        Get.snackbar('Success', 'Supplier created successfully');
      } else {
        Get.snackbar('Error', 'Failed to create supplier');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to create supplier');
    }
  }
}
