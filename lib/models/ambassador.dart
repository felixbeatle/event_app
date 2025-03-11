class Ambassador {
  final String id;
  final String name;

  Ambassador({
    required this.id,
    required this.name,
  });

  factory Ambassador.fromJson(Map<String, dynamic> json) {
    return Ambassador(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}