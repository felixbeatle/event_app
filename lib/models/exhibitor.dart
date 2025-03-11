class Exhibitor {
  final String id;
  final String entreprise;

  Exhibitor({
    required this.id,
    required this.entreprise,
  });

  factory Exhibitor.fromJson(Map<String, dynamic> json) {
    return Exhibitor(
      id: json['_id'] ?? '',
      entreprise: json['entreprise'] ?? '',
    );
  }
}
