import 'package:flutter/material.dart';
//TODO  Import  API service

//TODO need to delete?
// For demo purposes, including the search functionality directly
class ApiService {
  static const List<String> _ingredientDatabase = [
    // Proteins
    'Chicken breast',
    'Chicken thighs',
    'Ground beef',
    'Beef steak',
    'Pork chops',
    'Salmon', 'Tuna', 'Shrimp', 'Eggs', 'Tofu', 'Beans', 'Lentils', 'Chickpeas',

    // Vegetables
    'Tomatoes', 'Onions', 'Garlic', 'Bell peppers', 'Carrots', 'Broccoli',
    'Spinach',
    'Lettuce',
    'Cucumbers',
    'Mushrooms',
    'Potatoes',
    'Sweet potatoes',
    'Zucchini', 'Eggplant', 'Celery', 'Cabbage', 'Cauliflower', 'Green beans',

    // Grains & Starches
    'Rice', 'Pasta', 'Bread', 'Quinoa', 'Oats', 'Flour', 'Noodles', 'Couscous',

    // Dairy & Alternatives
    'Milk',
    'Cheese',
    'Yogurt',
    'Butter',
    'Cream',
    'Almond milk',
    'Coconut milk',

    // Herbs & Spices
    'Basil', 'Oregano', 'Thyme', 'Rosemary', 'Parsley', 'Cilantro', 'Salt',
    'Black pepper', 'Paprika', 'Cumin', 'Garlic powder', 'Onion powder',

    // Pantry Staples
    'Olive oil', 'Vegetable oil', 'Vinegar', 'Soy sauce', 'Honey', 'Sugar',
    'Baking powder', 'Vanilla extract', 'Canned tomatoes', 'Coconut oil',

    // Fruits
    'Apples', 'Bananas', 'Oranges', 'Lemons', 'Limes', 'Berries', 'Avocados',

    // Frozen Items
    'Frozen peas', 'Frozen corn', 'Frozen berries', 'Frozen vegetables',
  ];

  static List<String> searchIngredients(String query) {
    if (query.isEmpty) return [];

    final lowercaseQuery = query.toLowerCase();

    List<String> exactMatches = _ingredientDatabase
        .where(
          (ingredient) => ingredient.toLowerCase().startsWith(lowercaseQuery),
        )
        .toList();

    List<String> partialMatches = _ingredientDatabase
        .where(
          (ingredient) =>
              ingredient.toLowerCase().contains(lowercaseQuery) &&
              !ingredient.toLowerCase().startsWith(lowercaseQuery),
        )
        .toList();

    List<String> allMatches = [...exactMatches, ...partialMatches];
    return allMatches.take(8).toList();
  }
}

class AddIngredientsScreen extends StatefulWidget {
  const AddIngredientsScreen({super.key});

  @override
  State<AddIngredientsScreen> createState() => _AddIngredientsScreenState();
}

class _AddIngredientsScreenState extends State<AddIngredientsScreen> {
  final TextEditingController customIngredientController =
      TextEditingController();

  // List to store user's pantry items (dynamic - can be loaded from database)
  List<String> pantryItems = [
    'Beef',
    'Chicken',
    'Carrot',
    'Eggs',
    'Milk',
    'Bread',
  ];

  // Predefined common ingredients (dynamic - user can add/edit/delete)
  List<String> commonIngredients = [
    'Chicken',
    'Rice',
    'Eggs',
    'Beef',
    'Pasta',
    'Tomato',
    'Lamb',
    'Carrot',
    'Potato',
    'Cabbage',
    'Milk',
    'Bread',
  ];

  @override
  void initState() {
    super.initState();
    // TODO: Load data from Firebase/database
    _loadUserData();
  }

  void _loadUserData() {
    // TODO: Replace with actual database loading
    // This would load both pantryItems and commonIngredients from user's saved data
  }

  void _saveUserData() {
    // TODO: Save both lists to Firebase/database
    // This would save pantryItems and commonIngredients to user's profile
  }

