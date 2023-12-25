import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:pup/screens/widgets/snackbar.dart';
import 'package:pup/services/notification.dart';

import '../../utils/utils.dart';
import '../widgets/dropdown.dart';
import '../widgets/loader.dart';

List<Reminder> reminders = [
  Reminder('Minute', RepeatInterval.everyMinute),
  Reminder('Hour', RepeatInterval.hourly),
  Reminder('Day', RepeatInterval.daily),
  Reminder('Week', RepeatInterval.weekly),
];

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String reminder = reminders.first.name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF176B87),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF176B87),
        foregroundColor: const Color(0xFFFFFFFF),
        title: const Text('Notifications', style: TextStyle(
          fontWeight: FontWeight.w600,
        ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 20.0, bottom: 10.0),
                  child: Text('Pressure Relieve Reminder',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 10.0),
                Container(
                  height: 100.0,
                  color: const Color(0xFF91C8E4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: const Text('Set reminder for every:',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      FutureBuilder<String?>(
                        future: NotificationService.getReminder(),
                        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                          if (snapshot.hasData) {
                            String? remind = snapshot.data;

                            if (remind != null) {
                              reminder = remind;
                            }

                            return Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Dropdown(
                                hintText: '',
                                value: reminder,
                                items: reminders.map<DropdownMenuItem<String>>((Reminder value) {
                                  return DropdownMenuItem<String>(
                                    value: value.name,
                                    child: Text(value.name),
                                  );
                                }).toList(),
                                onChanged: (String? value) async {
                                  setState(() { reminder = value!; });
                                  NotificationService.cancelSchedule();
                                  Reminder remind = reminders.firstWhere((element) => element.name == reminder);
                                  await NotificationService.setReminder(remind.name);
                                  NotificationService.schedule(remind.reminder);
                                  SnackBarNotification.notify('Reminder set for every ${remind.name}');
                                },
                              ),
                            );
                          }

                          return const Loader();
                        },
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tips for pressure relieve:',
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
