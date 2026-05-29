import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
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
  final birthPlace = TextEditingController();
  final email = TextEditingController();

  /// PHONE
  var phone = "".obs;
  var birthDate = Rxn<DateTime>();
  var kota = RxnString();
  var kotaName = RxnString();
  var kotaList = <Map<String, dynamic>>[].obs;

  /// FILE
  var sket = Rxn<File>();
  var ktp = Rxn<File>();
  var ktpa = Rxn<File>();

  final picker = ImagePicker();

  var loading = false.obs;

  void resetForm() {
    nia1.clear();
    nia2.clear();
    name.clear();
    birthPlace.clear();
    email.clear();
    phone.value = "";
    birthDate.value = null;
    kota.value = null;
    kotaName.value = null;
    sket.value = null;
    ktp.value = null;
    ktpa.value = null;
  }

  Future<void> pickImage(Function(File) onPicked) async {
    final XFile? image = await picker.pickImage(
      source: await _chooseSource(),
      imageQuality: 80, // optional untuk mengecilkan size
    );

    if (image != null) {
      onPicked(File(image.path));
    }
  }

  Future<ImageSource> _chooseSource() async {
    // Tampilkan dialog pilihan
    ImageSource? source = await Get.dialog<ImageSource>(
      AlertDialog(
        title: const Text("Pilih sumber foto"),
        content: const Text("Apakah ingin mengambil foto atau dari galeri?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: ImageSource.camera),
            child: const Text("Camera"),
          ),
          TextButton(
            onPressed: () => Get.back(result: ImageSource.gallery),
            child: const Text("Gallery"),
          ),
        ],
      ),
    );

    return source ?? ImageSource.gallery;
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
        "slug": ApiEndpoint.slugKartuHilang,
        "name": name.text,
        "nia_part1": nia1.text,
        "nia_part2": nia2.text,
        "birth_place": birthPlace.text,
        "birth_date": birthDate.value?.toIso8601String(),
        "phone": phone.value,
        "email": email.text,
        "kota_id": kota.value,
        if (sket.value != null)
          "photo_kehilangan": await MultipartFile.fromFile(
            sket.value!.path,
            filename: sket.value!.path.split('/').last,
          ),
        if (ktp.value != null)
          "photo_ktp": await MultipartFile.fromFile(
            ktp.value!.path,
            filename: ktp.value!.path.split('/').last,
          ),
        if (ktpa.value != null)
          "photo_ktpa": await MultipartFile.fromFile(
            ktpa.value!.path,
            filename: ktpa.value!.path.split('/').last,
          ),
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

  Future<void> getKota() async {
    try {
      kota.value = null;
      kotaList.clear();
      final res = await Dio().post(
        "https://anggotaperadi.or.id/api/get_kota_api_all",
      );
      // endpoint by provinsi

      kotaList.value = List<Map<String, dynamic>>.from(res.data['data']);
      print(kotaList);
    } catch (e) {
      print(e);
    }
  }
}
