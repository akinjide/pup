import 'package:flutter/material.dart';

class OnboardingHistoryScreen extends StatefulWidget {
  const OnboardingHistoryScreen({super.key});

  @override
  State<OnboardingHistoryScreen> createState() => _OnboardingHistoryScreenState();
}

class _OnboardingHistoryScreenState extends State<OnboardingHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFF4CAAEE),
        foregroundColor: Colors.black,
      ),
      backgroundColor: const Color(0xFF4CAAEE),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: MediaQuery.of(context).size.width * 0.125),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: const Image(
                  image: AssetImage('assets/images/Login001.png'),
                  fit: BoxFit.cover,
                  height: 150.0,
                ),
              ),
              const Text(
                'Do you have any specific mobility challenges or difficult we should be aware of? if "Yes" enter details or "No", you can skip this page.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20.0),
              TextFormField(
                keyboardType: TextInputType.text,
                onChanged: (value) {
                  print(value);
                },
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  height: 1.0,
                ),
                decoration: const InputDecoration(
                  hintText: 'Select Option',
                  filled: true,
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(50.0),
                      right: Radius.circular(50.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/onboarding/complete');
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Next'),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}
