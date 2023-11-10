import 'package:flutter/material.dart';

class OnboardingMobilityScreen extends StatefulWidget {
  const OnboardingMobilityScreen({super.key});

  @override
  State<OnboardingMobilityScreen> createState() => _OnboardingMobilityScreenState();
}

class _OnboardingMobilityScreenState extends State<OnboardingMobilityScreen> {
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
            children: [
              const Text(
                'Add Current Pressure Ulcer information. Skip if none',
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
                  hintText: 'Open Camera',
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
              const SizedBox(height: 10.0),
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
                  hintText: 'Select Body Part affected',
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
              const SizedBox(height: 10.0),
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
                  hintText: 'Select Stage',
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
              const SizedBox(height: 20.0),
              Container(
                child: const Icon(
                  Icons.add_circle_rounded,
                  size: 32.0,
                ),
              ),
              const SizedBox(height: 40.0),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/onboarding/history');
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
