import 'package:_assignment_mobile/pages/home.dart';
import 'package:_assignment_mobile/pages/welcome_screen.dart';
import 'package:_assignment_mobile/pages/login_signup.dart';
import 'package:_assignment_mobile/config/env_config.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize environment variables
  try {
    await EnvConfig.initialize();
  } catch (e) {
    print('Error loading environment: $e');
  }
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      initialRoute: '/welcome',
      routes: {
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginSignupPage(),
        '/home': (context) => const MyHomePage(),
      },
    );
  }
}
  
