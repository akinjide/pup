import 'package:flutter/material.dart';

import 'package:pup/services/record.dart';
import 'package:pup/screens/widgets/loader.dart';

import '../widgets/snackbar.dart';

class LogsScreen extends StatefulWidget {
  const LogsScreen({super.key});

  @override
  State<LogsScreen> createState() => _LogsScreenState();
}

class _LogsScreenState extends State<LogsScreen> {
  RecordService recordService = RecordService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF176B87),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF176B87),
        foregroundColor: const Color(0xFFFFFFFF),
        title: const Text('Recent Logs', style: TextStyle(
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<List<Record>>(
                  future: recordService.list(),
                  builder: (BuildContext context, AsyncSnapshot<List<Record>> snapshot) {
                    if (snapshot.hasData) {
                      List<Record> record = snapshot.requireData;

                      return GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        children: List.generate(snapshot.requireData.length, (index) {
                          return Container(
                            margin: const EdgeInsets.all(5.0),
                            padding: const EdgeInsets.all(5.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                record[index].picture.isNotEmpty
                                    ? Container(
                                      width: double.infinity,
                                      height: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: Image.network(record[index].picture,
                                        fit: BoxFit.cover,
                                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgres) {
                                          if (loadingProgres == null) return child;

                                          return Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.black,
                                              strokeWidth: 2.0,
                                              value: loadingProgres?.expectedTotalBytes != null
                                                ? loadingProgres!.cumulativeBytesLoaded / loadingProgres!.expectedTotalBytes!
                                                : null,
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                    : const Center(child: Icon(Icons.broken_image_outlined, size: 100.0)),
                                Container(
                                  color: Colors.white,
                                  height: 70.0,
                                  width: double.infinity,
                                  child: Column(
                                    children: [
                                      Text('${record[index].bodyPart} - ${record[index].severity}'),
                                      const SizedBox(height: 2.0),
                                      Builder(builder: (BuildContext context) {
                                        List<String> addedAt = record[index].addedAt.toIso8601String().split("T");
                                        String date = addedAt[0];
                                        String time = addedAt[1].split('.')[0];

                                        return Text('$date ($time)');
                                      }),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      );
                    }

                    return const Loader();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF0D1282),
        label: const Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 4.0),
              child: Icon(Icons.add_rounded, color: Colors.white),
            ),
            Text('Add Logs', style: TextStyle(
                color: Colors.white,
              ),
            ),
          ],
        ),
        onPressed: () async {
          SnackBarNotification.navigatorKey.currentState?.pushNamed('/logs/add');
        },
      ),
    );
  }
}
