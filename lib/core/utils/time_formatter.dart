String formatDurasi(String durasi) {
  List<String> parts = durasi.split(':');
  int menit = int.parse(parts[0]);
  int detik = int.parse(parts[1]);

  int jam = menit ~/ 60;
  int sisaMenit = menit % 60;

  return '${jam.toString().padLeft(2, '0')}:'
      '${sisaMenit.toString().padLeft(2, '0')}:'
      '${detik.toString().padLeft(2, '0')}';
}

String formatDurasiSimple(String durasi) {
  List<String> parts = durasi.split(':');
  int menit = int.parse(parts[0]);
  int detik = int.parse(parts[1]);

  return '${menit.toString().padLeft(2, '0')}:'
      '${detik.toString().padLeft(2, '0')}';
}
