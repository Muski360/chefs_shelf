class RecipeModel {
  final String id;
  final String title;
  final String? imagePath;
  final String? category;
  final String? area;
  final List<String> tags;
  final List<String> ingredients;
  final List<String> instructions;

  const RecipeModel({
    required this.id,
    required this.title,
    this.imagePath,
    this.category,
    this.area,
    this.tags = const [],
    required this.ingredients,
    required this.instructions,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'imagePath': imagePath,
    'category': category,
    'area': area,
    'tags': tags,
    'ingredients': ingredients,
    'instructions': instructions,
  };

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
      id: _requiredString(map['id'], 'id'),
      title: _requiredString(map['title'], 'title'),
      imagePath: map['imagePath']?.toString(),
      category: map['category']?.toString(),
      area: map['area']?.toString(),
      tags: List<String>.from(map['tags'] as List? ?? const []),
      ingredients: List<String>.from(map['ingredients'] as List),
      instructions: List<String>.from(map['instructions'] as List),
    );
  }

  factory RecipeModel.fromMealDb(Map<String, dynamic> meal) {
    final ingredients = <String>[];
    for (var i = 1; i <= 20; i++) {
      final ingredient = meal['strIngredient$i']?.toString().trim() ?? '';
      final measure = meal['strMeasure$i']?.toString().trim() ?? '';
      if (ingredient.isNotEmpty) {
        ingredients.add(measure.isEmpty ? ingredient : '$measure $ingredient');
      }
    }

    return RecipeModel(
      id: _requiredString(meal['idMeal'], 'idMeal'),
      title: _requiredString(meal['strMeal'], 'strMeal'),
      imagePath: meal['strMealThumb']?.toString(),
      category: meal['strCategory']?.toString(),
      area: meal['strArea']?.toString(),
      tags: _strings(meal['strTags']?.toString().split(',')),
      ingredients: ingredients,
      instructions: _strings(
        meal['strInstructions']?.toString().split(RegExp(r'\r?\n')),
      ),
    );
  }

  static List<String> _strings(dynamic value) {
    if (value is! Iterable) return const [];
    return value
        .map((item) => item?.toString().trim() ?? '')
        .where((item) => item.isNotEmpty)
        .toList();
  }

  static String _requiredString(dynamic value, String field) {
    if (value is! String || value.trim().isEmpty) {
      throw FormatException('Campo obrigatório inválido: $field');
    }
    return value.trim();
  }
}
