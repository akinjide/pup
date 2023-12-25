import 'package:flutter/material.dart';

import 'package:pup/services/account.dart';
import 'package:pup/utils/utils.dart';
import 'package:pup/screens/widgets/dropdown.dart';
import 'package:pup/screens/widgets/input.dart';
import 'package:pup/screens/widgets/loader.dart';
import 'package:pup/screens/widgets/snackbar.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  AccountService accountService = AccountService();
  String heightValue = '';
  String weightValue = '';
  String heightUnit = '';
  String weightUnit = '';
  String fullName = '';
  String birthYear = '';
  String phone = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        backgroundColor: Color(0xFF176B87),
        body: SafeArea(
          child: Loader(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF176B87),
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFF176B87),
        foregroundColor: const Color(0xFFFFFFFF),
        title: const Text('Settings', style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 30.0
              ),
              child: FutureBuilder<User?>(
                future: accountService.authUser(),
                builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                  if (snapshot.hasData) {
                    User? user = snapshot.data;

                    if (user != null) {
                      weightUnit = weightUnit.isNotEmpty ? weightUnit : user.weightUnit;
                      heightUnit = heightUnit.isNotEmpty ? heightUnit : user.heightUnit;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Full name',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              InputField(
                                initialValue: user.fullName,
                                onChanged: (String value) {
                                  setState(() { fullName = value; });
                                },
                                keyboardType: TextInputType.text,
                                hintText: 'Full name',
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Height',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.65,
                                    child: InputField(
                                      initialValue: user.height,
                                      onChanged: (value) {
                                        setState(() { heightValue = value; });
                                      },
                                      keyboardType: TextInputType.number,
                                      hintText: 'Height',
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
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Weight',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              Row(
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width * 0.65,
                                    child: InputField(
                                      initialValue: user.weight,
                                      onChanged: (value) {
                                        setState(() { weightValue = value; });
                                      },
                                      keyboardType: TextInputType.number,
                                      hintText: 'Weight',
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
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Phone Number',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              InputField(
                                initialValue: user.phoneNumber,
                                onChanged: (String value) {
                                  setState(() { phone = value; });
                                },
                                keyboardType: TextInputType.phone,
                                hintText: 'Phone Number',
                              ),
                            ],
                          ),
                          const SizedBox(height: 20.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Birth Year',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 6.0),
                              InputField(
                                maxLength: 4,
                                onChanged: (String value) {
                                  setState(() { birthYear = value; });
                                },
                                keyboardType: TextInputType.text,
                                initialValue: user.birthYear,
                                hintText: 'Birth Year',
                              ),
                            ],
                          ),
                          const SizedBox(height: 40.0),
                          Center(
                            child: OutlinedButton(
                              onPressed: () async {
                                setState(() { loading = true; });
                                heightValue = heightValue.isNotEmpty ? heightValue : user.height;
                                weightValue = weightValue.isNotEmpty ? weightValue : user.weight;
                                fullName = fullName.isNotEmpty ? fullName : user.fullName;
                                birthYear = birthYear.isNotEmpty ? birthYear : user.birthYear;
                                phone = phone.isNotEmpty ? phone : user.phoneNumber;

                                double bmi = AccountService.calculateBMI(
                                  heightValue,
                                  weightValue,
                                  heightUnit,
                                  weightUnit,
                                );

                                if (bmi == -1) {
                                  setState(() { loading = false; });
                                  return SnackBarNotification.notify('Invalid weight and height');
                                }

                                bool updateOk = await accountService.update(user.userID, <String, dynamic>{
                                  'height': heightValue,
                                  'height_unit': heightUnit,
                                  'weight': weightValue,
                                  'weight_unit': weightUnit,
                                  'bmi': bmi,
                                  'full_name': fullName,
                                  'phone_number': phone,
                                  'birth_year': birthYear,
                                  'is_new': false,
                                });
                                setState(() { loading = false; });

                                if (!updateOk) {
                                  return SnackBarNotification.notify('Error updating account. Try again.');
                                }
                              },
                              style: OutlinedButton.styleFrom(
                                backgroundColor: const Color(0xFF0D1282),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Save'),
                            ),
                          ),
                        ],
                      );
                    }

                    return const Center(
                      child: Text('An error occurred. Try again.'),
                    );
                  }

                  return const Loader();
                },
              ),
            )
        ),
      ),
    );
  }
}
