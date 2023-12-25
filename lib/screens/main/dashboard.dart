import 'package:flutter/material.dart';
import 'package:d_chart/d_chart.dart';

import 'package:pup/services/account.dart';
import 'package:pup/services/record.dart';
import 'package:pup/screens/widgets/loader.dart';
import 'package:pup/services/recommendation.dart';
import 'package:pup/screens/widgets/snackbar.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  AccountService accountService = AccountService();
  RecordService recordService = RecordService();
  RecommendationService recommendationService = RecommendationService();

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
                          SnackBarNotification.navigatorKey.currentState?.pushNamed('/profile');
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

                    return const Loader();
                  },
                ),
                const SizedBox(height: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Daily Logs',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text('Last 24 hours graph for all body part.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    FutureBuilder<List<TimeGroup>>(
                      future: recordService.logs(),
                      builder: (BuildContext context, AsyncSnapshot<List<TimeGroup>> snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Column(
                              children: [
                                AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: DChartLineT(
                                    animate: true,
                                    configRenderLine: ConfigRenderLine(
                                      includePoints: true,
                                      roundEndCaps: true,
                                      strokeWidthPx: 2.0,
                                      radiusPx: 4.0,
                                    ),
                                    groupList: snapshot.requireData,
                                  ),
                                ),
                                Builder(builder: (BuildContext context) {
                                  List<Widget> item = [];

                                  for (var element in snapshot.requireData) {
                                    item.add(Container(
                                      width: 80.0,
                                      height: 20.0,
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 8.0),
                                          Container(
                                            width: 8.0,
                                            height: 8.0,
                                            decoration: BoxDecoration(
                                              color: element.color,
                                              borderRadius: BorderRadius.circular(4.0),
                                            ),
                                          ),
                                          const SizedBox(width: 4.0),
                                          Text(element.id,
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                                  }

                                  return Wrap(
                                    direction: Axis.horizontal,
                                    children: item,
                                  );
                                }),
                              ],
                            ),
                          );
                        }

                        return const Loader();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 40.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Improvements',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Text('Improvements shows the maximum count of body part severity logged in last 24 hours. Less than 2 means body part is improving.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                    const Text('* sev means severity',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                    const Text('** bars can be subtracted to get body part value',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.0,
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    FutureBuilder<List<OrdinalGroup>>(
                      future: recommendationService.diff(),
                      builder: (BuildContext context, AsyncSnapshot<List<OrdinalGroup>> snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Column(
                              children: [
                                AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: DChartComboO(
                                    animate: true,
                                    configRenderBar: ConfigRenderBar(
                                      barGroupingType: BarGroupingType.groupedStacked
                                    ),
                                    groupList: snapshot.requireData,
                                  ),
                                ),
                                Builder(builder: (BuildContext context) {
                                  List<Widget> item = [];

                                  for (var element in snapshot.requireData) {
                                    item.add(Container(
                                      width: 80.0,
                                      height: 20.0,
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 8.0),
                                          Container(
                                            width: 8.0,
                                            height: 8.0,
                                            decoration: BoxDecoration(
                                              color: element.color,
                                              borderRadius: BorderRadius.circular(4.0),
                                            ),
                                          ),
                                          const SizedBox(width: 4.0),
                                          Text(element.id,
                                            style: const TextStyle(
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ));
                                  }

                                  return Wrap(
                                    direction: Axis.horizontal,
                                    children: item,
                                  );
                                }),
                              ],
                            ),
                          );
                        }

                        return const Loader();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 40.0),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tips',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 20.0),
                    Text('1. Change your position regularly to relieve pressure',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text('2. Use comfortable cushions and mattresses to reduce pressure points.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text('3. Eat a balanced diet rich in protein and nutrients for better healing.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text('4. Keep the skin clean and dry to prevent moisture-related issues.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.w500,
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

