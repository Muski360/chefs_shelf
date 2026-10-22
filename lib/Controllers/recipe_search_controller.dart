import 'package:chefs_shelf/Models/recipe_model.dart';
import 'package:chefs_shelf/Services/mealdb_service.dart';
import 'package:flutter/foundation.dart';

class RecipeSearchController extends ChangeNotifier {
  List<RecipeModel> recipes = [];
  bool loading = false;
  String? error;
  bool searched = false;
  bool _disposed = false;

  Future<void> search(String query) async {
    if (loading || query.trim().isEmpty) return;
    loading = true;
    error = null;
    searched = true;
    notifyListeners();

    try {
      recipes = await MealdbService.searchRecipes(query);
    } catch (_) {
      recipes = [];
      error = 'Não foi possível buscar receitas. Verifique sua conexão.';
    } finally {
      loading = false;
      if (!_disposed) notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
