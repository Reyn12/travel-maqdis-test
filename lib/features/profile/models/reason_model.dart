class ReasonModel {
  final String reasonId;
  final String reason;

  ReasonModel({
    required this.reasonId,
    required this.reason,
  });

  factory ReasonModel.fromJson(Map<String, dynamic> json) {
    return ReasonModel(
      reasonId: json['reasonId'],
      reason: json['reason'],
    );
  }
}
