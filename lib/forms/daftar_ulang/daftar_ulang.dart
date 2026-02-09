import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:peradi/forms/daftar_ulang/daftar_ulang_controller.dart';
import 'package:peradi/utils/fungsi.dart';

class DaftarUlang extends StatefulWidget {
  const DaftarUlang({super.key});

  @override
  State<DaftarUlang> createState() => _DaftarUlangState();
}

class _DaftarUlangState extends State<DaftarUlang> {
  final c = Get.find<DaftarUlangController>();

  @override
  initState() {
    super.initState();
    c.resetForm();
    c.getDataPendukung();
  }

  Widget section(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 8),
      child: Text(title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }

  /// 🔥 LABEL DI ATAS
  Widget label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget fileButton(String title, Rx<File?> fileRx, Function() onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onTap,
          icon: const Icon(Icons.upload_file),
          label: Text(fileRx.value == null ? "Pilih File" : "Ganti File"),
        ),
        const SizedBox(height: 8),
        Obx(() => fileRx.value != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  fileRx.value!,
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              )
            : const SizedBox()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF0D47A1);
    const borderColor = Color(0xFFD0D5DD);

    /// 🔥 decoration TANPA labelText
    InputDecoration deco() {
      return InputDecoration(
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F6),
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text("Formulir Data Ulang",
            style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Form(
        key: c.formKey,
        autovalidateMode: AutovalidateMode.always,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Center(
              child: Image.network(
                "https://anggotaperadi.or.id/assets/img/logo.webp",
                width: 160,
              ),
            ),
            const SizedBox(height: 24),

            section("Data Pribadi"),

            /// NIA
            label("NIA ( Nomor Induk Advokat )"),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: c.nia1,
                    decoration: deco(),
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return "Wajib diisi";
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(v)) {
                        return "Hanya angka";
                      }
                      if (v.length != 2) {
                        return "Harus 2 digit";
                      }
                      return null;
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text("."),
                ),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: c.nia2,
                    decoration: deco(),
                    keyboardType: TextInputType.number,
                    maxLength: 11,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return "Wajib diisi";
                      }
                      if (!RegExp(r'^[0-9]+$').hasMatch(v)) {
                        return "Hanya angka";
                      }
                      if (v.length != 11) {
                        return "Harus 11 digit";
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            label("Nama Lengkap & Gelar"),
            TextFormField(
              controller: c.name,
              decoration: deco(),
              validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
            ),

            const SizedBox(height: 16),

            label("Nama & Gelar di KTPA"),
            TextFormField(
              controller: c.nameKtpa,
              maxLength: 40,
              decoration: deco(),
              validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
            ),

            const SizedBox(height: 16),

            label("Jenis Kelamin"),
            Obx(() => DropdownButtonFormField<String>(
                  value: c.gender.value,
                  items: c.genderList
                      .map((e) => DropdownMenuItem<String>(
                            value: e['id'].toString(),
                            child: Text(e['name']),
                          ))
                      .toList(),
                  onChanged: (v) => c.gender.value = v,
                  decoration: deco(),
                  validator: (v) => v == null ? "Wajib dipilih" : null,
                )),

            const SizedBox(height: 16),

            label("Tempat Lahir"),
            TextFormField(
              controller: c.birthPlace,
              decoration: deco(),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return "Wajib diisi";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            label("Tanggal Lahir"),
            Obx(() => InkWell(
                  onTap: () async {
                    final d = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                    );
                    if (d != null) c.birthDate.value = d;
                  },
                  child: InputDecorator(
                    decoration: deco(),
                    child: Text(
                      c.birthDate.value == null
                          ? "Pilih tanggal"
                          : c.birthDate.value.toString().split(" ")[0],
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                )),

            const SizedBox(height: 16),

            label("Agama"),
            Obx(() => DropdownButtonFormField<String>(
                  value: c.religion.value,
                  items: c.religionList
                      .map((e) => DropdownMenuItem<String>(
                            value: e['id'].toString(),
                            child: Text(e['name']),
                          ))
                      .toList(),
                  onChanged: (v) => c.religion.value = v,
                  decoration: deco(),
                  validator: (v) => v == null ? "Wajib dipilih" : null,
                )),

            const SizedBox(height: 16),

            label("Nomor Handphone"),
            IntlPhoneField(
              decoration: deco(),
              initialCountryCode: 'ID',
              onChanged: (p) => c.phone.value = p.completeNumber,
            ),

            const SizedBox(height: 16),

            label("Email"),
            TextFormField(
              controller: c.email,
              decoration: deco(),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return "Wajib diisi";
                if (!GetUtils.isEmail(v)) return "Format email tidak valid";
                return null;
              },
            ),

            const SizedBox(height: 16),

            label("Alamat"),
            TextFormField(
              controller: c.address,
              maxLines: 3,
              decoration: deco(),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return "Wajib diisi";
                }
                return null;
              },
            ),

            section("Data Kantor"),

            label("Nama Kantor"),
            TextFormField(
              controller: c.firmName,
              decoration: deco(),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return "Wajib diisi";
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            label("Nomor Kantor"),
            IntlPhoneField(
              decoration: deco(),
              initialCountryCode: 'ID',
              onChanged: (p) => c.firmPhone.value = p.completeNumber,
            ),

            const SizedBox(height: 16),

            label("Alamat Kantor"),
            TextFormField(
              controller: c.firmAddress,
              maxLines: 3,
              decoration: deco(),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return "Wajib diisi";
                }
                return null;
              },
            ),

            section("Wilayah"),

            label("Provinsi"),
            Obx(() => DropdownButtonFormField<String>(
                  value: c.provinsi.value,
                  items: c.provinsiList
                      .map((e) => DropdownMenuItem<String>(
                            value: e['id'].toString(),
                            child: Text(e['name']),
                          ))
                      .toList(),
                  onChanged: (v) {
                    c.provinsi.value = v;
                    if (v != null) c.getKota(v);
                  },
                  decoration: deco(),
                  validator: (v) => v == null ? "Wajib dipilih" : null,
                )),

            const SizedBox(height: 16),

            label("DPC Peradi"),
            Obx(() => DropdownButtonFormField<String>(
                  value: c.kota.value,
                  items: c.kotaList
                      .map((e) => DropdownMenuItem<String>(
                            value: e['id'].toString(),
                            child: SizedBox(
                              width: Get.width * 0.6, // atur lebar
                              child: Text(
                                e['name'],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ))
                      .toList(),
                  onChanged: (v) => c.kota.value = v,
                  decoration: deco(),
                  validator: (v) => v == null ? "Wajib dipilih" : null,
                )),

            section("Upload Dokumen"),

            Obx(() => fileButton("Pas Foto terbaru dengan Latar Belakang Merah",
                c.photo, () => c.pickImage((f) => c.photo.value = f))),
            const SizedBox(height: 16),

            Obx(() => fileButton("Foto KTP(khusus pindah domisili)", c.photoKtp,
                () => c.pickImage((f) => c.photoKtp.value = f))),
            const SizedBox(height: 16),

            Obx(() => fileButton("Foto KTPA", c.photoKtpa,
                () => c.pickImage((f) => c.photoKtpa.value = f))),
            const SizedBox(height: 16),

            Obx(() => fileButton(
                "Foto Ijazah legalisir basah(khusus penambahan gelar)",
                c.ijazah,
                () => c.pickImage((f) => c.ijazah.value = f))),
            const SizedBox(height: 16),

            Obx(
              () => Html(
                data: c.dataTambahanItems['description']?.toString() ?? "",
                style: {
                  "p": Style(
                    color: Colors.black38,
                  ),
                },
              ),
            ),

            Obx(
              () => Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(color: Colors.white),
                child: Html(
                  data:
                      "<span style='color:blue;'><strong>Perhatian!</strong> Pastikan data yang anda masukkan sudah benar sebelum melanjutkan. Anda akan dikenakan biaya sebesar <strong>Rp. ${Fungsi.formatRibuan(c.dataTambahanItems['price'].toString())} </strong>untuk proses ini.<br><br>Kartu berlaku 3 tahun sejak tanggal simpan/submit.<br>Berlaku hingga: <br><br><span><strong>${Fungsi.getEndDate(3)}</strong></span></span>",
                ),
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () => c.submit(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Simpan",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),

            const SizedBox(height: 24),
            Obx(() => Html(
                data: c.dataTambahanItems['disclaimer']?.toString() ?? "")),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
