import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:my_notes/constants/colors.dart';
import 'package:my_notes/screens/auth_screen.dart';
import 'package:my_notes/screens/home_screen.dart';
import 'package:my_notes/services/firebase.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: mainColor,
        ),
        useMaterial3: true,
      ),
      home: StreamBuilder(
          stream: FirebaseService.instance.authInstance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const Home();
            }
            return const AuthScreen();
          }),
      // home: const Home(),
      routes: {
        Home.routeName: (context) => const Home(),
        AuthScreen.routeName: (context) => const AuthScreen(),
      },
    );
  }
}
