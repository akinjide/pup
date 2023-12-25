import 'package:flutter/material.dart';
import 'package:pup/screens/widgets/loader.dart';

import 'package:pup/services/account.dart';
import 'package:pup/services/authenticate.dart';

import '../../services/notification.dart';
import '../widgets/snackbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AccountService accountService = AccountService();
  AuthenticateService authenticateService = AuthenticateService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF176B87),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFF176B87),
        foregroundColor: const Color(0xFFFFFFFF),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FutureBuilder<User?>(
                    future: accountService.authUser(),
                    builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                      if (snapshot.hasData) {
                        User? user = snapshot.data;
                        String title = 'Welcome';

                        if (user != null && user!.fullName.isNotEmpty) {
                          title = user.fullName;
                        }

                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Image(
                                image: AssetImage('assets/images/User001.png'),
                                fit: BoxFit.cover,
                                height: 120.0,
                              ),
                              const SizedBox(height: 20.0),
                              Text(title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return const Loader();
                    },
                  ),
                  const SizedBox(height: 40.0),
                  GestureDetector(
                    onTap: () {
                      SnackBarNotification.navigatorKey.currentState?.pushReplacementNamed('/home');
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.dashboard_rounded,
                            color: Colors.white
                        ),
                        SizedBox(width: 10.0),
                        Text('Dashboard',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  GestureDetector(
                    onTap: () {
                      SnackBarNotification.navigatorKey.currentState?.pushReplacementNamed('/settings');
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.settings_rounded,
                            color: Colors.white
                        ),
                        SizedBox(width: 10.0),
                        Text('Settings',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  GestureDetector(
                    onTap: () {
                      SnackBarNotification.navigatorKey.currentState?.pushReplacementNamed('/contact');
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.call_rounded,
                            color: Colors.white
                        ),
                        SizedBox(width: 10.0),
                        Text('Call Doctor',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  GestureDetector(
                    onTap: () async {
                      bool ok = await accountService.delete();

                      if (ok) {
                        SnackBarNotification.navigatorKey.currentState?.pushReplacementNamed('/login');
                      }
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.delete_outline_rounded,
                            color: Colors.white
                        ),
                        SizedBox(width: 10.0),
                        Text('Delete Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30.0),
                  GestureDetector(
                    onTap: () async {
                      NotificationService.cancelSchedule();
                      bool ok = await authenticateService.logout();

                      if (ok) {
                        SnackBarNotification.navigatorKey.currentState?.pushReplacementNamed('/login');
                      }
                    },
                    child: const Row(
                      children: [
                        Icon(Icons.logout_rounded,
                            color: Colors.white
                        ),
                        SizedBox(width: 10.0),
                        Text('Log out',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
        ),
      ),
    );
  }
}
