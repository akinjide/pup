import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum BodyParts {
  ankles,
  back,
  butt,
  elbows,
  heels,
  hips,
  tailbone,
  shoulderBlades,
  backOfTheHead,
}

enum Stages {
  stage1,
  stage2,
  stage3,
  stage4
}

class BodyPart {
  final String name;
  final BodyParts part;
  final MaterialColor color;

  BodyPart(this.name, this.part, this.color);
}

class Stage {
  final String name;
  final Stages stage;

  Stage(this.name, this.stage);
}

class Reminder {
  final String name;
  final RepeatInterval reminder;

  Reminder(this.name, this.reminder);
}

List<BodyPart> bodyParts = [
  BodyPart('Ankles', BodyParts.ankles, Colors.purple),
  BodyPart('Back', BodyParts.back, Colors.blue),
  BodyPart('Butt', BodyParts.butt, Colors.red),
  BodyPart('Elbows', BodyParts.elbows, Colors.green),
  BodyPart('Heels', BodyParts.heels, Colors.yellow),
  BodyPart('Hips', BodyParts.hips, Colors.pink),
  BodyPart('Tailbone', BodyParts.tailbone, Colors.orange),
  BodyPart('Shoulder', BodyParts.shoulderBlades, Colors.cyan),
  BodyPart('Head Back', BodyParts.backOfTheHead, Colors.brown),
];

Map<String, MaterialColor> bodyPartsColors = {
  'Ankles': Colors.purple,
  'Back': Colors.blue,
  'Butt': Colors.red,
  'Elbows': Colors.green,
  'Heels': Colors.yellow,
  'Hips': Colors.pink,
  'Tailbone': Colors.orange,
  'Shoulder': Colors.cyan,
  'Head Back': Colors.brown,
};

List<Stage> stages = [
  Stage('Stage 1', Stages.stage1),
  Stage('Stage 2', Stages.stage2),
  Stage('Stage 3', Stages.stage3),
  Stage('Stage 4', Stages.stage4),
];

List<String> genderOptions = [
  'Male',
  'Female',
];

List<String> heightOptions = [
  'm',
  'in',
];

List<String> weightOptions = [
  'kg',
  'lbs',
];