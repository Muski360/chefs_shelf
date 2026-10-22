import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:chefs_shelf/Models/recipe_model.dart';

class MealdbService {
  static Future<List<RecipeModel>> searchRecipes(String query) async {
    final response = await http.get(
      Uri.https('www.themealdb.com', '/api/json/v1/1/search.php', {
        's': query.trim(),
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Não foi possível buscar receitas.');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final meals = data['meals'] as List<dynamic>? ?? [];
    return meals
        .map((meal) => RecipeModel.fromMealDb(meal as Map<String, dynamic>))
        .toList();
  }
}
