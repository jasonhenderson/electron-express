import 'dart:async';

abstract class DetailListService {
  String getName();
  Future<dynamic> addByMap(Map map);
  Future<dynamic> addByObject(dynamic object);
  Future<dynamic> updateByObject(dynamic object);
  Future<int> deleteById(int id);
  Future<List<dynamic>> getAll();
  Future<dynamic> getById(int id);
  Future<List<dynamic>> searchFor(String search);
  dynamic getNew();
}
