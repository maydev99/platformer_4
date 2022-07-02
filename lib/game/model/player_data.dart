import 'package:flutter/widgets.dart';

class PlayerData {
  final score = ValueNotifier<int>(0);
  final health = ValueNotifier<int>(5);
}