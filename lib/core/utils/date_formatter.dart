import 'package:intl/intl.dart';

// date formatter dengan id localization
String formatTanggal(String waktuMulai) {
  return DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.parse(waktuMulai));
}
