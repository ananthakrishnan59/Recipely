import 'package:flutter/material.dart';

class Aboutuspage extends StatelessWidget {
  const Aboutuspage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:  const Color(0xFF1EDEC7),
        title: const Text('AboutUS'),
      ),
      // ignore: prefer_const_constructors
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Recipely',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
             "Welcome to Recipely, where the joy of cooking meets the convenience of technology! We understand that cooking is not just a task; it's an art, a passion, and a delightful journey. Our application is designed to make your culinary experience enjoyable, efficient, and personalized."
            ),

            // Information Collection and Use
            SizedBox(height: 16.0),
            Text(
              'Our Mission',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'At Recipely, our mission is to inspire and simplify the cooking process for everyone, from seasoned chefs to kitchen novices. We believe that a good meal is more than just a combination of ingredients – its a story, a creation, and a shared experience. With our diverse range of recipes and user-friendly features, we aim to bring people together through the joy of cooking.',
            ),

            // Log Data
            SizedBox(height: 16.0),
            Text(
              'Key Features',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Recipe Variety: Explore a vast collection of recipes across various categories, ensuring theres something for every taste and occasion.Time-Based Sorting: Need a quick meal or planning a leisurely feast? Sort recipes based on cooking time to find the perfect dish for your schedule.Favourite Button: Save your most loved recipes with a simple tap on the "Favourite" button. Build your personal cookbook and easily access your go-to recipes.Detailed Recipe Pages: Dive into the details with our comprehensive recipe pages. Each recipe includes a description, list of ingredients, step-by-step procedure, and more.User Reviews: Share your thoughts and experiences by adding reviews to your favorite recipes. Connect with the community, exchange tips, and discover new ways to enhance your culinary creations.',
            ),

            // Cookies
            SizedBox(height: 16.0),
            Text(
              'Why Choose Recipely App',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'User-Friendly Interface: Our intuitive design ensures a seamless and enjoyable browsing experience.Personalization: Tailor your cooking journey with features like favorites and personalized recommendations.Quality Content: Our recipes are curated and tested to ensure they meet the highest standards of taste and simplicity.Community Engagement: Join a thriving community of food enthusiasts. Share, learn, and connect with fellow users who share your passion for cooking.Thank you for choosing [Your App Name] as your culinary companion. Get ready to embark on a delicious adventure in the world of cooking!Happy Cooking!',
            ),

            // Service Providers
            SizedBox(height: 16.0),
            
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: Aboutuspage(),
    ),
  );
}