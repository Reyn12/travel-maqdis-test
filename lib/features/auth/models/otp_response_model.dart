class OTPResponse {
  final String message;
  final String type;

  OTPResponse({required this.message, required this.type});

  // Factory method untuk parsing dari JSON
  factory OTPResponse.fromJson(Map<String, dynamic> json) {
    return OTPResponse(
      message: json['message'],
      type: json['type'],
    );
  }
}
