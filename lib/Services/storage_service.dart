import 'package:chefs_shelf/Models/recipe_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorageService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _recipes {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw StateError('Faça login para acessar o caderno.');
    return _db.collection('users').doc(user.uid).collection('recipes');
  }

  Stream<List<RecipeModel>> getRecipes() => _recipes.snapshots().map(
    (snapshot) =>
        snapshot.docs.map((doc) => RecipeModel.fromMap(doc.data())).toList()
          ..sort((a, b) => a.title.compareTo(b.title)),
  );

  Future<void> saveRecipe(RecipeModel recipe) =>
      _recipes.doc(recipe.id).set(recipe.toMap());

  Future<void> deleteRecipe(String id) => _recipes.doc(id).delete();
}
