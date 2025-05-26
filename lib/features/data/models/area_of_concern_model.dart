class AreaOfConcern {
  final int id;
  final String areaOfConcernName;

  AreaOfConcern({
    required this.id,
    required this.areaOfConcernName,
  });

  factory AreaOfConcern.fromJson(Map<String, dynamic> json) {
    return AreaOfConcern(
      id: json['id'],
      areaOfConcernName: json['area_of_concern_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'area_of_concern_name': areaOfConcernName,
    };
  }
}