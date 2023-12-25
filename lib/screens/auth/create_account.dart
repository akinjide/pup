import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:pup/screens/widgets/snackbar.dart';

import '../../services/account.dart';
import '../../services/authenticate.dart';
import '../widgets/input.dart';
import '../widgets/loader.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  String fullName = '';
  String birthYear = '';
  String phone = '';
  String pin = '';
  String confirmPin = '';
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
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: MediaQuery.of(context).size.width * 0.125,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Image(
                  image: AssetImage('assets/images/Logo001.png'),
                  fit: BoxFit.cover,
                  height: 100.0,
                ),
                const Image(
                  image: AssetImage('assets/images/CreateAccount001.png'),
                  fit: BoxFit.cover,
                  height: 150.0,
                ),
                InputField(
                  onChanged: (String value) {
                    setState(() { fullName = value; });
                  },
                  keyboardType: TextInputType.text,
                  hintText: 'Full name',
                ),
                const SizedBox(height: 10.0),
                InputField(
                  onChanged: (String value) {
                    setState(() { phone = value; });
                  },
                  keyboardType: TextInputType.phone,
                  hintText: 'Phone number',
                ),
                const SizedBox(height: 10.0),
                InputField(
                  maxLength: 4,
                  onChanged: (String value) {
                    setState(() { birthYear = value; });
                  },
                  keyboardType: TextInputType.number,
                  hintText: 'Birth year',
                ),
                const SizedBox(height: 10.0),
                InputField(
                  maxLength: 6,
                  obscureText: true,
                  onChanged: (String value) {
                    setState(() { pin = value; });
                  },
                  keyboardType: TextInputType.number,
                  hintText: 'Create PIN',
                ),
                const SizedBox(height: 10.0),
                InputField(
                  maxLength: 6,
                  obscureText: true,
                  onChanged: (String value) {
                    setState(() { confirmPin = value; });
                  },
                  keyboardType: TextInputType.number,
                  hintText: 'Confirm PIN',
                ),
                const SizedBox(height: 20.0),
                OutlinedButton(
                  onPressed: () async {
                    if (fullName.isEmpty || birthYear.isEmpty || phone.isEmpty || pin.isEmpty) {
                      return SnackBarNotification.notify('All fields required');
                    }

                    if (birthYear.length > 4 || birthYear.length < 4) {
                      return SnackBarNotification.notify('Birth Year must be between 1900 and 2023');
                    }

                    if (pin.length < 4) {
                      return SnackBarNotification.notify('Pin must be between 4 and 6');
                    }

                    if (pin != confirmPin) {
                      return SnackBarNotification.notify('Pin does not match');
                    }

                    setState(() { loading = true;  });
                    AuthenticateService authService = AuthenticateService();
                    Digest encryptedPin = authService.encrypt(pin);
                    bool exist = await authService.create(User(
                      userID: '',
                      fullName: fullName,
                      birthYear: birthYear,
                      phoneNumber: phone,
                      pin: encryptedPin.toString(),
                      isNew: true,
                    ));

                    setState(() {  loading = false; });

                    if (!exist) {
                      return SnackBarNotification.notify('User with phone already exist.');
                    }

                    SnackBarNotification.navigatorKey.currentState?.pushReplacementNamed('/login');
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Color(0xFF0D1282),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Create Account'),
                ),
                const SizedBox(height: 10.0),
                const Text('OR',
                  style: TextStyle(
                    color: Color(0xFF91C8E4),
                  ),
                ),
                const SizedBox(height: 10.0),
                OutlinedButton(
                  onPressed: () {
                    SnackBarNotification.navigatorKey.currentState?.pushReplacementNamed('/login');
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFF749BC2),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
