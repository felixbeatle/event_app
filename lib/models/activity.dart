class Activity {
  final String jour;
  final String horaire;
  final String emplacement;
  final String url;
  final String title;
  final String description;

  Activity({
    required this.jour,
    required this.horaire,
    required this.emplacement,
    required this.url,
    required this.title,
    required this.description,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      jour: json['jour'] ?? '',
      horaire: json['horaire'] ?? '',
      emplacement: json['emplacement'] ?? '',
      url: json['url'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
    );
  }
}