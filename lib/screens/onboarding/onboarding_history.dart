import 'package:flutter/material.dart';

class OnboardingHistoryScreen extends StatefulWidget {
  const OnboardingHistoryScreen({super.key});

  @override
  State<OnboardingHistoryScreen> createState() => _OnboardingHistoryScreenState();
}

class _OnboardingHistoryScreenState extends State<OnboardingHistoryScreen> {
  List<String> mobilityOptions = [
    'Yes',
    'No',
  ];

  String? hasMobility;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFF176B87),
      ),
      backgroundColor: const Color(0xFF176B87),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: 10.0,
            horizontal: MediaQuery.of(context).size.width * 0.125,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 20.0),
                child: const Image(
                  image: AssetImage('assets/images/BMI002.png'),
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
              Container(
                width: 300.0,
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton(
                    hint: const Text('Select / Enter Information'),
                    value: hasMobility,
                    borderRadius: BorderRadius.circular(10.0),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                    ),
                    icon: const Icon(Icons.arrow_drop_down_sharp),
                    iconEnabledColor: Colors.black,
                    items: mobilityOptions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        hasMobility = value!;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 40.0),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/onboarding/mobility');
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D1282),
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
