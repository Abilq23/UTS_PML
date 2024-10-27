import 'package:flutter/material.dart';

class RecipeListPage extends StatelessWidget {
  const RecipeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Resep Makanan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Jumlah kolom
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.75, // Rasio lebar dan tinggi kartu
          ),
          itemCount: dummyRecipes.length,
          itemBuilder: (context, index) {
            final recipe = dummyRecipes[index];
            return _buildRecipeCard(recipe);
          },
        ),
      ),
    );
  }

  Widget _buildRecipeCard(Recipe recipe) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              recipe.imageUrl,
              fit: BoxFit.cover,
              height: 120,
              width: double.infinity,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              recipe.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              recipe.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class Recipe {
  final String title;
  final String description;
  final String imageUrl;

  Recipe({required this.title, required this.description, required this.imageUrl});
}

List<Recipe> dummyRecipes = [
  Recipe(
    title: "Nasi Goreng",
    description: "Nasi Goreng adalah hidangan nasi yang digoreng dengan bumbu.",
    imageUrl: "https://example.com/nasi_goreng.jpg",
  ),
  Recipe(
    title: "Sate Ayam",
    description: "Sate Ayam adalah daging ayam yang ditusuk dan dipanggang.",
    imageUrl: "https://example.com/sate_ayam.jpg",
  ),
  Recipe(
    title: "Rendang",
    description: "Rendang adalah masakan daging yang dimasak dengan rempah-rempah.",
    imageUrl: "https://example.com/rendang.jpg",
  ),
  Recipe(
    title: "Sop Buntut",
    description: "Sop Buntut adalah sup yang terbuat dari buntut sapi.",
    imageUrl: "https://example.com/sop_buntut.jpg",
  ),
];
