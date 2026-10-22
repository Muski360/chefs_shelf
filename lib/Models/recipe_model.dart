class RecipeModel {
  final String? id;
  final String title;
  final String? imagePath;
  final String? category;
  final String? area;
  final List<String> tags;
  final List<String> ingredients;
  final List<String> instructions;

  const RecipeModel({
    this.id,
    required this.title,
    this.imagePath,
    this.category,
    this.area,
    this.tags = const [],
    this.ingredients = const [],
    this.instructions = const [],
  });

  /// Serializes the app's structured recipe format for Firestore.
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
    if (map.containsKey('strMeal') || map.containsKey('idMeal')) {
      return RecipeModel.fromMealDb(map);
    }
    return RecipeModel(
      id: map['id']?.toString(),
      title: map['title']?.toString() ?? '',
      imagePath: map['imagePath']?.toString(),
      category: map['category']?.toString(),
      area: map['area']?.toString(),
      tags: _strings(map['tags']),
      ingredients: _strings(map['ingredients']),
      instructions: _strings(map['instructions']),
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
      id: meal['idMeal']?.toString(),
      title: meal['strMeal']?.toString() ?? '',
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
}
