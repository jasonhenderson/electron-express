import 'dart:async';

abstract class Advanceable {
  Future<bool> advance(int id);
}
