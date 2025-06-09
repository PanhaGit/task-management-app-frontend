class CategoryColor {
  final String hex;
  final String name;

  CategoryColor({required this.hex, required this.name});

  factory CategoryColor.fromJson(Map<String, dynamic> json) {
    return CategoryColor(
      hex: json['hex'] as String,
      name: json['name'] as String,
    );
  }

  // Fallback colors in case backend fails
  static final List<CategoryColor> fallbackColors = [
    CategoryColor(hex: '#FF0000', name: 'Red'),
    CategoryColor(hex: '#0000FF', name: 'Blue'),
    CategoryColor(hex: '#00FF00', name: 'Green'),
    CategoryColor(hex: '#FFFF00', name: 'Yellow'),
    CategoryColor(hex: '#800080', name: 'Purple'),
    CategoryColor(hex: '#FFA500', name: 'Orange'),
  ];
}