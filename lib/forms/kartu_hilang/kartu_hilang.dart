import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:peradi/forms/kartu_rusak/kartu_rusak_controller.dart';
import 'package:peradi/utils/fungsi.dart';

class KartuHilangPage extends StatefulWidget {
  const KartuHilangPage({super.key});

  @override
  State<KartuHilangPage> createState() => _KartuHilangPageState();
}

class _KartuHilangPageState extends State<KartuHilangPage> {
  final c = Get.find<KartuRusakController>();

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
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF0D47A1);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F6),
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text("Formulir Kartu Hilang",
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
