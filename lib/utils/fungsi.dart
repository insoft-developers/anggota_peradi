import 'package:intl/intl.dart';

class Fungsi {
  static String formatRibuan(String value) {
    try {
      final number = double.parse(value); // ubah string ke double
      final formatter = NumberFormat('#,###', 'id_ID');
      return formatter.format(number);
    } catch (e) {
      return value; // jika gagal parsing, kembalikan string asli
    }
  }

  static String getEndDate(int yearsToAdd) {
    DateTime endDate = DateTime.now().add(Duration(days: yearsToAdd * 365));
    String formattedDate = DateFormat('dd MMMM yyyy', 'id_ID').format(endDate);
    return formattedDate;
  }
}
