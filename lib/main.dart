import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:pup/screens/logs/add_log.dart';
import 'package:pup/screens/main/contact.dart';
import 'package:pup/screens/logs/logs.dart';
import 'package:pup/screens/main/home.dart';
import 'package:pup/screens/main/notifications.dart';
import 'package:pup/screens/main/profile.dart';
import 'package:pup/screens/main/settings.dart';
import 'package:pup/screens/widgets/snackbar.dart';
import 'package:pup/services/account.dart';
import 'package:pup/screens/auth/create_account.dart';
import 'package:pup/screens/auth/login.dart';
import 'package:pup/screens/onboarding/onboarding_bmi.dart';
import 'package:pup/screens/onboarding/onboarding_complete.dart';
import 'package:pup/screens/onboarding/onboarding_history.dart';
import 'package:pup/screens/onboarding/onboarding_mobility.dart';
import 'package:pup/services/notification.dart';
import 'firebase_options.dart';

Future main() async {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    AndroidInitializationSettings initializationSettingsAndroid = const AndroidInitializationSettings('app_icon');
    DarwinInitializationSettings initializationSettingsIOS = const DarwinInitializationSettings();
    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: null,
    );

    await NotificationService.flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: NotificationService.onDidReceiveNotificationResponse,
      onDidReceiveNotificationResponse: NotificationService.onDidReceiveNotificationResponse,
    );
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
      navigatorKey: SnackBarNotification.navigatorKey,
      title: 'Bloom',
      theme: ThemeData(
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
        '/logs/add': (context) => const AddLogScreen(),
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
