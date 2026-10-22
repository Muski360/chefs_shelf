import 'package:chefs_shelf/Controllers/recipe_book_controller.dart';
import 'package:chefs_shelf/Models/recipe_model.dart';
import 'package:chefs_shelf/Views/recipe/recipe_detail_view.dart';
import 'package:flutter/material.dart';

class RecipeBookView extends StatefulWidget {
  const RecipeBookView({super.key});

  @override
  State<RecipeBookView> createState() => _RecipeBookViewState();
}

class _RecipeBookViewState extends State<RecipeBookView> {
  final _controller = RecipeBookController();
  late final Stream<List<RecipeModel>> _recipes;

  @override
  void initState() {
    super.initState();
    _recipes = _controller.recipes;
  }

  Future<void> _remove(RecipeModel recipe) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover receita?'),
        content: Text('Remover ${recipe.title} do seu caderno?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Remover'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    try {
      await _controller.remove(recipe.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Receita removida do caderno.')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível remover a receita.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<RecipeModel>>(
      stream: _recipes,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Não foi possível carregar o caderno.'),
          );
        }
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final recipes = snapshot.data!;
        if (recipes.isEmpty) {
          return const Center(child: Text('Seu caderno está vazio.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: recipes.length,
          itemBuilder: (context, index) {
            final recipe = recipes[index];
            return Card(
              child: ListTile(
                leading: SizedBox(
                  width: 56,
                  height: 56,
                  child: recipe.imagePath == null
                      ? const Icon(Icons.restaurant_menu)
                      : Image.network(
                          recipe.imagePath!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.restaurant_menu),
                        ),
                ),
                title: Text(recipe.title),
                subtitle: Text(recipe.category ?? 'Receita salva'),
                trailing: IconButton(
                  tooltip: 'Remover do caderno',
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _remove(recipe),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RecipeDetailView(recipe: recipe, saved: true),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
