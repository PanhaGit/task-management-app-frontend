/// Author: Tho Panha
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
    return Categories(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      color: json['color'] ?? '#ffffff',
    );
  }

  factory Categories.empty() {
    return Categories(
      id: '',
      title: '',
      color: '#ffffff',
    );
  }
}

