class EnergyPoint {
  final DateTime date;
  final int valueW;
  final double valueKW;

  EnergyPoint(
      {required this.date, required this.valueW, required this.valueKW});

  factory EnergyPoint.fromJson(Map<String, dynamic> json) {
    return EnergyPoint(
        date: DateTime.parse(json['timestamp']),
        valueW: json['value'],
        valueKW: double.parse((json['value'] / 1000).toStringAsFixed(1)));
  }
}
