import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pup/screens/contact.dart';
import 'package:pup/screens/home.dart';
import 'package:pup/screens/logs.dart';
import 'package:pup/screens/notifications.dart';
import 'package:pup/screens/profile.dart';
import 'package:pup/screens/settings.dart';
import 'package:pup/screens/widgets/snackbar.dart';
import 'package:pup/services/account.dart';
import 'firebase_options.dart';

import 'package:pup/screens/create_account.dart';
import 'package:pup/screens/login.dart';
import 'package:pup/screens/onboarding/onboarding_bmi.dart';
import 'package:pup/screens/onboarding/onboarding_complete.dart';
import 'package:pup/screens/onboarding/onboarding_history.dart';
import 'package:pup/screens/onboarding/onboarding_mobility.dart';

Future main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    runApp(const MyApp());
  }, (error, stack) {
    print(error);
    print(stack);
    debugPrint('CAUGHT runZonedGuarded Error');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: SnackBarNotification.rootScaffoldMessengerKey,
      title: 'Bloom',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const Home(),
        '/create_account': (context) => const CreateAccountScreen(),
        '/login': (context) => const LoginScreen(),
        '/onboarding': (context) => const OnboardingBMIScreen(),
        '/onboarding/history': (context) => const OnboardingHistoryScreen(),
        '/onboarding/mobility': (context) => const OnboardingMobilityScreen(),
        '/onboarding/complete': (context) => const OnboardingCompleteScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/logs': (context) => const LogsScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/notifications': (context) => const NotificationsScreen(),
        '/contact': (context) => const ContactScreen(),
      },
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AccountService accountService = AccountService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF176B87),
      body: FutureBuilder<bool>(
        future: accountService.isAuthenticated(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.hasData) {
            bool? authenticated = snapshot.data;

            if (authenticated != null && authenticated) {
              return const HomeScreen();
            }

            return const CreateAccountScreen();
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }

          return const Center(
            child: Image(
              image: AssetImage('assets/images/Logo001.png'),
              fit: BoxFit.cover,
              height: 100.0,
            ),
          );
        },
      ),
    );
  }
}
