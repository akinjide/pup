import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

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
                maxLength: 4,
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
              const SizedBox(height: 40.0),
              OutlinedButton(
                onPressed: () async {
                  setState(() {
                    loading = true;
                  });

                  AuthenticateService authService = AuthenticateService();
                  Digest encryptedPin = authService.encrypt(pin);
                  bool exist = await authService.create(fullName, birthYear, phone, encryptedPin.toString());

                  if (!exist) {
                    const snackBar = SnackBar(
                      content: Text('user exist'),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }

                  setState(() {
                    loading = false;
                  });
                  // fsb.create(phone, pin);
                  //
                  // fsb.database.ref().onValue.listen((DatabaseEvent event) {
                  //   print(event);
                  // });

                  // print(await fsb.find("users/12"));
                  // Navigator.pushNamed(context, '/onboarding');
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Color(0xFF0D1282),
                  foregroundColor: Colors.white,
                ),
                child: const Text('Create Account'),
              ),
              const SizedBox(height: 20.0),
              const Text('OR'),
              const SizedBox(height: 20.0),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                ),
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
