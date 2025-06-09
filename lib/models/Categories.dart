class Categories {
  final String id;
  final String title;
  final String color;

  Categories({
    required this.id,
    required this.title,
    required this.color,
  });

  factory Categories.fromJson(Map<String, dynamic> json) {
    try {
      final data = json['data'] ?? json;
      return Categories(
        id: _parseString(data['_id']) ?? _parseString(data['id']) ?? '',
        title: _parseString(data['title']) ?? '',
        color: _parseString(data['color']) ?? '#ffffff',
      );
    } catch (e) {
      print("Error parsing Categories from JSON: $e, JSON: $json");
      return Categories.empty();
    }
  }

  factory Categories.empty() {
    return Categories(
      id: '',
      title: '',
      color: '#ffffff',
    );
  }

  static String? _parseString(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is int || value is double) return value.toString();
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'color': color,
    };
  }
}