import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pup/screens/widgets/input.dart';
import 'package:pup/services/account.dart';
import 'package:pup/services/image.dart';
import 'package:pup/services/record.dart';

import '../widgets/indicator.dart';

List<String> bodyParts = [
  'Butt',
  'Tailbone',
  'Heels',
  'Ankles',
  'Hips',
  'Back',
  'Elbows',
  'Shoulder Blades',
  'Back of the head',
];

List<String> stages = [
  'Stage 1',
  'Stage 2',
  'Stage 3',
  'Stage 4',
];

class OnboardingMobilityScreen extends StatefulWidget {
  const OnboardingMobilityScreen({super.key});

  @override
  State<OnboardingMobilityScreen> createState() => _OnboardingMobilityScreenState();
}

class _OnboardingMobilityScreenState extends State<OnboardingMobilityScreen> {
  final _formKey = GlobalKey();
  XFile? image;
  String? bodyPart;
  final List<Record> _medicalRecords = [
    Record(addedAt: DateTime.now(), bodyPart: bodyParts.first, severity: stages.first),
  ];
  ImageService imageService = ImageService();
  RecordService recordService = RecordService();
  final ImagePicker _picker = ImagePicker();

  /// last textfield will have an add button, tapping which will add a new textfield below
  /// and all other textfields will have a remove button, tapping which will remove the textfield at the index
  Widget _textfieldBtn(int index) {
    bool isLast = index == _medicalRecords.length - 1;

    return InkWell(
      onTap: () {
        setState(() {
          if (isLast) {
            _medicalRecords.add(Record(addedAt: DateTime.now(), bodyPart: bodyParts.first, severity: stages.first));
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
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: const Color(0xFF176B87),
        foregroundColor: Colors.black,
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
                      Stack(
                        children: [
                          const Text(
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
                            child: IconButton(onPressed: () async {
                              return showDialog<void>(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: const Text('Stages information'),
                                    content: const SingleChildScrollView(
                                      child: ListBody(
                                        children: [
                                          Text('Pressure ulcers are also known as bedsores and decubitus ulcers. They range from closed to open wounds and are classified into a series of four stages based on how deep the wound is:'),
                                          SizedBox(height: 14.0),
                                          Text('Stage 1 ulcers have not yet broken through the skin.'),
                                          SizedBox(height: 10.0),
                                          Text('Stage 2 ulcers have a break in the top two layers of skin.'),
                                          SizedBox(height: 10.0),
                                          Text('Stage 3 ulcers affect the top two layers of skin, as well as fatty tissue.'),
                                          SizedBox(height: 10.0),
                                          Text('Stage 4 ulcers are deep wounds that may impact muscle, tendons, ligaments, and bone.'),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        child: const Text('Close'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                              icon: const Icon(Icons.info_rounded,
                                color: Colors.yellow,
                                size: 32.0,
                              ),
                            ),
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

                                    String? imageURL = await imageService.upload(image, 'records/$userId/${image?.name}');

                                    setState(() {
                                      _medicalRecords[index].picture = imageURL!;
                                    });
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
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      hint: const Text('Select Body Part affected',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      value: _medicalRecords[index].bodyPart,
                                      icon: const Icon(Icons.arrow_drop_down_sharp),
                                      iconEnabledColor: Colors.black,
                                      borderRadius: BorderRadius.circular(10.0),
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                      ),
                                      items: bodyParts.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? value) {
                                        setState(() { _medicalRecords[index].bodyPart = value!; });
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: 10.0),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      hint: const Text('Select Stage',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      value: _medicalRecords[index].severity,
                                      icon: const Icon(Icons.arrow_drop_down_sharp),
                                      iconEnabledColor: Colors.black,
                                      borderRadius: BorderRadius.circular(10.0),
                                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 16.0,
                                      ),
                                      items: stages.map<DropdownMenuItem<String>>((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      onChanged: (String? value) {
                                        setState(() { _medicalRecords[index].severity = value!; });
                                      },
                                    ),
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
                          bool done = await recordService.create(_medicalRecords, userId!);

                          if (done) {
                            Navigator.pushNamed(context, '/onboarding/complete');
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

            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 1.0,
              ),
            );
          },
        ),
      ),
    );
  }
}
