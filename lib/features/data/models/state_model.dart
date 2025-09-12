class State {
  final int id;
  final String stateName;

  const State({
    required this.id,
    required this.stateName,
  });

  factory State.fromJson(Map<String, dynamic> json) {
    return State(
      id: json['id'],
      stateName: json['state_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'state_name': stateName,
    };
  }
}