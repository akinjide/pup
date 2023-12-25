import 'dart:convert';
import 'dart:io';
import 'package:aws_s3_upload/aws_s3_upload.dart';
import 'package:aws_s3_upload/enum/acl.dart';
import 'package:d_chart/commons/data_model.dart';
import 'package:d_chart/commons/enums.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:pup/services/record.dart';

import 'package:pup/utils/utils.dart';

class RecommendationService {
  RecordService recordService = RecordService();

  Future<bool> analyze(String fileName) async {
    Uri url = Uri.parse('https://8ntnmweerd.execute-api.us-east-1.amazonaws.com/dev/label');
    http.Response response = await http.post(url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({ 'fileName': fileName }),
    );

    if (response.statusCode == 200) {
      print(response.body);
      final data = json.decode(response.body) as Map<String, dynamic>;
      return data["matched"];
    }

    return false;
  }

  Future<String?> upload(XFile? file) {
    File image = File(file!.path);

    return AwsS3.uploadFile(
      accessKey: '',
      secretKey: '',
      file: image,
      bucket: 'bloom-pup-bucket',
      region: 'us-east-1',
    );
  }

  Future<List<OrdinalGroup>> diff() async {
    List<Record> records = await recordService.list();
    List<OrdinalGroup> group = [];
    Map<String, List<OrdinalData>> graphData = {};
    Map<String, List<Record>> recordData = {};
    Map<String, Map<String, int>> highestSeverityMap = {};

    // group body parts
    for (var element in records) {
      if (!recordData.containsKey(element.bodyPart)) {
        recordData[element.bodyPart] = [];
      }

      recordData[element.bodyPart]?.add(element);
    }

    // count severity per body parts
    for (var key in recordData.keys) {
      int i = 0;

      while (i < recordData[key]!.length) {
        Record element = recordData[key]![i];
        int severity = recordService.determineSeverity(element);
        String mKey = severity.toString();

        if (!highestSeverityMap.containsKey(key)) {
          highestSeverityMap[key] = {};
        }

        if (!(highestSeverityMap[key]!.containsKey(mKey))) {
          highestSeverityMap[key]![mKey] = 0;
        }

        highestSeverityMap[key]![mKey] = (highestSeverityMap[key]![mKey]! + 1);
        i++;
      }
    }

    // select maximum severity for each body parts
    for (var key in highestSeverityMap.keys) {
      if (!graphData.containsKey(key)) {
        graphData[key] = [];
      }

      int highestSeverity = 0;
      String severity = '-';

      for (var sev in highestSeverityMap[key]!.keys) {
        if (highestSeverity < highestSeverityMap[key]![sev]!) {
          highestSeverity = highestSeverityMap[key]![sev]!;
          severity = sev;
        }
      }

      graphData[key]?.add(OrdinalData(domain: 'sev - $severity', measure: highestSeverity));
    }

    // graph data
    graphData.forEach((key, value) {
      group.add(
          OrdinalGroup(
            id: key,
            chartType: ChartType.bar,
            color: bodyPartsColors[key],
            data: value,
          )
      );
    });

    return group;
  }
}