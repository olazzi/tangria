import 'package:flutter/foundation.dart';

class CollectionEvents {
  static final ValueNotifier<int> version = ValueNotifier<int>(0);
  static void bump() => version.value++;
}
