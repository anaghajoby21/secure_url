// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Import your pages (adjust paths if necessary)
import 'package:secure_url/views/home.dart';
import 'package:secure_url/views/login.dart';
import 'package:secure_url/views/feedback.dart';
import 'package:secure_url/views/chatbot.dart';
import 'package:secure_url/views/shorten.dart';
import 'package:secure_url/views/learn.dart';
import 'package:secure_url/views/quiz.dart';


// Provider
import 'package:secure_url/provider/scanner_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ScannerProvider(),
      child: const SecureUrlApp(),
    ),
  );
}

class SecureUrlApp extends StatelessWidget {
  const SecureUrlApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SecureURL',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF071426),
        snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
      ),

      // keep login as the initial route
      initialRoute: '/login',

      // ROUTES — '/' and '/home' both point to the real dashboard (SecureUrlHomePage)
      routes: {
        '/': (ctx) => const SecureUrlHomePage(),        // root = Home / Dashboard
        '/login': (ctx) => const LoginPage(),
        '/home': (ctx) => const SecureUrlHomePage(),    // alias for home
        '/register': (ctx) => const RegisterPage(),     // ensure RegisterPage defined in views/register.dart
        '/reset': (ctx) => const ResetPasswordPage(),   // ensure ResetPasswordPage defined in views/reset.dart
        '/shorten': (ctx) => const ShortenPage(),
        '/learn': (ctx) => const LearnPage(),
        '/quiz': (ctx) => const QuizPage(),
        '/chat': (ctx) => const SecureUrlChatPage(),
        '/feedback': (ctx) => const SecureUrlFeedbackPage(),
      },

      // defensive fallback — avoids crash if a route hasn't been registered
      onGenerateRoute: (settings) {
        // If route is undefined, show a placeholder page instead of crashing
        return MaterialPageRoute(
          builder: (ctx) => Scaffold(
            appBar: AppBar(title: Text('Missing page: ${settings.name}')),
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('No page found for ${settings.name}.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.pushReplacementNamed(ctx, '/'),
                    child: const Text('Go Home'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
