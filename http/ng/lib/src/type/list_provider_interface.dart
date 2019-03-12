import 'dart:async';

abstract class DetailListService<T> {
  Future<T> addByObject(T object);
  Future<T> updateByObject(T object);
  Future<int> deleteById(int id);
  Future<List<T>> getAll();
  Future<T> getById(int id);
  Future<List<T>> searchFor(String search);
  T getNew();
}
