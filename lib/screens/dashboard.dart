import 'package:d_chart/commons/axis.dart';
import 'package:d_chart/commons/config_render.dart';
import 'package:d_chart/commons/data_model.dart';
import 'package:d_chart/commons/viewport.dart';
import 'package:d_chart/time/line.dart';
import 'package:flutter/material.dart';

import '../services/account.dart';
import '../services/record.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  AccountService accountService = AccountService();
  RecordService recordService = RecordService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF176B87),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 20.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<User?>(
                  future: accountService.authUser(),
                  builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
                    if (snapshot.hasData) {
                      User? user = snapshot.data;
                      String title = 'Welcome';
                      String bmi = '0';

                      if (user != null) {
                        if (user.fullName.isNotEmpty) {
                          title = '$title, ${user.fullName.split(' ')[0]}';
                        }

                        bmi = user.bmi.toStringAsFixed(2);
                      }

                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/profile');
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 14.0),
                              child: const Image(
                                image: AssetImage('assets/images/User001.png'),
                                fit: BoxFit.cover,
                                height: 60.0,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(title,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text('BMI $bmi',
                                  style: const TextStyle(
                                    color: Colors.tealAccent,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
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
                const SizedBox(height: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Daily Logs',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    FutureBuilder<TimeGroup>(
                      future: recordService.logs(Colors.blue),
                      builder: (BuildContext context, AsyncSnapshot<TimeGroup> snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: DChartLineT(
                                animate: true,
                                measureAxis: MeasureAxis(
                                  labelFormat: (measure) {
                                    return 'Stage ${measure!.round()}';
                                  },
                                ),
                                // domainAxis: DomainAxis(
                                //   timeViewport: TimeViewport(
                                //     DateTime(2023, 12, 1),
                                //     DateTime(2023, 12, 30),
                                //   ),
                                // ),
                                configRenderLine: ConfigRenderLine(
                                  areaOpacity: 0.6,
                                  includeArea: true,
                                  includePoints: true,
                                  roundEndCaps: true,
                                  strokeWidthPx: 3.0,
                                  radiusPx: 6.0,
                                ),
                                groupList: [snapshot.requireData],
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
                  ],
                ),
                const SizedBox(height: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Improvements',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    FutureBuilder<TimeGroup>(
                      future: recordService.logs(Colors.green),
                      builder: (BuildContext context, AsyncSnapshot<TimeGroup> snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: DChartLineT(
                                animate: true,
                                configRenderLine: ConfigRenderLine(
                                  areaOpacity: 0.6,
                                  includeArea: true,
                                  includePoints: true,
                                  roundEndCaps: true,
                                  strokeWidthPx: 3.0,
                                  radiusPx: 6.0,
                                ),
                                groupList: [snapshot.requireData],
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
                  ],
                ),
                const SizedBox(height: 20.0),
                const Column(
                  children: [
                    Text('Tips',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ),
      ),
    );
  }
}

