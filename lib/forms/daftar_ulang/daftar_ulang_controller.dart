import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:peradi/utils/api_endpoint.dart';
import 'package:peradi/webviewpage.dart';

class DaftarUlangController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final dataTambahanItems = <String, dynamic>{}.obs;
  final orderData = <String, dynamic>{}.obs;

  var gender = RxnString();
  var religion = RxnString();
  var provinsi = RxnString();
  var kota = RxnString();

  var genderList = <Map<String, dynamic>>[].obs;
  var religionList = <Map<String, dynamic>>[].obs;
  var provinsiList = <Map<String, dynamic>>[].obs;
  var kotaList = <Map<String, dynamic>>[].obs;

  /// TEXT
  final nia1 = TextEditingController();
  final nia2 = TextEditingController();
  final name = TextEditingController();
  final nameKtpa = TextEditingController();
  final birthPlace = TextEditingController();
  final email = TextEditingController();
  final address = TextEditingController();
  final firmName = TextEditingController();
  final firmAddress = TextEditingController();

  /// VALUE
  var phone = "".obs;
  var firmPhone = "".obs;

  var birthDate = Rxn<DateTime>();

  /// FILE
  var photo = Rxn<File>();
  var photoKtp = Rxn<File>();
  var photoKtpa = Rxn<File>();
  var ijazah = Rxn<File>();

  final picker = ImagePicker();

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

  /// GET KOTA
  Future<void> getKota(String idProv) async {
    try {
      kota.value = null;
      kotaList.clear();
      final res = await Dio().post(
        "https://anggotaperadi.or.id/api/get_kota_api",
        data: {
          "provinsi_id": idProv,
        },
      );
      // endpoint by provinsi

      kotaList.value = List<Map<String, dynamic>>.from(res.data['data']);
    } catch (e) {
      print(e);
    }
  }

  Future getDataPendukung() async {
    try {
      final res = await Dio().post(
        "https://anggotaperadi.or.id/api/daftar_ulang_data",
        data: {
          "slug": ApiEndpoint.slugDaftarUlang,
        },
      );

      final body = res.data;
      if (body['success']) {
        dataTambahanItems.value = body['data'];
        genderList.value = List<Map<String, dynamic>>.from(body['gender']);
        religionList.value = List<Map<String, dynamic>>.from(body['religion']);
        provinsiList.value = List<Map<String, dynamic>>.from(body['provinsi']);
        debugPrint(const JsonEncoder.withIndent('  ').convert(body));
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }

  /// SUBMIT
  Future submit() async {
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
        "slug": ApiEndpoint.slugDaftarUlang,
        "nia_part1": nia1.text,
        "nia_part2": nia2.text,
        "name": name.text,
        "name_ktpa": nameKtpa.text,
        "gender_id": gender.value,
        "birth_place": birthPlace.text,
        "birth_date": birthDate.value?.toIso8601String(),
        "religion_id": religion.value,
        "phone": phone.value,
        "email": email.text,
        "address": address.text,
        "firm_name": firmName.text,
        "firm_phone": firmPhone.value,
        "firm_address": firmAddress.text,
        "provinsi_id": provinsi.value,
        "kota_id": kota.value,
        if (photo.value != null)
          "photo": await MultipartFile.fromFile(photo.value!.path),
        if (photoKtp.value != null)
          "photo_ktp": await MultipartFile.fromFile(photoKtp.value!.path),
        if (photoKtpa.value != null)
          "photo_ktpa": await MultipartFile.fromFile(photoKtpa.value!.path),
        if (ijazah.value != null)
          "photo_license": await MultipartFile.fromFile(ijazah.value!.path),
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
              pageUrl: orderData['invoice_url'],
              judul: 'Pembayaran Daftar Ulang'));
        }
        debugPrint(const JsonEncoder.withIndent('  ').convert(res.data));
      } else {
        Get.snackbar(
          "Error",
          body['message'] ?? "Terjadi kesalahan saat menyimpan data",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
      Get.back();
      Get.snackbar(
        "Error",
        "Terjadi kesalahan saat menyimpan data, Lengkapi semua data yang diperlukan.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void resetForm() {
    nia1.clear();
    nia2.clear();
    name.clear();
    nameKtpa.clear();
    birthPlace.clear();
    email.clear();
    address.clear();
    firmName.clear();
    firmAddress.clear();

    gender.value = null;
    religion.value = null;
    provinsi.value = null;
    kota.value = null;

    phone.value = "";
    firmPhone.value = "";

    birthDate.value = null;

    photo.value = null;
    photoKtp.value = null;
    photoKtpa.value = null;
    ijazah.value = null;
  }
}
