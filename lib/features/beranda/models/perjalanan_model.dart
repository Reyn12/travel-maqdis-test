class PerjalananModel {
  final String perjalananId;
  final String? namaPerjalanan;

  PerjalananModel({
    required this.perjalananId,
    this.namaPerjalanan,
  });

  // Factory method to parse JSON
  factory PerjalananModel.fromJson(Map<String, dynamic> json) {
    return PerjalananModel(
      perjalananId: json['perjalananid'] as String,
      namaPerjalanan: json['nama_perjalanan'] as String? ??
          'Unnamed Trip', // Default if null
    );
  }

  // Method to convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'perjalananid': perjalananId,
      'nama_perjalanan': namaPerjalanan ?? 'Unnamed Trip', // Default if null
    };
  }
}
