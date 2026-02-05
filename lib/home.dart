import 'package:flutter/material.dart';
import 'package:peradi/about.dart';
import 'package:peradi/webviewpage.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Homepage',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0D47A1),
        iconTheme: const IconThemeData(
          color: Colors.white, // ✅ panah back putih
        ),
      ),
      backgroundColor: const Color(0xFFF2F4F6),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF0D47A1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.asset(
                      'assets/images/app_icon.png',
                      width: 80,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'ANGGOTA PERADI',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            _drawerItem(
              context,
              icon: Icons.assignment,
              title: 'Formulir Data Ulang',
              url:
                  'https://anggotaperadi.or.id/anggota/formulir/formulir-data-ulang-advokat-peradi-2024',
            ),
            _drawerItem(
              context,
              icon: Icons.location_on,
              title: 'Formulir Pindah Domisili',
              url:
                  'https://anggotaperadi.or.id/anggota/formulir/formulir-pemberitahuan-pindah-domisili-anggota',
            ),
            _drawerItem(
              context,
              icon: Icons.credit_card,
              title: 'Pengganti Kartu Rusak',
              url:
                  'https://anggotaperadi.or.id/anggota/formulir/formulir-pengganti-kartu-rusak',
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Tentang PERADI'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const AboutPeradiPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Image.asset(
                    'assets/images/logo.webp',
                    width: 220,
                  ),
                ),
                const SizedBox(height: 30),
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
                  title: 'Formulir Data Ulang',
                  subtitle: 'Formulir Data Ulang Advocat Peradi',
                  icon: Icons.assignment,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WebViewPage(
                          pageUrl:
                              'https://anggotaperadi.or.id/anggota/formulir/formulir-data-ulang-advokat-peradi-2024',
                          judul: 'Formulir Data Ulang',
                        ),
                      ),
                    );
                  },
                ),
                _menuCard(
                  context,
                  title: 'Formulir Pindah Domisili',
                  subtitle: 'Formulir Pemberitahuan Pindah Domisili',
                  icon: Icons.location_city,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WebViewPage(
                          pageUrl:
                              'https://anggotaperadi.or.id/anggota/formulir/formulir-pemberitahuan-pindah-domisili-anggota',
                          judul: 'Formulir Pindah Domisili',
                        ),
                      ),
                    );
                  },
                ),
                _menuCard(
                  context,
                  title: 'Pengganti Kartu Rusak',
                  subtitle: 'Formulir Pengajuan Kartu Rusak atau Hilang',
                  icon: Icons.credit_card,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WebViewPage(
                          pageUrl:
                              'https://anggotaperadi.or.id/anggota/formulir/formulir-pengganti-kartu-rusak',
                          judul: 'Pengganti Kartu Rusak',
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WebViewPage(
                          pageUrl: 'https://anggotaperadi.or.id/privacy_policy',
                          judul: 'Privacy Policy',
                        ),
                      ),
                    );
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      'Privacy Policy',
                      style: textTheme.bodyMedium?.copyWith(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Supported By',
                  style: textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                Image.asset(
                  'assets/images/payment-gateway.png',
                  width: 320,
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
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => WebViewPage(
              pageUrl: url,
              judul: title,
            ),
          ),
        );
      },
    );
  }
}
