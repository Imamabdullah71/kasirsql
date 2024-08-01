import 'package:get/get.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:kasirsql/models/hutang_model.dart';
import 'package:kasirsql/models/riwayat_pembayaran_model.dart';

class HutangController extends GetxController {
  var hutangList = <Hutang>[].obs;
  var allHutangList = <Hutang>[].obs;
  var allLunasList = <Hutang>[].obs;
  var lunasList = <Hutang>[].obs;
  var isLoading = false.obs;
  var riwayatList = <RiwayatPembayaran>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchHutang();
    fetchLunas();
  }

  Future<void> fetchHutang() async {
    isLoading.value = true;
    try {
      var response = await http.get(Uri.parse(
          'http://10.10.10.129/flutterapi/api_hutang.php?action=get_hutang&status=belum lunas'));
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        if (result['status'] == 'success') {
          var data =
              (result['data'] as List).map((e) => Hutang.fromJson(e)).toList();
          data.sort((a, b) => b.tanggalMulai.compareTo(a.tanggalMulai));
          allHutangList.value = data; // Menyimpan semua data hutang
          hutangList.value = data; // Menyimpan data yang ditampilkan
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLunas() async {
    isLoading.value = true;
    try {
      var response = await http.get(Uri.parse(
          'http://10.10.10.129/flutterapi/api_hutang.php?action=get_hutang&status=lunas'));
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        if (result['status'] == 'success') {
          var hutangList =
              (result['data'] as List).map((e) => Hutang.fromJson(e)).toList();
              hutangList.sort((a, b) => b.tanggalSelesai.compareTo(a.tanggalSelesai));
          lunasList.value = hutangList;
          allLunasList.value = hutangList; // Menyimpan data asli
        }
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Metode tambahan untuk mengembalikan data ke keadaan awal jika diperlukan
  void resetLunasList() {
    lunasList.value = allLunasList;
  }

  Future<void> updateHutang(int id, double inputBayar, double sisaHutangSebelum,
      int transaksiId) async {
    isLoading.value = true;
    try {
      double sisaHutangSekarang = sisaHutangSebelum - inputBayar;

      var response = await http.post(
        Uri.parse(
            'http://10.10.10.129/flutterapi/api_hutang.php?action=update_hutang'),
        body: {
          'id': id.toString(),
          'input_bayar': inputBayar.toString(),
          'sisa_hutang_sebelum': sisaHutangSebelum.toString(),
          'sisa_hutang': sisaHutangSekarang.toString(),
          'transaksi_id': transaksiId.toString(),
        },
      );
      if (response.statusCode == 200) {
        fetchHutang();
        fetchLunas();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateStatusHutang(int id, String status) async {
    isLoading.value = true;
    try {
      var response = await http.post(
        Uri.parse(
            'http://10.10.10.129/flutterapi/api_hutang.php?action=update_status_hutang'),
        body: {
          'id': id.toString(),
          'status': status,
        },
      );
      if (response.statusCode == 200) {
        fetchHutang();
        fetchLunas();
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRiwayatPembayaran(int hutangId) async {
    try {
      var response = await http.get(Uri.parse(
          'http://10.10.10.129/flutterapi/api_hutang.php?action=get_riwayat_pembayaran&hutang_id=$hutangId'));
      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        if (result['status'] == 'success') {
          riwayatList.value = (result['data'] as List)
              .map((e) => RiwayatPembayaran.fromJson(e))
              .toList();
        }
      }
    } finally {
      isLoading.value = false;
    }
  }
}
