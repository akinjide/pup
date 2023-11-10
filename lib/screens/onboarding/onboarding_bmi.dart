import 'package:flutter/material.dart';

class OnboardingBMIScreen extends StatefulWidget {
  const OnboardingBMIScreen({super.key});

  @override
  State<OnboardingBMIScreen> createState() => _OnboardingBMIScreenState();
}

class _OnboardingBMIScreenState extends State<OnboardingBMIScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                'Enter your measurements for BMI calculation',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26.0,
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
                  hintText: 'Select Gender',
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
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  print(value);
                },
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  height: 1.0,
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter height',
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
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  print(value);
                },
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14.0,
                  height: 1.0,
                ),
                decoration: const InputDecoration(
                  hintText: 'Enter weight',
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
                  Navigator.pushNamed(context, '/onboarding/mobility');
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
