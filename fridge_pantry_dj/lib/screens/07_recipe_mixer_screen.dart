import 'package:flutter/material.dart';

class RecipeMixerScreen extends StatefulWidget {
  const RecipeMixerScreen({super.key});

  @override
  State<RecipeMixerScreen> createState() => _RecipeMixerScreenState();
}

class _RecipeMixerScreenState extends State<RecipeMixerScreen> {
  // Dietary preferences
  Map<String, bool> dietaryPreferences = {
    'Gluten Free': false,
    'Vegan': false,
    'Vegetarian': false,
    'Dairy Free': false,
  };

  // Sample user ingredients (would come from previous screen or database)
  List<String> userIngredients = [
    'Pasta',
    'Tomato',
    'Garlic',
    'Cheese',
    'Basil',
    'Chicken',
    'Rice',
    'Eggs',
  ];

  // Sample recipe results
  List<Recipe> recipes = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _generateInitialRecipes();
  }

  void _generateInitialRecipes() {
    // Sample recipes based on user ingredients
    recipes = [
      Recipe(
        name: 'Tomato Pasta',
        matchingIngredients: ['Pasta', 'Tomato', 'Garlic', 'Cheese', 'Basil'],
        cookingTime: '20 mins',
        difficulty: 'Easy',
      ),
      Recipe(
        name: 'Chicken Fried Rice',
        matchingIngredients: ['Chicken', 'Rice', 'Eggs', 'Garlic'],
        cookingTime: '25 mins',
        difficulty: 'Medium',
      ),
      Recipe(
        name: 'Basil Tomato Eggs',
        matchingIngredients: ['Eggs', 'Tomato', 'Basil', 'Cheese'],
        cookingTime: '15 mins',
        difficulty: 'Easy',
      ),
    ];
  }

  void _surpriseMe() async {
    setState(() {
      isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Generate surprise recipes
    List<Recipe> surpriseRecipes = [
      Recipe(
        name: 'DJ\'s Special Fusion Bowl',
        matchingIngredients: ['Rice', 'Eggs', 'Cheese', 'Basil'],
        cookingTime: '30 mins',
        difficulty: 'Medium',
        isSurprise: true,
      ),
      Recipe(
        name: 'Midnight Kitchen Mix',
        matchingIngredients: ['Pasta', 'Chicken', 'Garlic', 'Tomato'],
        cookingTime: '35 mins',
        difficulty: 'Hard',
        isSurprise: true,
      ),
    ];

    setState(() {
      recipes = surpriseRecipes;
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🎵 Surprise recipes mixed for you!'),
        backgroundColor: Color(0xFF9BCF53),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _searchRecipes() async {
    setState(() {
      isLoading = true;
    });

    // Simulate search with dietary filters
    await Future.delayed(const Duration(seconds: 1));

    _generateFilteredRecipes();

    setState(() {
      isLoading = false;
    });
  }

  void _generateFilteredRecipes() {
    // Filter recipes based on dietary preferences
    List<Recipe> filteredRecipes = [
      Recipe(
        name: 'Tomato Pasta',
        matchingIngredients: ['Pasta', 'Tomato', 'Garlic', 'Cheese', 'Basil'],
        cookingTime: '20 mins',
        difficulty: 'Easy',
      ),
      Recipe(
        name: 'Garlic Rice Bowl',
        matchingIngredients: ['Rice', 'Garlic', 'Basil'],
        cookingTime: '18 mins',
        difficulty: 'Easy',
      ),
    ];

    // Apply dietary filters
    if (dietaryPreferences['Vegan']!) {
      filteredRecipes = filteredRecipes
          .where(
            (recipe) =>
                !recipe.matchingIngredients.contains('Cheese') &&
                !recipe.matchingIngredients.contains('Chicken') &&
                !recipe.matchingIngredients.contains('Eggs'),
          )
          .toList();
    }

    if (dietaryPreferences['Vegetarian']!) {
      filteredRecipes = filteredRecipes
          .where((recipe) => !recipe.matchingIngredients.contains('Chicken'))
          .toList();
    }

    setState(() {
      recipes = filteredRecipes;
    });
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
                      'Recipe Mixer',
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dietary Requirements Section
                      const Text(
                        'Dietary Requirements',
                        style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E3D36),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Dietary checkboxes
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: dietaryPreferences.entries.map((entry) {
                          return FilterChip(
                            label: Text(
                              entry.key,
                              style: TextStyle(
                                fontFamily: 'NunitoSans',
                                fontWeight: FontWeight.w600,
                                color: entry.value
                                    ? Colors.white
                                    : const Color(0xFF1E3D36),
                              ),
                            ),
                            selected: entry.value,
                            onSelected: (selected) {
                              setState(() {
                                dietaryPreferences[entry.key] = selected;
                              });
                            },
                            backgroundColor: const Color(0xFFB8D4E3),
                            selectedColor: const Color(0xFF5EAAA8),
                            checkmarkColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 24),

                      // Surprise Me Button
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9BCF53), Color(0xFF7AB83F)],
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: isLoading ? null : _surpriseMe,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.casino,
                                  color: Color(0xFF7AB83F),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Surprise me',
                                style: TextStyle(
                                  fontFamily: 'NunitoSans',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E3D36),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Search button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF5EAAA8),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: isLoading ? null : _searchRecipes,
                          child: const Text(
                            'Mix Recipes 🎵',
                            style: TextStyle(
                              fontFamily: 'NunitoSans',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Loading indicator or recipes
                      if (isLoading)
                        const Center(
                          child: Column(
                            children: [
                              CircularProgressIndicator(
                                color: Color(0xFF5EAAA8),
                              ),
                              SizedBox(height: 16),
                              Text(
                                'Mixing your perfect recipes...',
                                style: TextStyle(
                                  fontFamily: 'NunitoSans',
                                  fontSize: 16,
                                  color: Color(0xFF1E3D36),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        // Recipe Results
                        Column(
                          children: recipes.map((recipe) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 16),
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
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Recipe title with surprise icon
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            recipe.name,
                                            style: const TextStyle(
                                              fontFamily: 'NunitoSans',
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1E3D36),
                                            ),
                                          ),
                                        ),
                                        if (recipe.isSurprise)
                                          const Icon(
                                            Icons.auto_awesome,
                                            color: Color(0xFF9BCF53),
                                            size: 24,
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),

                                    // Recipe info
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.access_time,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          recipe.cookingTime,
                                          style: TextStyle(
                                            fontFamily: 'NunitoSans',
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        Icon(
                                          Icons.bar_chart,
                                          size: 16,
                                          color: Colors.grey[600],
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          recipe.difficulty,
                                          style: TextStyle(
                                            fontFamily: 'NunitoSans',
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),

                                    // Matching ingredients
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: recipe.matchingIngredients.map((
                                        ingredient,
                                      ) {
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                userIngredients.contains(
                                                  ingredient,
                                                )
                                                ? const Color(0xFF9BCF53)
                                                : const Color(0xFFB8D4E3),
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          child: Text(
                                            ingredient,
                                            style: const TextStyle(
                                              fontFamily: 'NunitoSans',
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF1E3D36),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                    const SizedBox(height: 16),

                                    // View Recipe button
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF5EAAA8,
                                          ),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                        ),
                                        onPressed: () {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Opening ${recipe.name} recipe...',
                                              ),
                                              backgroundColor: const Color(
                                                0xFF5EAAA8,
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'View Recipe',
                                          style: TextStyle(
                                            fontFamily: 'NunitoSans',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                      const SizedBox(height: 24),

                      // Main Menu button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF9BCF53),
                            foregroundColor: const Color(0xFF1E3D36),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: () =>
                              Navigator.pushNamed(context, '/main-menu'),
                          child: const Text(
                            'Main Menu',
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

// Recipe model class
class Recipe {
  final String name;
  final List<String> matchingIngredients;
  final String cookingTime;
  final String difficulty;
  final bool isSurprise;

  Recipe({
    required this.name,
    required this.matchingIngredients,
    required this.cookingTime,
    required this.difficulty,
    this.isSurprise = false,
  });
}
