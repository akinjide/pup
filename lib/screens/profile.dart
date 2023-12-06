import 'package:flutter/material.dart';

import '../services/account.dart';
import '../services/authenticate.dart';
import '../services/record.dart';

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
      body: SafeArea(
        child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10.0,
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
                                height: 60.0,
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

                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 1.0,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 60.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/home');
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
                      Navigator.pushNamed(context, '/settings');
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
                      Navigator.pushNamed(context, '/contact');
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
                    onTap: () {
                      // Navigator.pushNamed(context, '/contact');
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
                      bool ok = await authenticateService.logout();

                      if (ok) {
                        Navigator.pushNamed(context, '/login');
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
