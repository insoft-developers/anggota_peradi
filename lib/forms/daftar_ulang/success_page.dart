import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peradi/home.dart';
import 'daftar_ulang_controller.dart';

class SuccessPage extends StatelessWidget {
  final DaftarUlangController controller;

  const SuccessPage({super.key, required this.controller});

  static const primary = Color(0xFF0D47A1);

  Widget item(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value.isEmpty ? "-" : value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = controller;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text(
          "Pendaftaran Berhasil",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 10),

          /// ICON
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 90,
          ),

          const SizedBox(height: 16),

          const Text(
            "Terima kasih untuk pengisian data daftar ulang Anda.\n"
            "Kami akan informasikan kembali melalui email yang terdaftar.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 30),

          const Divider(),

          const Text(
            "Data Anda",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          item("NIA", "${c.nia1.text}.${c.nia2.text}"),
          item("Nama", c.name.text),
          item("Alamat", c.address.text),
          item("Gender", c.gender.value ?? "-"),
          item("Agama", c.religion.value ?? "-"),
          item("HP", c.phone.value),

          const SizedBox(height: 20),

          const Text(
            "Foto",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          if (c.photo.value != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                File(c.photo.value!.path),
                height: 200,
                fit: BoxFit.cover,
              ),
            )
          else
            const Text("-"),

          const SizedBox(height: 30),

          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Get.offAll(() => const HomeView()); // balik ke home kalau ada
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Selesai",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
