import 'package:flutter/material.dart';

import 'package:pup/services/account.dart';
import 'package:pup/screens/widgets/snackbar.dart';
import 'package:pup/utils/utils.dart';
import 'package:pup/screens/widgets/input.dart';
import 'package:pup/screens/widgets/dropdown.dart';

import '../../services/notification.dart';

class OnboardingBMIScreen extends StatefulWidget {
  const OnboardingBMIScreen({super.key});

  @override
  State<OnboardingBMIScreen> createState() => _OnboardingBMIScreenState();
}

class _OnboardingBMIScreenState extends State<OnboardingBMIScreen> {
  AccountService accountService = AccountService();
  String? genderValue;
  String? heightValue;
  String heightUnit = heightOptions.first;
  String? weightValue;
  String weightUnit = weightOptions.first;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF176B87),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: MediaQuery.of(context).size.width * 0.125,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.only(bottom: 40.0),
                  child: const Image(
                    image: AssetImage('assets/images/BMI001.png'),
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
                Container(
                  width: 300.0,
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Dropdown(
                    hintText: 'Select Gender',
                    value: genderValue,
                    items: genderOptions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        genderValue = value!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.52,
                      child: InputField(
                        onChanged: (value) {
                          setState(() { heightValue = value; });
                        },
                        keyboardType: TextInputType.number,
                        hintText: 'Enter height',
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Dropdown(
                        hintText: '',
                        value: heightUnit,
                        items: heightOptions.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() { heightUnit = value!; });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.52,
                      child: InputField(
                        onChanged: (String value) {
                          setState(() { weightValue = value; });
                        },
                        keyboardType: TextInputType.number,
                        hintText: 'Enter weight',
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: Dropdown(
                        hintText: '',
                        value: weightUnit,
                        items: weightOptions.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() { weightUnit = value!; });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40.0),
                OutlinedButton(
                  onPressed: () async {
                    String? userId = await AccountService.activeId();
                    double bmi = AccountService.calculateBMI(
                      heightValue!,
                      weightValue!,
                      heightUnit,
                      weightUnit,
                    );

                    if (bmi == -1) {
                      return SnackBarNotification.notify('Invalid weight and height');
                    }

                    bool updateOk = await accountService.update(userId, <String, dynamic>{
                      'gender': genderValue,
                      'height': heightValue,
                      'height_unit': heightUnit,
                      'weight': weightValue,
                      'weight_unit': weightUnit,
                      'bmi': bmi,
                      'is_new': false,
                    });

                    if (!updateOk) {
                      return SnackBarNotification.notify('Error calculating BMI. Try again.');
                    }

                    SnackBarNotification.navigatorKey.currentState?.pushNamed('/onboarding/history');
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D1282),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Next'),
                ),
                const SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 20.0),
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                        color: const Color(0xFF749BC2),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 20.0),
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(right: 0.0),
                      width: 20.0,
                      height: 20.0,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
