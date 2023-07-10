class Tag {
  final int id;
  final String name;

  Tag({
    required this.id,
    required this.name,
  });

  String getCommaSeparatedNames() {
    return "id, name";
  }

  String getCommaSeparatedValues() {
    return "$id, $name";
  }

  factory Tag.fromJson(Map<String, dynamic> json) {
    return Tag(
      id: json['id'] as int,
      name: json['name'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
