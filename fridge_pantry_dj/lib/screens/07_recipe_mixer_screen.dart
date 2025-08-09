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

  // User ingredients from Add Ingredients page
  List<String> userIngredients = [];
  
  // Sample recipe results
  List<Recipe> recipes = [];
  bool isLoading = false;
  bool hasReceivedIngredients = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    
    // Get ingredients passed from Add Ingredients screen
    if (!hasReceivedIngredients) {
      final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      
      if (arguments != null && arguments['pantryIngredients'] != null) {
        setState(() {
          userIngredients = List<String>.from(arguments['pantryIngredients']);
          hasReceivedIngredients = true;
        });
        
        // Generate initial recipes based on received ingredients
        _generateInitialRecipes();
        
        // Show success message
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Found ${userIngredients.length} ingredients in your pantry!'),
              backgroundColor: const Color(0xFF5EAAA8),
              duration: const Duration(seconds: 2),
            ),
          );
        });
      } else {
        // Fallback to default ingredients if no data is passed
        setState(() {
          userIngredients = [
            'Pasta',
            'Tomato',
            'Garlic',
            'Cheese',
            'Basil',
            'Chicken',
            'Rice',
            'Eggs',
          ];
          hasReceivedIngredients = true;
        });
        _generateInitialRecipes();
      }
    }
  }

  void _generateInitialRecipes() {
    // Generate recipes based on actual user ingredients
    List<Recipe> initialRecipes = [];
    
    // Recipe matching logic based on user's ingredients
    if (_hasIngredients(['Pasta', 'Tomato'])) {
      initialRecipes.add(Recipe(
        name: 'Tomato Pasta',
        matchingIngredients: _getMatchingIngredients(['Pasta', 'Tomato', 'Garlic', 'Cheese', 'Basil']),
        cookingTime: '20 mins',
        difficulty: 'Easy',
      ));
    }
    
    if (_hasIngredients(['Chicken', 'Rice'])) {
      initialRecipes.add(Recipe(
        name: 'Chicken Fried Rice',
        matchingIngredients: _getMatchingIngredients(['Chicken', 'Rice', 'Eggs', 'Garlic']),
        cookingTime: '25 mins',
        difficulty: 'Medium',
      ));
    }
    
    if (_hasIngredients(['Eggs', 'Tomato'])) {
      initialRecipes.add(Recipe(
        name: 'Basil Tomato Eggs',
        matchingIngredients: _getMatchingIngredients(['Eggs', 'Tomato', 'Basil', 'Cheese']),
        cookingTime: '15 mins',
        difficulty: 'Easy',
      ));
    }
    
    if (_hasIngredients(['Beef'])) {
      initialRecipes.add(Recipe(
        name: 'Beef Stir Fry',
        matchingIngredients: _getMatchingIngredients(['Beef', 'Carrot', 'Garlic']),
        cookingTime: '30 mins',
        difficulty: 'Medium',
      ));
    }
    
    if (_hasIngredients(['Milk', 'Eggs'])) {
      initialRecipes.add(Recipe(
        name: 'Creamy Scrambled Eggs',
        matchingIngredients: _getMatchingIngredients(['Eggs', 'Milk', 'Cheese']),
        cookingTime: '10 mins',
        difficulty: 'Easy',
      ));
    }
    
    // If no specific recipes match, create some generic ones
    if (initialRecipes.isEmpty && userIngredients.isNotEmpty) {
      initialRecipes.add(Recipe(
        name: 'Creative Kitchen Mix',
        matchingIngredients: userIngredients.take(4).toList(),
        cookingTime: '25 mins',
        difficulty: 'Medium',
      ));
    }
    
    setState(() {
      recipes = initialRecipes;
    });
  }

  // Helper method to check if user has certain ingredients
  bool _hasIngredients(List<String> requiredIngredients) {
    return requiredIngredients.any((ingredient) => 
        userIngredients.any((userIngredient) => 
            userIngredient.toLowerCase().contains(ingredient.toLowerCase()) ||
            ingredient.toLowerCase().contains(userIngredient.toLowerCase())));
  }
  
  // Helper method to get matching ingredients from a recipe
  List<String> _getMatchingIngredients(List<String> recipeIngredients) {
    return recipeIngredients.where((ingredient) =>
        userIngredients.any((userIngredient) =>
            userIngredient.toLowerCase() == ingredient.toLowerCase())).toList();
  }

  void _surpriseMe() async {
    setState(() {
      isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    // Generate surprise recipes using user's actual ingredients
    List<Recipe> surpriseRecipes = [];
    
    if (userIngredients.length >= 3) {
      // Create creative combinations from user's ingredients
      List<String> shuffledIngredients = List.from(userIngredients)..shuffle();
      
      surpriseRecipes.add(Recipe(
        name: 'DJ\'s Special Fusion Bowl',
        matchingIngredients: shuffledIngredients.take(4).toList(),
        cookingTime: '30 mins',
        difficulty: 'Medium',
        isSurprise: true,
      ));
      
      if (userIngredients.length >= 4) {
        surpriseRecipes.add(Recipe(
          name: 'Midnight Kitchen Mix',
          matchingIngredients: shuffledIngredients.skip(1).take(4).toList(),
          cookingTime: '35 mins',
          difficulty: 'Hard',
          isSurprise: true,
        ));
      }
    } else {
      // Fallback for fewer ingredients
      surpriseRecipes.add(Recipe(
        name: 'Simple Surprise Dish',
        matchingIngredients: userIngredients,
        cookingTime: '20 mins',
        difficulty: 'Easy',
        isSurprise: true,
      ));
    }

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
    List<Recipe> filteredRecipes = [];
    
    // Start with all possible recipes based on ingredients
    if (_hasIngredients(['Pasta', 'Tomato'])) {
      filteredRecipes.add(Recipe(
        name: 'Tomato Pasta',
        matchingIngredients: _getMatchingIngredients(['Pasta', 'Tomato', 'Garlic', 'Cheese', 'Basil']),
        cookingTime: '20 mins',
        difficulty: 'Easy',
      ));
    }
    
    if (_hasIngredients(['Rice'])) {
      filteredRecipes.add(Recipe(
        name: 'Garlic Rice Bowl',
        matchingIngredients: _getMatchingIngredients(['Rice', 'Garlic', 'Basil']),
        cookingTime: '18 mins',
        difficulty: 'Easy',
      ));
    }
    
    if (_hasIngredients(['Chicken'])) {
      filteredRecipes.add(Recipe(
        name: 'Herb Chicken',
        matchingIngredients: _getMatchingIngredients(['Chicken', 'Garlic', 'Basil']),
        cookingTime: '35 mins',
        difficulty: 'Medium',
      ));
    }

    // Apply dietary filters
    if (dietaryPreferences['Vegan']!) {
      filteredRecipes = filteredRecipes.where((recipe) => 
        !recipe.matchingIngredients.any((ingredient) =>
          ['Cheese', 'Chicken', 'Eggs', 'Milk', 'Beef'].contains(ingredient))
      ).toList();
    }

    if (dietaryPreferences['Vegetarian']!) {
      filteredRecipes = filteredRecipes.where((recipe) => 
        !recipe.matchingIngredients.any((ingredient) =>
          ['Chicken', 'Beef', 'Lamb'].contains(ingredient))
      ).toList();
    }
    
    if (dietaryPreferences['Dairy Free']!) {
      filteredRecipes = filteredRecipes.where((recipe) => 
        !recipe.matchingIngredients.any((ingredient) =>
          ['Cheese', 'Milk'].contains(ingredient))
      ).toList();
    }
    
    if (dietaryPreferences['Gluten Free']!) {
      filteredRecipes = filteredRecipes.where((recipe) => 
        !recipe.matchingIngredients.any((ingredient) =>
          ['Pasta', 'Bread'].contains(ingredient))
      ).toList();
    }

    setState(() {
      recipes = filteredRecipes;
    });
    
    // Show message about applied filters
    List<String> activeFilters = dietaryPreferences.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    
    if (activeFilters.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Applied filters: ${activeFilters.join(", ")}'),
          backgroundColor: const Color(0xFF5EAAA8),
          duration: const Duration(seconds: 2),
        ),
      );
    }
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
                      // Your Pantry Ingredients Section
                      Row(
                        children: [
                          const Text(
                            'Your Pantry Ingredients',
                            style: TextStyle(
                              fontFamily: 'NunitoSans',
                              fontSize: 18,
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
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${userIngredients.length}',
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
                      const SizedBox(height: 12),

                      // Display user ingredients
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0x40FFFFFF),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: const Color(0xFF5EAAA8),
                            width: 2,
                          ),
                        ),
                        child: userIngredients.isEmpty
                            ? const Text(
                                'No ingredients received. Please add ingredients first.',
                                style: TextStyle(
                                  fontFamily: 'NunitoSans',
                                  fontSize: 14,
                                  color: Color(0xFF666666),
                                ),
                              )
                            : Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: userIngredients.map((ingredient) {
                                  return Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF5EAAA8),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: Text(
                                      ingredient,
                                      style: const TextStyle(
                                        fontFamily: 'NunitoSans',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                      ),
                      const SizedBox(height: 24),

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
                      const SizedBox(height: 16),

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
                      else if (recipes.isEmpty)
                        Center(
                          child: Column(
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No recipes found with your current ingredients and filters.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'NunitoSans',
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Try removing some dietary filters or adding more ingredients!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'NunitoSans',
                                  fontSize: 14,
                                  color: Colors.grey[500],
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
                                        const Spacer(),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF9BCF53),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '${recipe.matchingIngredients.length}/${recipe.matchingIngredients.length} match',
                                            style: const TextStyle(
                                              fontFamily: 'NunitoSans',
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xFF1E3D36),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),

                                    // Matching ingredients
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: recipe.matchingIngredients.map((ingredient) {
                                        bool userHasIngredient = userIngredients.any(
                                          (userIngredient) => userIngredient.toLowerCase() == ingredient.toLowerCase()
                                        );
                                        return Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: userHasIngredient
                                                ? const Color(0xFF9BCF53)
                                                : const Color(0xFFB8D4E3),
                                            borderRadius: BorderRadius.circular(15),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (userHasIngredient)
                                                const Icon(
                                                  Icons.check,
                                                  size: 14,
                                                  color: Color(0xFF1E3D36),
                                                ),
                                              if (userHasIngredient) const SizedBox(width: 4),
                                              Text(
                                                ingredient,
                                                style: const TextStyle(
                                                  fontFamily: 'NunitoSans',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Color(0xFF1E3D36),
                                                ),
                                              ),
                                            ],
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
                                          backgroundColor: const Color(0xFF5EAAA8),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          padding: const EdgeInsets.symmetric(vertical: 12),
                                        ),
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Opening ${recipe.name} recipe...'),
                                              backgroundColor: const Color(0xFF5EAAA8),
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

                      // Navigation buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFB8D4E3),
                                foregroundColor: const Color(0xFF1E3D36),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              onPressed: () => Navigator.pushNamed(context, '/add-ingredients'),
                              child: const Text(
                                'Add Ingredients',
                                style: TextStyle(
                                  fontFamily: 'NunitoSans',
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9BCF53),
                                foregroundColor: const Color(0xFF1E3D36),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              onPressed: () => Navigator.pushNamed(context, '/main-menu'),
                              child: const Text(
                                'Main Menu',
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