import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:media_library/ui/login_screen.dart';
import 'package:media_library/ui/main_library_screen.dart';
import 'package:media_library/ui/registration_screen.dart';
import 'package:media_library/ui/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: WelcomeScreen.routeID,
      routes: {
        WelcomeScreen.routeID: (context) => const WelcomeScreen(),
        LoginScreen.routeID: (context) => const LoginScreen(),
        RegistrationScreen.routeID: (context) => const RegistrationScreen(),
        MainLibraryScreen.routeID: (context) => const MainLibraryScreen(),
      },
    );
  }
}
