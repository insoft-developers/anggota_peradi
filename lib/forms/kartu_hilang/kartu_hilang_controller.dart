import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:dio/dio.dart';
import 'package:peradi/utils/api_endpoint.dart';
import 'package:peradi/webviewpage.dart';

class KartuHilangController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final dataTambahanItems = <String, dynamic>{}.obs;
  final orderData = <String, dynamic>{}.obs;

  /// TEXT
  final nia1 = TextEditingController();
  final nia2 = TextEditingController();
  final name = TextEditingController();
  final email = TextEditingController();

  /// PHONE
  var phone = "".obs;

  var loading = false.obs;

  void resetForm() {
    nia1.clear();
    nia2.clear();
    name.clear();
    email.clear();
    phone.value = "";
  }

  Future<void> submit() async {
    final valid = formKey.currentState!.validate();
    if (!valid) {
      Get.snackbar(
        "Error",
        "Lengkapi semua data wajib",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final ok = await Get.dialog<bool>(
      AlertDialog(
        title: const Text("Konfirmasi"),
        content: const Text(
            "Pastikan data yang anda masukkan sudah benar sebelum melanjutkan."),
        actions: [
          TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text("Batal")),
          ElevatedButton(
              onPressed: () => Get.back(result: true),
              child: const Text("Simpan")),
        ],
      ),
    );

    if (ok != true) return;

    try {
      Get.dialog(const Center(child: CircularProgressIndicator()),
          barrierDismissible: false);

      FormData data = FormData.fromMap({
        "slug": ApiEndpoint.slugKartuRusak,
        "nia_part1": nia1.text,
        "nia_part2": nia2.text,
        "name": name.text,
        "phone": phone.value,
        "email": email.text,
      });

      final res = await Dio().post(
        "https://anggotaperadi.or.id/api/formulir_simpan",
        data: data,
      );

      final body = res.data;

      if (body['success']) {
        Get.back(); // close loading
        orderData.value = body['data'];
        if (orderData.isNotEmpty) {
          Get.to(() => WebViewPage(
              pageUrl: orderData['invoice_url'], judul: 'Kartu Hilang'));
        }
        debugPrint(res.data.toString());
      } else {
        Get.snackbar(
          "Error",
          body['message'] ?? "Terjadi kesalahan saat menyimpan data",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on DioException catch (e) {
      print(e.response?.data);
      Get.snackbar("Error", "Gagal kirim data");
    } finally {
      loading.value = false;
    }
  }

  Future getDataPendukung() async {
    try {
      final res = await Dio().post(
        "https://anggotaperadi.or.id/api/daftar_ulang_data",
        data: {
          "slug": ApiEndpoint.slugKartuHilang,
        },
      );

      final body = res.data;
      if (body['success']) {
        dataTambahanItems.value = body['data'];

        debugPrint(const JsonEncoder.withIndent('  ').convert(body));
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
