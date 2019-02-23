import 'dart:async';

abstract class DetailListService {
  String getName();
  Future<List<dynamic>> getAll();
  Future<dynamic> get(int id);
}
