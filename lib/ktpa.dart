import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:peradi/forms/daftar_ulang/daftar_ulang.dart';
import 'package:peradi/forms/daftar_ulang/daftar_ulang_controller.dart';
import 'package:peradi/forms/kartu_hilang/kartu_hilang.dart';
import 'package:peradi/forms/kartu_rusak/kartu_rusak.dart';
import 'package:peradi/forms/kartu_rusak/kartu_rusak_controller.dart';
import 'package:peradi/forms/penambahan_gelar/penambahan_gelar.dart';
import 'package:peradi/forms/perubahan_nama/perubahan_nama.dart';
import 'package:peradi/forms/pindah_domisili/pindah_domisi.dart';
import 'package:peradi/forms/pindah_domisili/pindah_domisili_controller.dart';
import 'package:peradi/webviewpage.dart';

class Ktpa extends StatefulWidget {
  const Ktpa({super.key});

  @override
  State<Ktpa> createState() => _KtpaState();
}

class _KtpaState extends State<Ktpa> {
  final controller = Get.put(DaftarUlangController(), permanent: true);
  final controller2 = Get.put(PindahDomisiliController(), permanent: true);
  final controller3 = Get.put(KartuRusakController(), permanent: true);
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Penggantian KTPA',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0D47A1),
        iconTheme: const IconThemeData(
          color: Colors.white, // ✅ panah back putih
        ),
      ),
      backgroundColor: const Color(0xFFF2F4F6),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Text(
                  'Pilih Formulir Dibawah Ini',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _menuCard(
                  context,
                  title: 'Formulir Kartu Hilang',
                  subtitle: 'Formulir Kartu Hilang Advocat Peradi',
                  icon: Icons.sd_card_alert,
                  onTap: () {
                    Get.to(() => const KartuHilangPage());
                  },
                ),
                _menuCard(
                  context,
                  title: 'Formulir Kartu Rusak',
                  subtitle: 'Formulir Kartu Rusak Advocat Peradi',
                  icon: Icons.broken_image,
                  onTap: () {
                    Get.to(() => const KartuRusakPage());
                  },
                ),
                _menuCard(
                  context,
                  title: 'Formulir Perpindahan Domisili',
                  subtitle: 'Formulir Permohonan Perpndahan Domisili',
                  icon: Icons.move_down_sharp,
                  onTap: () {
                    Get.to(() => const PindahDomisiliPage());
                  },
                ),
                _menuCard(
                  context,
                  title: 'Formulir Penambahan Gelar',
                  subtitle: 'Formulir Penambahan Gelar Anggota Peradi',
                  icon: Icons.school,
                  onTap: () {
                    Get.to(() => const PenambahanGelarPage());
                  },
                ),
                _menuCard(
                  context,
                  title: 'Formulir Perubahan Nama',
                  subtitle: 'Formulir Perubahan Nama Anggota Peradi',
                  icon: Icons.badge,
                  onTap: () {
                    Get.to(() => const PerubahanNamaPage());
                  },
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _menuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        elevation: 4,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF206BC4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.black54,
                            ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Colors.black54),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _drawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String url,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        Get.back();
        if (title == 'Formulir Data Ulang') {
          Get.to(() => const DaftarUlang());
        } else if (title == 'Formulir Pindah Domisili') {
          Get.to(() => const PindahDomisiliPage());
        } else if (title == 'Pengganti Kartu Rusak') {
          Get.to(() => const KartuRusakPage());
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WebViewPage(
                pageUrl: url,
                judul: title,
              ),
            ),
          );
        }
      },
    );
  }
}
