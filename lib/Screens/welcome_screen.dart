// screens/welcome_screen.dart
import 'package:flutter/material.dart';
import '../main.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF3E5F5), Color(0xFFE1BEE7)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                // Cute book icon
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 26.0),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.deepPurple.withValues(alpha: 26.0),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.menu_book_rounded,
                    size: 80,
                    color: Color(0xFF6A1B9A),
                  ),
                ),
                const SizedBox(height: 40),
                // Title
                const Text(
                  'Welcome to your',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFF6A1B9A),
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Book Shelf 💜',
                  style: TextStyle(
                    fontSize: 42,
                    color: Color(0xFF4A148C),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Let\'s track your books!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Color(0xFF9575CD),
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const Spacer(),
                // Start button
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainNavigation(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 20,
                    ),
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF6A1B9A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 8,
                    shadowColor: Colors.deepPurple.withValues(alpha: 26.0),
                  ),
                  child: const Text(
                    'Start',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