  void _addCustomIngredient() {
    String ingredient = customIngredientController.text.trim();
    if (ingredient.isNotEmpty && !pantryItems.contains(ingredient)) {
      setState(() {
        // Add to pantry only
        pantryItems.add(ingredient);
      });
      customIngredientController.clear();
      _saveUserData(); // Save changes

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$ingredient added to your pantry!'),
          backgroundColor: const Color(0xFF5EAAA8),
          duration: const Duration(seconds: 2),
        ),
      );
    } else if (pantryItems.contains(ingredient)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This ingredient is already in your pantry!'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _toggleCommonIngredient(String ingredient) {
    setState(() {
      if (pantryItems.contains(ingredient)) {
        pantryItems.remove(ingredient);
      } else {
        pantryItems.add(ingredient);
      }
    });
    _saveUserData(); // Save changes

    String message = pantryItems.contains(ingredient)
        ? '$ingredient added to your pantry!'
        : '$ingredient removed from your pantry!';
    Color backgroundColor = pantryItems.contains(ingredient)
        ? const Color(0xFF5EAAA8)
        : Colors.red[400]!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _removeIngredient(String ingredient) {
    setState(() {
      pantryItems.remove(ingredient);
    });
    _saveUserData(); // Save changes

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$ingredient removed from your pantry!'),
        backgroundColor: Colors.red[400],
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _editCommonIngredient(String oldIngredient) {
    TextEditingController editController = TextEditingController(
      text: oldIngredient,
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Edit Ingredient',
            style: TextStyle(
              fontFamily: 'NunitoSans',
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E3D36),
            ),
          ),
          content: TextField(
            controller: editController,
            style: const TextStyle(
              fontFamily: 'NunitoSans',
              color: Color(0xFF1E3D36),
            ),
            decoration: const InputDecoration(
              hintText: 'Enter ingredient name',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newIngredient = editController.text.trim();
                if (newIngredient.isNotEmpty &&
                    newIngredient != oldIngredient) {
                  setState(() {
                    int index = commonIngredients.indexOf(oldIngredient);
                    if (index != -1) {
                      commonIngredients[index] = newIngredient;
                    }
                    // Update in pantry too if it exists
                    int pantryIndex = pantryItems.indexOf(oldIngredient);
                    if (pantryIndex != -1) {
                      pantryItems[pantryIndex] = newIngredient;
                    }
                  });
                  _saveUserData();
                }
                Navigator.of(context).pop();
                editController.dispose();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Navigate to Recipe Mixer with pantry ingredients
  void _searchRecipes() {
    if (pantryItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add some ingredients to your pantry first!'),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    // Navigate to Recipe Mixer and pass the pantry ingredients
    Navigator.pushNamed(
      context,
      '/recipe-mixer',
      arguments: {
        'pantryIngredients': List<String>.from(pantryItems), // Pass a copy
      },
    );
  }

  @override
  void dispose() {
    customIngredientController.dispose();
    super.dispose();
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
              // Top bar with back button and title
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
                      'Fridge & Pantry',
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

              // Content Area
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Edit Your Items subtitle
                      const Text(
                        'Edit Your Items',
                        style: TextStyle(
                          fontFamily: 'NunitoSans',
                          fontSize: 18,
                          color: Color(0xFF1E3D36),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Custom ingredient input
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFB8D4E3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: customIngredientController,
                                style: const TextStyle(
                                  fontFamily: 'NunitoSans',
                                  fontSize: 15,
                                  color: Color(0xFF1E3D36),
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Type your Ingredients',
                                  hintStyle: TextStyle(
                                    color: Color(0xFF666666),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 16,
                                  ),
                                ),
                                onSubmitted: (_) => _addCustomIngredient(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: IconButton(
                                onPressed: _addCustomIngredient,
                                icon: const Icon(
                                  Icons.add,
                                  color: Color(0xFF1E3D36),
                                  size: 5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Common ingredients checklist grid
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 2.2,
                            ),
                        itemCount: commonIngredients.length,
                        itemBuilder: (context, index) {
                          final ingredient = commonIngredients[index];
                          final isSelected = pantryItems.contains(ingredient);

                          return GestureDetector(
                            onLongPress: () =>
                                _editCommonIngredient(ingredient),
                            child: SizedBox(
                              width: double.infinity,
                              height: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isSelected
                                      ? const Color(0xFF5EAAA8)
                                      : const Color(0xFFB8D4E3),
                                  foregroundColor: const Color(0xFF1E3D36),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.all(8),
                                ),
                                onPressed: () =>
                                    _toggleCommonIngredient(ingredient),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      isSelected
                                          ? Icons.check_circle
                                          : Icons.circle_outlined,
                                      size: 16,
                                      color: isSelected
                                          ? Colors.white
                                          : const Color(0xFF1E3D36),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        ingredient,
                                        style: TextStyle(
                                          fontFamily: 'NunitoSans',
                                          fontSize: 11,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.w600,
                                          color: isSelected
                                              ? Colors.white
                                              : const Color(0xFF1E3D36),
                                        ),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 32),

                      // Your Pantry section
                      Row(
                        children: [
                          const Text(
                            'Your Pantry',
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
                              color: const Color(0xFF5EAAA8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${pantryItems.length} items',
                              style: const TextStyle(
                                fontFamily: 'NunitoSans',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Pantry items grid with fixed height
                      Container(
                        height: 200, // Fixed height for scrollable area
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: pantryItems.isEmpty
                            ? const Center(
                                child: Text(
                                  'No ingredients in your pantry yet.\nSelect from above or add custom ones!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'NunitoSans',
                                    fontSize: 14,
                                    color: Color(0xFF666666),
                                  ),
                                ),
                              )
                            : GridView.builder(
                                padding: const EdgeInsets.all(12),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 8,
                                      mainAxisSpacing: 8,
                                      childAspectRatio: 2.2,
                                    ),
                                itemCount: pantryItems.length,
                                itemBuilder: (context, index) {
                                  final ingredient = pantryItems[index];
                                  return Stack(
                                    children: [
                                      SizedBox(
                                        width: double.infinity,
                                        height: double.infinity,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF5EAAA8),
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              ingredient,
                                              style: const TextStyle(
                                                fontFamily: 'NunitoSans',
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Remove button for pantry items
                                      Positioned(
                                        top: -2,
                                        right: -2,
                                        child: GestureDetector(
                                          onTap: () =>
                                              _removeIngredient(ingredient),
                                          child: Container(
                                            width: 18,
                                            height: 18,
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                              size: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 32),

                      // Action buttons
                      Row(
                        children: [
                          // Search Recipe button - UPDATED to use the new method
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF9BCF53),
                                foregroundColor: const Color(0xFF1E3D36),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              onPressed: _searchRecipes, // Updated method
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.search, size: 20),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Search Recipe',
                                    style: TextStyle(
                                      fontFamily: 'NunitoSans',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),
                          // Cancel button
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[400],
                                foregroundColor: const Color(0xFF1E3D36),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(
                                  fontFamily: 'NunitoSans',
                                  fontSize: 18,
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
