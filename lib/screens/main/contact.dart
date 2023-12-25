import 'package:flutter/material.dart';

import '../../services/account.dart';
import '../widgets/input.dart';
import '../widgets/loader.dart';
import '../widgets/snackbar.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  AccountService accountService = AccountService();
  String fullName = '';
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
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF176B87),
        foregroundColor: const Color(0xFFFFFFFF),
        title: const Text('Contact Doctor', style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 10.0,
            ),
            child: Column(
              children: [
                FutureBuilder<List<Doctor>>(
                  future: accountService.getDoctors(),
                  builder: (BuildContext context, AsyncSnapshot<List<Doctor>> snapshot) {
                    if (snapshot.hasData) {
                      List<Doctor> doctors = snapshot.requireData;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(doctors.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                SnackBarNotification.notify('Call ${doctors[index].phoneNumber}');
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(doctors[index].fullName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    height: 40.0,
                                    width: 80.0,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF0D1282),
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    child: const Icon(Icons.call_rounded,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }

                    return const Loader();
                  },
                ),
                const SizedBox(height: 10.0),
                const Divider(
                  thickness: 2.0,
                  color: Colors.white,
                ),
                const SizedBox(height: 30.0),
                Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Doctor\'s Name',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        InputField(
                          onChanged: (String value) {
                            setState(() {
                              fullName = value;
                            });
                          },
                          keyboardType: TextInputType.name,
                          hintText: 'Enter Doctor\'s Name',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Doctor\'s Phone Number',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        InputField(
                          onChanged: (String value) {
                            setState(() {
                              phone = value;
                            });
                          },
                          keyboardType: TextInputType.phone,
                          hintText: 'Enter Doctor\'s Phone Number',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Center(
                      child: OutlinedButton(
                        onPressed: () async {
                          String? userId = await AccountService.activeId();

                          if (userId == null) {
                            return SnackBarNotification.notify('An error occurred. Try again.');
                          }

                          if (fullName.isEmpty || phone.isEmpty) {
                            return SnackBarNotification.notify('All fields required');
                          }

                          setState(() { loading = true; });
                          bool done = await accountService.addDoctor(Doctor(
                            doctorID: '',
                            fullName: fullName,
                            phoneNumber: phone,
                          ), userId);

                          setState(() {  loading = false; });

                          if (!done) {
                            return SnackBarNotification.notify('An error occurred. Try again.');
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
