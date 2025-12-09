class LamiData {
  final double hands;
  final double inches;
  final double cm;
  final double adjustment;

  LamiData({
    required this.hands,
    required this.inches,
    required this.cm,
    required this.adjustment,
  });

  factory LamiData.fromJson(Map<String, dynamic> json) {
    return LamiData(
      hands: double.parse(json['hands'].toString()),
      inches: double.parse(json['inches'].toString()),
      cm: double.parse(json['cm'].toString()),
      adjustment: double.parse(json['adjustment'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hands': hands,
      'inches': inches,
      'cm': cm,
      'adjustment': adjustment,
    };
  }
}
