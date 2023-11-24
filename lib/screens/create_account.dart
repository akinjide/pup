import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:pup/screens/widgets/snackbar.dart';

import '../services/account.dart';
import '../services/authenticate.dart';

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
          child: Center(
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 1.0,
            ),
          ),
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
                TextFormField(
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    setState(() { fullName = value; });
                  },
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    height: 1.0,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Full name',
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
                    setState(() { phone = value; });
                  },
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    height: 1.0,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Phone number',
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
                    setState(() { birthYear = value; });
                  },
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    height: 1.0,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Birth year',
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
                  maxLength: 6,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() { pin = value; });
                  },
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    height: 1.0,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Create PIN',
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
                  maxLength: 6,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() { confirmPin = value; });
                  },
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    height: 1.0,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Confirm PIN',
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

                    Navigator.pushReplacementNamed(context, '/login');
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
                    Navigator.pushReplacementNamed(context, '/login');
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
