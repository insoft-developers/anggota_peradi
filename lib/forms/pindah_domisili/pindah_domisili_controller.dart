import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:peradi/utils/api_endpoint.dart';
import 'package:peradi/webviewpage.dart';

class PindahDomisiliController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final dataTambahanItems = <String, dynamic>{}.obs;
  final orderData = <String, dynamic>{}.obs;

  /// ======================================================
  /// TEXT CONTROLLER
  final ketuaAsal = TextEditingController();
  final ketuaTujuan = TextEditingController();

  final nia1 = TextEditingController();
  final nia2 = TextEditingController();
  final nama = TextEditingController();
  final email = TextEditingController();

  final alamatAsal = TextEditingController();
  final alamatTujuan = TextEditingController();
  final dpcTujuanText = TextEditingController();

  /// ======================================================
  /// DROPDOWN VALUE
  var provinsiAsal = RxnString();
  var dpcAsal = RxnString();

  var provinsiTujuan = RxnString();
  var dpcTujuan = RxnString();

  var provinsiID = RxnString();
  var kotaID = RxnString();

  /// ======================================================
  /// DATA LIST API
  var provinsiList = <Map<String, dynamic>>[].obs;
  var dpcAsalList = <Map<String, dynamic>>[].obs;
  var dpcTujuanList = <Map<String, dynamic>>[].obs;
  var kotaIDList = <Map<String, dynamic>>[].obs;

  /// ======================================================
  /// OTHER STATE
  var phone = "".obs;
  var tanggal = Rxn<DateTime>();
  var photoKtp = Rxn<File>();
  var photoKeterangan = Rxn<File>();
  var photoTandaTerima = Rxn<File>();

  final picker = ImagePicker();
  var loading = false.obs;

  /// ======================================================
  /// INIT
  void resetForm() {
    provinsiID.value = null;
    kotaID.value = null;
    provinsiAsal.value = null;
    dpcAsal.value = null;
    provinsiTujuan.value = null;
    dpcTujuan.value = null;
    tanggal.value = null;
    photoKtp.value = null;
    photoKeterangan.value = null;
    photoTandaTerima.value = null;

    ketuaAsal.clear();
    ketuaTujuan.clear();
    nia1.clear();
    nia2.clear();
    nama.clear();
    email.clear();
    alamatAsal.clear();
    alamatTujuan.clear();
    dpcTujuanText.clear();
  }

  /// ======================================================
  /// API DPC ASAL
  Future<void> getDpcAsal(String provinsiId) async {
    // TODO : ganti API
    try {
      dpcAsal.value = null;
      dpcAsalList.clear();
      final res = await Dio().post(
        "https://anggotaperadi.or.id/api/get_kota_api",
        data: {
          "provinsi_id": provinsiId,
        },
      );
      // endpoint by provinsi

      dpcAsalList.value = List<Map<String, dynamic>>.from(res.data['data']);
    } catch (e) {
      print(e);
    }
  }

  void selectDpcAsal(String? id) {
    dpcAsal.value = id;
    final data = dpcAsalList.firstWhereOrNull((e) => e['id'].toString() == id);
    ketuaAsal.text = data?['ketua'] ?? "";
  }

  /// ======================================================
  /// API DPC TUJUAN
  Future<void> getDpcTujuan(String provinsiId) async {
    // TODO : ganti API
    try {
      dpcTujuan.value = null;
      dpcTujuanList.clear();
      final res = await Dio().post(
        "https://anggotaperadi.or.id/api/get_kota_api",
        data: {
          "provinsi_id": provinsiId,
        },
      );
      // endpoint by provinsi

      dpcTujuanList.value = List<Map<String, dynamic>>.from(res.data['data']);
    } catch (e) {
      print(e);
    }
  }

  void selectDpcTujuan(String? id) {
    dpcTujuan.value = id;
    final data =
        dpcTujuanList.firstWhereOrNull((e) => e['id'].toString() == id);
    ketuaTujuan.text = data?['ketua'] ?? "";
  }

  Future<void> getDpcId(String provinsiId) async {
    // TODO : ganti API
    try {
      kotaID.value = null;
      kotaIDList.clear();
      final res = await Dio().post(
        "https://anggotaperadi.or.id/api/get_kota_api",
        data: {
          "provinsi_id": provinsiId,
        },
      );
      // endpoint by provinsi

      kotaIDList.value = List<Map<String, dynamic>>.from(res.data['data']);
    } catch (e) {
      print(e);
    }
  }

  void selectKotaID(String? id) {
    kotaID.value = id;
  }

  /// ======================================================
  /// DATE PICKER
  Future<void> pickTanggal(BuildContext context) async {
    final result = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1990),
      lastDate: DateTime(2100),
    );

    if (result != null) {
      tanggal.value = result;
    }
  }

  /// ======================================================
  /// IMAGE PICKER
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

  /// ======================================================
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
        "slug": ApiEndpoint.slugPindahDomisili,
        "nia_part1": nia1.text,
        "nia_part2": nia2.text,
        "name": nama.text,
        "phone": phone.value,
        "email": email.text,
        "ketua_dpc_asal": ketuaAsal.text,
        "ketua_dpc_tujuan": ketuaTujuan.text,
        "dpc_asal": "",
        "dpc_tujuan": dpcTujuanText.text,
        "alamat_asal": alamatAsal.text,
        "alamat_tujuan": alamatTujuan.text,
        "provinsi_id": provinsiID.value,
        "kota_id": kotaID.value,
        "asal_provinsi_id": provinsiAsal.value,
        "asal_kota_id": dpcAsal.value,
        "tujuan_provinsi_id": provinsiTujuan.value,
        "tujuan_kota_id": dpcTujuan.value,
        "tgl_dpc_tujuan": tanggal.value?.toIso8601String(),
        if (photoKeterangan.value != null)
          "photo_keterangan":
              await MultipartFile.fromFile(photoKeterangan.value!.path),
        if (photoKtp.value != null)
          "photo_ktp": await MultipartFile.fromFile(photoKtp.value!.path),
        if (photoTandaTerima.value != null)
          "photo_tanda_terima":
              await MultipartFile.fromFile(photoTandaTerima.value!.path),
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
              pageUrl: orderData['invoice_url'], judul: 'Pindah Domisili'));
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
      debugPrint("STATUS: ${e.response?.statusCode}");
      debugPrint("DATA: ${e.response?.data}");
      debugPrint("ERROR: ${e.message}");

      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      Get.snackbar(
        "Error",
        e.response?.data.toString() ?? "Server Error",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future getDataPendukung() async {
    try {
      final res = await Dio().post(
        "https://anggotaperadi.or.id/api/daftar_ulang_data",
        data: {
          "slug": ApiEndpoint.slugPindahDomisili,
        },
      );

      final body = res.data;
      if (body['success']) {
        dataTambahanItems.value = body['data'];
        provinsiList.value = List<Map<String, dynamic>>.from(body['provinsi']);
        debugPrint(const JsonEncoder.withIndent('  ').convert(body));
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
}
