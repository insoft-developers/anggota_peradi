import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:peradi/forms/perubahan_nama/perubahan_nama_controller.dart';
import 'package:peradi/utils/fungsi.dart';

class PerubahanNamaPage extends StatefulWidget {
  const PerubahanNamaPage({super.key});

  @override
  State<PerubahanNamaPage> createState() => _PerubahanNamaPageState();
}

class _PerubahanNamaPageState extends State<PerubahanNamaPage> {
  final c = Get.find<PerubahanNamaController>();

  Widget label(String t) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)),
      );

  InputDecoration deco() => InputDecoration(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      );

  @override
  void initState() {
    super.initState();
    c.resetForm();
    c.getDataPendukung();
    c.getKota();
  }

  Widget fileButton(String title, Rx<File?> fileRx, Function() onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
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

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F6),
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text("Formulir Perubahan Nama",
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
            label("NIA"),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: c.nia1,
                    keyboardType: TextInputType.number,
                    decoration: deco(),
                    maxLength: 2,
                    validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
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
                    maxLength: 11,
                    keyboardType: TextInputType.number,
                    decoration: deco(),
                    validator: (v) => v!.length > 11 ? "11 digit" : null,
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
            label("DPC Peradi"),
            Obx(
              () => DropdownSearch<String>(
                selectedItem: c.kotaName.value,
                items: c.kotaList.map((e) => e['name'].toString()).toList(),
                popupProps: PopupProps.menu(
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(
                      hintText: "Cari DPC...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: deco().copyWith(
                    hintText: "Pilih DPC",
                  ),
                ),
                onChanged: (value) {
                  c.kotaName.value = value;

                  final selected = c.kotaList.firstWhere(
                    (e) => e['name'].toString() == value,
                  );

                  c.kota.value = selected['id'].toString();

                  print("ID tersimpan: ${c.kota.value}");
                },
                validator: (v) => v == null ? "Wajib dipilih" : null,
              ),
            ),
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
                if (v!.isEmpty) return "Wajib diisi";
                if (!GetUtils.isEmail(v)) return "Email tidak valid";
                return null;
              },
            ),
            const SizedBox(height: 16),
            label("Nama Lengkap & Gelar yang Baru"),
            TextFormField(
              controller: c.newName,
              decoration: deco(),
              validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
            ),
            const SizedBox(height: 16),
            label("Alasan Perubahan Nama"),
            TextFormField(
              controller: c.reason,
              maxLines: 3,
              decoration: deco(),
              validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
            ),
            const SizedBox(height: 16),
            Obx(() => fileButton("Foto KTP Terbaru", c.ktp,
                () => c.pickImage((f) => c.ktp.value = f))),
            const SizedBox(height: 16),
            Obx(() => fileButton("Foto KTPA yang terakhir", c.ktpa,
                () => c.pickImage((f) => c.ktpa.value = f))),
            const SizedBox(height: 16),
            Obx(() => fileButton("Foto Surat Penetapan dari Pengadilan Negeri",
                c.penetapan, () => c.pickImage((f) => c.penetapan.value = f))),
            const SizedBox(height: 20),
            Obx(
              () => Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(color: Colors.white),
                child: Html(
                  data:
                      "<span style='color:blue;'><strong>Perhatian!</strong> Pastikan data yang anda masukkan sudah benar sebelum melanjutkan. Anda akan dikenakan biaya sebesar <strong>Rp. ${Fungsi.formatRibuan(c.dataTambahanItems['price'].toString())} </strong>untuk proses ini.</span>",
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: c.submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Simpan",
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
