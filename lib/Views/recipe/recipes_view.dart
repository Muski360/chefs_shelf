import 'package:chefs_shelf/Controllers/recipe_search_controller.dart';
import 'package:chefs_shelf/Views/recipe/recipe_detail_view.dart';
import 'package:flutter/material.dart';

class RecipesView extends StatefulWidget {
  const RecipesView({super.key});

  @override
  State<RecipesView> createState() => _RecipesViewState();
}

class _RecipesViewState extends State<RecipesView> {
  final _search = TextEditingController();
  final _controller = RecipeSearchController();

  @override
  void dispose() {
    _search.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    _controller.search(_search.text);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _search,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              hintText: 'Buscar receita por nome',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                tooltip: 'Buscar',
                icon: const Icon(Icons.arrow_forward),
                onPressed: _submit,
              ),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              if (_controller.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (_controller.error != null) {
                return Center(child: Text(_controller.error!));
              }
              if (_controller.recipes.isEmpty) {
                return Center(
                  child: Text(
                    _controller.searched
                        ? 'Nenhuma receita encontrada.'
                        : 'Pesquise uma receita para começar.',
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                itemCount: _controller.recipes.length,
                itemBuilder: (context, index) {
                  final recipe = _controller.recipes[index];
                  return Card(
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(8),
                      leading: SizedBox(
                        width: 64,
                        height: 64,
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
                      subtitle: Text(
                        [recipe.category, recipe.area]
                            .whereType<String>()
                            .where((item) => item.isNotEmpty)
                            .join(' • '),
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RecipeDetailView(recipe: recipe),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
