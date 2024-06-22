import 'package:flutter/material.dart';
import 'package:news_app/screens/categories_screen.dart';
import 'package:news_app/screens/home_screen.dart';
import 'package:news_app/screens/news_details_screen.dart';
import 'package:news_app/screens/splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      routes: {
        '/homeScreen': (context) => const HomeScreen(),
        '/categoriesScreen': (context) => const CategoriesScreen(),
      },
    );
  }
}
