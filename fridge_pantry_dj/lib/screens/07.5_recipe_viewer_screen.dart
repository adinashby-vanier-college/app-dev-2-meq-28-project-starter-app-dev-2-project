import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RecipeViewerScreen extends StatefulWidget {
  const RecipeViewerScreen({super.key});

  @override
  State<RecipeViewerScreen> createState() => _RecipeViewerScreenState();
}

class _RecipeViewerScreenState extends State<RecipeViewerScreen> {
  Map<String, dynamic>? recipe;
  bool isLoading = true;
  String? error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadRecipe();
  }

  void _loadRecipe() async {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (arguments == null || arguments['recipeId'] == null) {
      setState(() {
        error = 'No recipe ID provided';
        isLoading = false;
      });
      return;
    }

    try {
      final recipeId = arguments['recipeId'];
      final response = await http.get(
        Uri.parse(
          'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$recipeId',
        ),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null && data['meals'].isNotEmpty) {
          setState(() {
            recipe = data['meals'][0];
            isLoading = false;
          });
        } else {
          setState(() {
            error = 'Recipe not found';
            isLoading = false;
          });
        }
      } else {
        setState(() {
          error = 'Failed to load recipe';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        error = 'Error loading recipe: $e';
        isLoading = false;
      });
    }
  }

  List<Map<String, String>> _getIngredients() {
    if (recipe == null) return [];

    List<Map<String, String>> ingredients = [];

    for (int i = 1; i <= 20; i++) {
      final ingredient = recipe!['strIngredient$i'];
      final measure = recipe!['strMeasure$i'];

      if (ingredient != null && ingredient.toString().trim().isNotEmpty) {
        ingredients.add({
          'ingredient': ingredient.toString().trim(),
          'measure': measure?.toString().trim() ?? '',
        });
      }
    }

    return ingredients;
  }

  List<String> _getInstructions() {
    if (recipe == null || recipe!['strInstructions'] == null) return [];

    String instructions = recipe!['strInstructions'].toString();

    // Split by periods, new lines, or numbered steps
    List<String> steps = instructions
        .split(RegExp(r'[\.\n]'))
        .where((step) => step.trim().isNotEmpty)
        .map((step) => step.trim())
        .where((step) => step.length > 10) // Filter out very short steps
        .toList();

    // If we don't get good steps, try splitting by sentences
    if (steps.length < 3) {
      steps = instructions
          .split(RegExp(r'(?<=[.!?])\s+'))
          .where((step) => step.trim().isNotEmpty && step.length > 20)
          .map((step) => step.trim())
          .toList();
    }

    // If still not good, return the whole instruction as one step
    if (steps.isEmpty) {
      steps = [instructions.trim()];
    }

    return steps;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFD1E8E5), // Light mint
              Color(0xFFA7E9D0), // Soft green
              Color(0xFF6BB3A8), // Deep teal
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Color(0xFF1E3D36),
                        size: 28,
                      ),
                    ),
                    const Text(
                      'Recipe',
                      style: TextStyle(
                        fontFamily: 'Pacifico',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3D36),
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: isLoading
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Color(0xFF5EAAA8)),
                            SizedBox(height: 16),
                            Text(
                              'Loading recipe...',
                              style: TextStyle(
                                fontFamily: 'NunitoSans',
                                fontSize: 16,
                                color: Color(0xFF1E3D36),
                              ),
                            ),
                          ],
                        ),
                      )
                    : error != null
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'NunitoSans',
                                fontSize: 16,
                                color: Color(0xFF1E3D36),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF5EAAA8),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Go Back'),
                            ),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Recipe Image
                            if (recipe!['strMealThumb'] != null)
                              Container(
                                width: double.infinity,
                                height: 200,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black,
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    recipe!['strMealThumb'],
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.image_not_supported,
                                          size: 64,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            const SizedBox(height: 20),

                            // Recipe Title
                            Text(
                              recipe!['strMeal'] ?? 'Unknown Recipe',
                              style: const TextStyle(
                                fontFamily: 'NunitoSans',
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E3D36),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Recipe Info
                            Row(
                              children: [
                                if (recipe!['strCategory'] != null) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF9BCF53),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      recipe!['strCategory'],
                                      style: const TextStyle(
                                        fontFamily: 'NunitoSans',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E3D36),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                if (recipe!['strArea'] != null) ...[
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF5EAAA8),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      recipe!['strArea'],
                                      style: const TextStyle(
                                        fontFamily: 'NunitoSans',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Ingredients Section
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0x80FFFFFF),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.shopping_cart,
                                        color: Color(0xFF5EAAA8),
                                        size: 24,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Ingredients',
                                        style: TextStyle(
                                          fontFamily: 'NunitoSans',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E3D36),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF9BCF53),
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: Text(
                                          '${_getIngredients().length}',
                                          style: const TextStyle(
                                            fontFamily: 'NunitoSans',
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1E3D36),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  ..._getIngredients().map((ing) {
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF5EAAA8),
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              '${ing['measure']} ${ing['ingredient']}',
                                              style: const TextStyle(
                                                fontFamily: 'NunitoSans',
                                                fontSize: 14,
                                                color: Color(0xFF1E3D36),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Instructions Section
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: const Color(0x80FFFFFF),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.restaurant,
                                        color: Color(0xFF9BCF53),
                                        size: 24,
                                      ),
                                      const SizedBox(width: 8),
                                      const Text(
                                        'Instructions',
                                        style: TextStyle(
                                          fontFamily: 'NunitoSans',
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF1E3D36),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  ..._getInstructions().asMap().entries.map((
                                    entry,
                                  ) {
                                    int index = entry.key;
                                    String instruction = entry.value;
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: 16,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            width: 24,
                                            height: 24,
                                            decoration: const BoxDecoration(
                                              color: Color(0xFF9BCF53),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                '${index + 1}',
                                                style: const TextStyle(
                                                  fontFamily: 'NunitoSans',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF1E3D36),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              instruction,
                                              style: const TextStyle(
                                                fontFamily: 'NunitoSans',
                                                fontSize: 14,
                                                color: Color(0xFF1E3D36),
                                                height: 1.5,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Video Link (if available)
                            if (recipe!['strYoutube'] != null &&
                                recipe!['strYoutube'].toString().isNotEmpty)
                              Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                  ),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Opening YouTube video...',
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.play_arrow),
                                      SizedBox(width: 8),
                                      Text(
                                        'Watch on YouTube',
                                        style: TextStyle(
                                          fontFamily: 'NunitoSans',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            const SizedBox(height: 32),

                            // Back button
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF5EAAA8),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context),
                                child: const Text(
                                  'Back to Recipes',
                                  style: TextStyle(
                                    fontFamily: 'NunitoSans',
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
