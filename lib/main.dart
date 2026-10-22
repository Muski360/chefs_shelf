import 'package:chefs_shelf/Controllers/auth_controller.dart';
import 'package:chefs_shelf/Views/account/auth_view.dart';
import 'package:chefs_shelf/Views/recipe/recipe_book_view.dart';
import 'package:chefs_shelf/Views/recipe/recipes_view.dart';
import 'package:chefs_shelf/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chef's Shelf",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFAB5A2E)),
        useMaterial3: true,
      ),
      home: StreamBuilder<User?>(
        stream: AuthController().authStateChanges,
        initialData: FirebaseAuth.instance.currentUser,
        builder: (context, snapshot) =>
            snapshot.hasData ? const _HomeView() : const AuthView(),
      ),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  final _auth = AuthController();
  int _page = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_page == 0 ? 'Descobrir receitas' : 'Meu Caderno'),
        actions: [
          IconButton(
            tooltip: 'Sair',
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await _auth.signOut();
              } catch (_) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Não foi possível sair.')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _page,
        children: const [RecipesView(), RecipeBookView()],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _page,
        onDestinationSelected: (index) => setState(() => _page = index),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.search), label: 'Descobrir'),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Meu Caderno',
          ),
        ],
      ),
    );
  }
}
