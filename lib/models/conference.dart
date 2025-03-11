class Conference {
  final String id;
  final String jour;
  final String heure;
  final String url;

  Conference({
    required this.id,
    required this.jour,
    required this.heure,
    required this.url,
  });

  factory Conference.fromJson(Map<String, dynamic> json) {
    return Conference(
      id: json['_id'] ?? '',
      jour: json['Jour'] ?? '',
      heure: json['Heure'] ?? '',
      url: json['url'] ?? '',
    );
  }
}