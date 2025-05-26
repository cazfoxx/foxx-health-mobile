class IncomeRange {
  final int id;
  final String incomeRange;

  const IncomeRange({
    required this.id,
    required this.incomeRange,
  });

  factory IncomeRange.fromJson(Map<String, dynamic> json) {
    return IncomeRange(
      id: json['id'],
      incomeRange: json['income_range'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'income_range': incomeRange,
    };
  }
}