import 'package:chefs_shelf/Controllers/recipe_book_controller.dart';
import 'package:chefs_shelf/Models/recipe_model.dart';
import 'package:flutter/material.dart';

class RecipeDetailView extends StatefulWidget {
  const RecipeDetailView({super.key, required this.recipe, this.saved = false});

  final RecipeModel recipe;
  final bool saved;

  @override
  State<RecipeDetailView> createState() => _RecipeDetailViewState();
}

class _RecipeDetailViewState extends State<RecipeDetailView> {
  final _controller = RecipeBookController();
  bool _saving = false;
  bool _savedNow = false;

  Future<void> _save() async {
    setState(() => _saving = true);
    try {
      await _controller.save(widget.recipe);
      if (mounted) {
        setState(() => _savedNow = true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Receita salva no caderno.')),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível salvar a receita.')),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    return Scaffold(
      appBar: AppBar(title: Text(recipe.title)),
      body: ListView(
        children: [
          if (recipe.imagePath?.isNotEmpty == true)
            Image.network(
              recipe.imagePath!,
              height: 240,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const SizedBox(
                height: 160,
                child: Center(child: Icon(Icons.restaurant_menu, size: 64)),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                if (recipe.category?.isNotEmpty == true ||
                    recipe.area?.isNotEmpty == true) ...[
                  const SizedBox(height: 8),
                  Text(
                    [recipe.category, recipe.area]
                        .whereType<String>()
                        .where((item) => item.isNotEmpty)
                        .join(' • '),
                  ),
                ],
                if (recipe.tags.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    children: recipe.tags
                        .map((tag) => Chip(label: Text(tag)))
                        .toList(),
                  ),
                ],
                const SizedBox(height: 24),
                Text(
                  'Ingredientes',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                if (recipe.ingredients.isEmpty)
                  const Text('Ingredientes indisponíveis.')
                else
                  ...recipe.ingredients.map(
                    (ingredient) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text('• $ingredient'),
                    ),
                  ),
                const SizedBox(height: 24),
                Text(
                  'Modo de preparo',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                if (recipe.instructions.isEmpty)
                  const Text('Instruções indisponíveis.')
                else
                  ...recipe.instructions.asMap().entries.map(
                    (entry) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text('${entry.key + 1}. ${entry.value}'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: widget.saved
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.icon(
                  onPressed: _saving || _savedNow ? null : _save,
                  icon: Icon(
                    _savedNow ? Icons.check : Icons.bookmark_add_outlined,
                  ),
                  label: Text(
                    _savedNow ? 'Salvo no caderno' : 'Salvar no caderno',
                  ),
                ),
              ),
            ),
    );
  }
}
