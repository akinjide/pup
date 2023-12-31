import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pup/screens/widgets/input.dart';
import 'package:pup/screens/widgets/loader.dart';
import 'package:pup/services/account.dart';
import 'package:pup/services/image.dart';
import 'package:pup/services/recommendation.dart';
import 'package:pup/services/record.dart';
import 'package:pup/utils/utils.dart';

import '../widgets/help.dart';
import '../widgets/indicator.dart';
import '../widgets/dropdown.dart';
import '../widgets/snackbar.dart';

class OnboardingMobilityScreen extends StatefulWidget {
  const OnboardingMobilityScreen({super.key});

  @override
  State<OnboardingMobilityScreen> createState() => _OnboardingMobilityScreenState();
}

class _OnboardingMobilityScreenState extends State<OnboardingMobilityScreen> {
  ImageService imageService = ImageService();
  RecordService recordService = RecordService();
  AccountService accountService = AccountService();
  RecommendationService recommendationService = RecommendationService();
  final ImagePicker _picker = ImagePicker();
  XFile? image;
  String? bodyPart;
  bool uploading = false;
  final List<Record> _medicalRecords = [
    Record(addedAt: DateTime.now(), bodyPart: bodyParts.first.name, severity: stages.first.name),
  ];

  Widget _textfieldBtn(int index) {
    bool isLast = index == _medicalRecords.length - 1;

    return InkWell(
      onTap: () {
        setState(() {
          if (isLast) {
            _medicalRecords.add(Record(addedAt: DateTime.now(), bodyPart: bodyParts.first.name, severity: stages.first.name));
          } else {
            _medicalRecords.removeAt(index);
          }
        });
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: isLast ? Colors.green : Colors.red,
        ),
        child: Icon(
          isLast ? Icons.add_rounded : Icons.remove_rounded,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (uploading) {
      return const Scaffold(
        backgroundColor: Color(0xFF176B87),
        body: SafeArea(
          child: Loader(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFF176B87),
        foregroundColor: const Color(0xFFFFFFFF),
      ),
      backgroundColor: const Color(0xFF176B87),
      body: SafeArea(
        child: FutureBuilder<String?>(
          future: AccountService.activeId(),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.hasData) {
              String? userId = snapshot.data;

              return SingleChildScrollView(
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 10.0,
                    horizontal: MediaQuery.of(context).size.width * 0.125,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Stack(
                        children: [
                          Text(
                            'Add Current Pressure Ulcer information. Skip if none',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Positioned(
                            bottom: -10.0,
                            right: 0.0,
                            child: Help(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Container(
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                OutlinedButton(
                                  onPressed: () async {
                                    if (_picker.supportsImageSource(ImageSource.gallery)) {
                                      image = await _picker.pickImage(
                                        requestFullMetadata: true,
                                        source: ImageSource.gallery,
                                      );
                                    } else {
                                      image = await _picker.pickImage(
                                        requestFullMetadata: true,
                                        source: ImageSource.camera,
                                      );
                                    }

                                    if (image != null) {
                                      setState(() { uploading = true; });
                                      String? url = await recommendationService.upload(image);

                                      if (url != null && url.isNotEmpty) {
                                        bool matched = await recommendationService.analyze(image!.name);

                                        if (matched) {
                                          String? imageURL = await imageService.upload(image, 'records/$userId/${image?.name}');

                                          setState(() {
                                            uploading = false;
                                            _medicalRecords[index].picture = imageURL!;
                                          });

                                          SnackBarNotification.notify("Upload successful. Image recognized and valid.");
                                        } else {
                                          setState(() {
                                            uploading = false;
                                            _medicalRecords[index].picture = '';
                                          });

                                          SnackBarNotification.notify("Upload successful but image not recognized or invalid.");
                                        }
                                      } else {
                                        setState(() {
                                          uploading = false;
                                          _medicalRecords[index].picture = '';
                                        });

                                        SnackBarNotification.notify("Upload fail. Try again.");
                                      }
                                    }
                                  },
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFFFFF),
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 16.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.camera_alt_rounded),
                                        const SizedBox(width: 10.0),
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.5,
                                          child: Text(_medicalRecords[index].picture.isNotEmpty
                                              ? _medicalRecords[index].picture
                                              : ImagePicker().supportsImageSource(ImageSource.gallery)
                                                ? 'Open Gallery'
                                                : 'Open Camera',
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              height: 1.0,
                                            ),
                                            maxLines: 1,
                                            softWrap: false,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10.0),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: Dropdown(
                                    hintText: 'Select Body Part affected',
                                    value: _medicalRecords[index].bodyPart,
                                    items: bodyParts.map<DropdownMenuItem<String>>((BodyPart value) {
                                      return DropdownMenuItem<String>(
                                        value: value.name,
                                        child: Text(value.name),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() { _medicalRecords[index].bodyPart = value!; });
                                    },
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: Dropdown(
                                    hintText: 'Select Stage',
                                    value: _medicalRecords[index].severity,
                                    items: stages.map<DropdownMenuItem<String>>((Stage value) {
                                      return DropdownMenuItem<String>(
                                        value: value.name,
                                        child: Text(value.name),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      setState(() { _medicalRecords[index].severity = value!; });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 10),
                                _textfieldBtn(index),
                              ],
                            );
                          },
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 20.0);
                          },
                          itemCount: _medicalRecords.length,
                        ),
                      ),
                      const SizedBox(height: 40.0),
                      OutlinedButton(
                        onPressed: () async {
                          bool recordCreated = await recordService.create(_medicalRecords, userId!);

                          if (recordCreated) {
                            SnackBarNotification.navigatorKey.currentState?.pushReplacementNamed('/onboarding/complete');
                          } else {
                            SnackBarNotification.notify('Error creating records. Try again.');
                          }
                        },
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D1282),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Next'),
                      ),
                      const SizedBox(height: 20.0),
                      const Indicator(),
                    ],
                  ),
                ),
              );
            }

            return const Loader();
          },
        ),
      ),
    );
  }
}
