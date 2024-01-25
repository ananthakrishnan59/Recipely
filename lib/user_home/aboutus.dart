import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  const Color(0xFF1EDEC7),
        title: const Text('About Us'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'About Us',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Welcome to Recipely, your go-to destination for delicious and diverse recipes!',
            ),
            const SizedBox(height: 16.0),
            const Text(
              'At Recipely, we believe that cooking is an art, and everyone can be a chef in their own kitchen. Our mission is to make cooking enjoyable, accessible, and rewarding for users of all skill levels.',
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Key Features:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            _buildFeature('Explore Recipes', 'Discover a wide variety of recipes for every taste and occasion.'),
            _buildFeature('Sort and Search', 'Effortlessly find recipes based on cooking time and categories.'),
            _buildFeature('Favorites', 'Save and organize your favorite recipes for quick access.'),
            _buildFeature('Detailed Pages', 'Get comprehensive details including ingredients, procedures, and user reviews for each recipe.'),
            const SizedBox(height: 16.0),
            const Text(
              'Whether you are a seasoned chef or a beginner in the kitchen, Recipely is here to inspire you to create delightful dishes. Happy cooking!',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(description),
        const SizedBox(height: 16.0),
      ],
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: AboutUsScreen(),
    ),
  );
}

