import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pup/screens/widgets/snackbar.dart';
import 'package:pup/services/firebase.dart';
import 'package:pup/services/image.dart';

import '../services/account.dart';
import '../services/authenticate.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String pin = '';
  String phone = '';

  @override
  Widget build(BuildContext context) {
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
                Container(
                  margin: const EdgeInsets.only(bottom: 40.0),
                  child: const Image(
                    image: AssetImage('assets/images/Logo001.png'),
                    fit: BoxFit.cover,
                    height: 100.0,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(bottom: 10.0),
                  child: const Image(
                    image: AssetImage('assets/images/Login001.png'),
                    fit: BoxFit.cover,
                    height: 150.0,
                  ),
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Welcome Back!',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0,
                      ),
                    ),
                    Text('Please Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 28.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  onChanged: (value) {
                    setState(() { phone = value; });
                  },
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    height: 1.0,
                  ),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Phone number',
                    filled: true,
                    labelStyle: TextStyle(
                    ),
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
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  onChanged: (value) {
                    setState(() { pin = value; });
                  },
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14.0,
                    height: 1.0,
                  ),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    hintText: 'Pin',
                    filled: true,
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
                    if (pin.isEmpty || phone.isEmpty) {
                      return SnackBarNotification.notify('Empty Phone or Pin');
                    }

                    AuthenticateService authService = AuthenticateService();
                    Digest encryptedPin = authService.encrypt(pin.trim());
                    User? user = await authService.login(phone, encryptedPin.toString());

                    if (user == null) {
                      return SnackBarNotification.notify('Invalid Phone or Pin');
                    }

                    if (user.isNew) {
                      Navigator.pushReplacementNamed(context, '/onboarding');
                    } else {
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D1282),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Login'),
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
                    ImageService imageService = ImageService();
                    imageService.upload();
                    // Navigator.pushReplacementNamed(context, '/create_account');
                  },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFF749BC2),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Create Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
