import 'package:flutter/material.dart';

class AboutPeradiPage extends StatelessWidget {
  const AboutPeradiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Tentang Peradi',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0D47A1),
        iconTheme: const IconThemeData(
          color: Colors.white, // ✅ panah back putih
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: const [
            Text(
              'Perhimpunan Advokat Indonesia (PERADI)',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text(
              '... organisasi advokat nasional ... \n'
              'Informasi dalam aplikasi ini dapat diakses oleh masyarakat umum '
              'untuk memahami peran dan fungsi organisasi advokat di Indonesia.\n\n'
              'Perhimpunan Advokat Indonesia (PERADI) adalah organisasi advokat '
              'nasional yang menjadi wadah profesi advokat di Indonesia berdasarkan '
              'Undang-Undang Nomor 18 Tahun 2003 tentang Advokat. Organisasi ini '
              'dibentuk oleh delapan organisasi advokat dan mempunyai wewenang untuk '
              'melaksanakan pendidikan khusus profesi advokat, pengujian advokat, '
              'pengangkatan dan pemberhentian advokat, serta pembentukan kode etik, '
              'dewan kehormatan, dan komisi pengawas.',
              style: TextStyle(fontSize: 14, height: 1.6),
            ),
            SizedBox(height: 12),
            Text(
              'PERADI dibentuk secara resmi sebagai wujud implementasi sistem '
              '“single bar” (wadah tunggal profesi advokat) yang diatur dalam UU '
              'Advokat. Deklarasi pendirian PERADI dilaksanakan pada tanggal 21 '
              'Desember 2004, dan Akta Pendirian dibuat pada tanggal 8 Desember 2005.',
              style: TextStyle(fontSize: 14, height: 1.6),
            ),
            SizedBox(height: 12),
            Text(
              'Sebagai organisasi profesi advokat yang mandiri, PERADI memiliki peran '
              'dalam penegakan hukum, pembinaan profesi, dan perlindungan hak serta '
              'kepentingan pencari keadilan di seluruh Indonesia. PERADI juga aktif '
              'mengembangkan berbagai kegiatan pendidikan, ujian profesi, serta acara '
              'organisasi lain.',
              style: TextStyle(fontSize: 14, height: 1.6),
            ),
            SizedBox(height: 16),
            Text(
              'Alamat Sekretariat Nasional:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'PERADI TOWER\nJl. Jend. Achmad Yani No.116, Jakarta Timur 13120\n'
              'Telepon: +62 21 3883 6000\nEmail: info@peradi.or.id',
              style: TextStyle(fontSize: 14, height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
