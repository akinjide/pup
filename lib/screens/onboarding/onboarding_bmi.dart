import 'package:flutter/material.dart';
import 'package:pup/services/account.dart';

import '../widgets/snackbar.dart';

List<String> genderOptions = [
  'Male',
  'Female',
];

List<String> heightOptions = [
  'm',
  'in',
];
List<String> weightOptions = [
  'kg',
  'lbs',
];

class OnboardingBMIScreen extends StatefulWidget {
  const OnboardingBMIScreen({super.key});

  @override
  State<OnboardingBMIScreen> createState() => _OnboardingBMIScreenState();
}

class _OnboardingBMIScreenState extends State<OnboardingBMIScreen> {
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
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton(
                      hint: const Text('Select Gender'),
                      value: genderValue,
                      borderRadius: BorderRadius.circular(10.0),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                      icon: const Icon(Icons.arrow_drop_down_sharp),
                      iconEnabledColor: Colors.black,
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
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.52,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() { heightValue = value; });
                        },
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          height: 1.0,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Enter height',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(50.0),
                              right: Radius.circular(50.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: heightUnit,
                          icon: const Icon(Icons.arrow_drop_down_sharp),
                          iconEnabledColor: Colors.black,
                          borderRadius: BorderRadius.circular(10.0),
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
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
                    ),
                  ],
                ),
                const SizedBox(height: 10.0),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.52,
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() { weightValue = value; });
                        },
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 14.0,
                          height: 1.0,
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Enter weight',
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(50.0),
                              right: Radius.circular(50.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          value: weightUnit,
                          icon: const Icon(Icons.arrow_drop_down_sharp),
                          iconEnabledColor: Colors.black,
                          borderRadius: BorderRadius.circular(10.0),
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                          ),
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
                    ),
                  ],
                ),
                const SizedBox(height: 40.0),
                OutlinedButton(
                  onPressed: () async {
                    AccountService accountService = AccountService();
                    // should use logged in user ID
                    String? userId = await accountService.activeId();

                    double bmi = 0;
                    double height = double.parse(heightValue!);
                    double weight = double.parse(weightValue!);

                    if (height == 0 || weight == 0) {
                      return SnackBarNotification.notify('Invalid weight and height');
                    }

                    // Imperial Unit
                    if (heightUnit == 'in' && weightUnit == 'lbs') {
                      bmi = (weight / (height * height)) * 703;
                      // Metric Unit
                    } else if (heightUnit == 'm' && weightUnit == 'kg') {
                      bmi = weight / (height * height);
                    } else {
                      return SnackBarNotification.notify('Invalid weight and height unit');
                    }

                    print(<String, dynamic>{
                      "gender": genderValue,
                      "height": heightValue,
                      "height_unit": heightUnit,
                      "weight": weightValue,
                      "weight_unit": weightUnit,
                      "bmi": bmi,
                    });

                    bool updateOk = await accountService.update(userId, <String, dynamic>{
                      "gender": genderValue,
                      "height": heightValue,
                      "height_unit": heightUnit,
                      "weight": weightValue,
                      "weight_unit": weightUnit,
                      "bmi": bmi,
                    });

                    if (!updateOk) {
                      return SnackBarNotification.notify('Error calculating BMI. Try again.');
                    }

                    Navigator.pushNamed(context, '/onboarding/history');
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
