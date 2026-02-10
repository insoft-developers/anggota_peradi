import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:peradi/utils/fungsi.dart';
import 'pindah_domisili_controller.dart';

class PindahDomisiliPage extends StatefulWidget {
  const PindahDomisiliPage({super.key});

  @override
  State<PindahDomisiliPage> createState() => _PindahDomisiliPageState();
}

class _PindahDomisiliPageState extends State<PindahDomisiliPage> {
  final c = Get.find<PindahDomisiliController>();

  @override
  void initState() {
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

  Widget label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
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
        title: const Text("Pindah Domisili",
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

            /// ======================================================
            const Text(
              "Kepada:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            const Text("1. Ketua Umum DPC PERADI cq. Bidang Keanggotaan.",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const Text("2. Ketua DPC Asal:",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),

            label("Provinsi"),
            Obx(() => DropdownButtonFormField<String>(
                  value: c.provinsiAsal.value,
                  items: c.provinsiList
                      .map((e) => DropdownMenuItem<String>(
                            value: e['id'].toString(),
                            child: Text(e['name']),
                          ))
                      .toList(),
                  onChanged: (v) {
                    c.provinsiAsal.value = v;
                    if (v != null) c.getDpcAsal(v);
                  },
                  decoration: deco(),
                  validator: (v) => v == null ? "Wajib dipilih" : null,
                )),

            const SizedBox(height: 16),

            label("DPC Peradi"),
            Obx(() => DropdownButtonFormField<String>(
                  value: c.dpcAsal.value,
                  items: c.dpcAsalList
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
                  onChanged: (v) => c.selectDpcAsal(v),
                  decoration: deco(),
                  validator: (v) => v == null ? "Wajib dipilih" : null,
                )),

            const SizedBox(height: 16),

            label("Nama Ketua"),
            TextFormField(
                controller: c.ketuaAsal,
                readOnly: true,
                decoration: deco(),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return "Wajib diisi";
                  }
                }),

            /// ======================================================
            section("Ketua DPC Tujuan"),

            label("Provinsi"),
            Obx(() => DropdownButtonFormField<String>(
                  value: c.provinsiTujuan.value,
                  items: c.provinsiList
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
                  onChanged: (v) {
                    c.provinsiTujuan.value = v;
                    if (v != null) c.getDpcTujuan(v);
                  },
                  decoration: deco(),
                  validator: (v) => v == null ? "Wajib dipilih" : null,
                )),

            const SizedBox(height: 16),

            label("DPC Peradi"),
            Obx(() => DropdownButtonFormField<String>(
                  value: c.dpcTujuan.value,
                  items: c.dpcTujuanList
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
                  onChanged: (v) => c.selectDpcTujuan(v),
                  decoration: deco(),
                  validator: (v) => v == null ? "Wajib dipilih" : null,
                )),

            const SizedBox(height: 16),

            label("Nama Ketua"),
            TextFormField(
              controller: c.ketuaTujuan,
              readOnly: true,
              decoration: deco(),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return "Wajib diisi";
                }
              },
            ),

            /// ======================================================
            section("Saya yang bertanda tangan di bawah ini:"),

            label("NIA (Nomor Induk Advokat)"),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: c.nia1,
                    maxLength: 2,
                    keyboardType: TextInputType.number,
                    decoration: deco(),
                    validator: (v) => v!.length != 2 ? "2 digit" : null,
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
              controller: c.nama,
              decoration: deco(),
              validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
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
                if (v == null || v.isEmpty) return "Wajib diisi";
                if (!GetUtils.isEmail(v)) return "Email tidak valid";
                return null;
              },
            ),
            const SizedBox(height: 16),
            label("Provinsi"),
            Obx(() => DropdownButtonFormField<String>(
                  value: c.provinsiID.value,
                  items: c.provinsiList
                      .map((e) => DropdownMenuItem<String>(
                            value: e['id'].toString(),
                            child: Text(e['name']),
                          ))
                      .toList(),
                  onChanged: (v) {
                    c.provinsiID.value = v;
                    if (v != null) c.getDpcId(v);
                  },
                  decoration: deco(),
                  validator: (v) => v == null ? "Wajib dipilih" : null,
                )),

            const SizedBox(height: 16),

            label("DPC Peradi"),
            Obx(() => DropdownButtonFormField<String>(
                  value: c.kotaID.value,
                  items: c.kotaIDList
                      .map((e) => DropdownMenuItem<String>(
                            value: e['id'].toString(),
                            child: Text(e['name']),
                          ))
                      .toList(),
                  onChanged: (v) => c.selectKotaID(v),
                  decoration: deco(),
                  validator: (v) => v == null ? "Wajib dipilih" : null,
                )),
            const SizedBox(height: 16),

            label("Sejak Tanggal"),
            Obx(() => InkWell(
                  onTap: () => c.pickTanggal(context),
                  child: InputDecorator(
                    decoration: deco(),
                    child: Text(
                      c.tanggal.value == null
                          ? "Pilih tanggal"
                          : c.tanggal.value.toString().split(" ")[0],
                    ),
                  ),
                )),

            const SizedBox(height: 16),

            label(
                "Domisili saya telah pindah dari semula beralamat rumah/kantor"),
            TextFormField(
              controller: c.alamatAsal,
              maxLines: 3,
              decoration: deco(),
              validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
            ),

            const SizedBox(height: 16),

            label("Pindah ke alamat rumah/kantor"),
            TextFormField(
              controller: c.alamatTujuan,
              maxLines: 3,
              decoration: deco(),
              validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
            ),

            const SizedBox(height: 16),

            label("Untuk itu saya mengajukan permohonan pindah ke DPC"),
            TextFormField(
              controller: c.dpcTujuanText,
              maxLines: 3,
              decoration: deco(),
              validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
            ),

            /// ======================================================
            section("Lampiran"),

            Obx(() => fileButton("Lampiran KTP atau Keterangan dari Kantor",
                c.lampiran, () => c.pickImage((f) => c.lampiran.value = f))),

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
            const SizedBox(height: 24),
            Obx(() => Html(
                data:
                    '<center>${c.dataTambahanItems['disclaimer']?.toString()}</center>')),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
