import 'package:flutter/material.dart';
import 'package:pup/services/account.dart';

class OnboardingCompleteScreen extends StatefulWidget {
  const OnboardingCompleteScreen({super.key});

  @override
  State<OnboardingCompleteScreen> createState() => _OnboardingCompleteScreenState();
}

class _OnboardingCompleteScreenState extends State<OnboardingCompleteScreen> {
  AccountService accountService = AccountService();

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 5), () async {
      Navigator.pushNamed(context, '/home');
    });

    return Scaffold(
      backgroundColor: const Color(0xFF176B87),
      body: SafeArea(
        child: FutureBuilder<User?>(
          future: accountService.authUser(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.hasData) {
              User? user = snapshot.data;
              String title = 'All set';

              if (user != null && user!.fullName.isNotEmpty) {
                title = '$title, ${user.fullName.split(' ')[0]}';
              }

              return SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: 0.0,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 100.0),
                        child: const Image(
                          image: AssetImage('assets/images/Logo001.png'),
                          fit: BoxFit.cover,
                          height: 100.0,
                        ),
                      ),
                      Text(title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 50.0),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10.0),
                        child: const Image(
                          image: AssetImage('assets/images/BMI003.png'),
                          fit: BoxFit.cover,
                          height: 300.0,
                        ),
                      ),
                    ],
                  ),
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
      ),
    );
  }
}
