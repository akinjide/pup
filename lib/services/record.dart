import 'package:d_chart/commons/data_model.dart';
import 'package:d_chart/commons/enums.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pup/services/account.dart';

import 'firebase.dart';

class Record {
  String recordID;
  String userID;
  DateTime addedAt;
  String severity;
  String bodyPart;
  String picture;

  Record({
    this.recordID = '',
    this.userID = '',
    required this.addedAt,
    this.severity = '',
    this.bodyPart = '',
    this.picture = '',
  });

  factory Record.fromJson(Map<dynamic, dynamic>json) {
    return Record(
      recordID: json['record_id'],
      userID: json['user_id'],
      addedAt: DateTime.parse(json['added_at']),
      severity: json['severity'],
      bodyPart: json['body_part'],
      picture: json['picture'],
    );
  }
}


class RecordService {
  FirebaseServiceDatabase fsdb = FirebaseServiceDatabase();

  Future<bool> create(List<Record> records, String userId) async {
    DatabaseReference ref = fsdb.database.ref("records/$userId");

    for (var element in records) {
      DatabaseReference recordRef = ref.push();

      await recordRef.set({
        "user_id": userId,
        "record_id": recordRef.key,
        "added_at": element.addedAt.toIso8601String(),
        "severity": element.severity,
        "body_part": element.bodyPart,
        "picture": element.picture,
      });
    }

    return true;
  }

  Future<List<Record>> list() async {
    String? userId = await AccountService.activeId();
    final recentRecordsRef = fsdb.database.ref("records/$userId").limitToLast(100);
    final snapshot = await recentRecordsRef.get();
    List<Record> records = [];

    if (snapshot.exists) {
      for (final child in snapshot.children) {
        Map<dynamic, dynamic> data = child.value as dynamic;
        records.add(Record.fromJson(data));
      }

      return records;
    }

    return records;
  }

  Future<TimeGroup> logs(Color color) async {
    List<Record> records = await list();
    List<TimeData> data = [];

    for (var element in records) {
      int severity = 0;

      switch (element.severity) {
        case 'Stage 1':
          severity = 1;
          break;
        case 'Stage 2':
          severity = 2;
          break;
        case 'Stage 3':
          severity = 3;
          break;
        case 'Stage 4':
          severity = 4;
          break;
      }

      data.add(TimeData(domain: element.addedAt, measure: severity));
    }

    return TimeGroup(
        id: '1',
        chartType: ChartType.line,
        color: color,
        data: data
    );
  }
}