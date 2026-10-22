import 'package:chefs_shelf/Models/recipe_model.dart';
import 'package:chefs_shelf/Services/storage_service.dart';

class RecipeBookController {
  final StorageService _storage = StorageService();

  Stream<List<RecipeModel>> get recipes => _storage.getRecipes();

  Future<void> save(RecipeModel recipe) => _storage.saveRecipe(recipe);

  Future<void> remove(String id) => _storage.deleteRecipe(id);
}
