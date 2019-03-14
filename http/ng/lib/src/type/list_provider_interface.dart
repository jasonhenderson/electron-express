import 'dart:async';

abstract class DetailListService<T> {
  T getNew();
  Future<List<T>> getAll();
  Future<T> addByObject(T object);
  Future<T> updateByObject(T object);
  Future<T> getById(int id);
  Future<List<T>> searchFor(String search);
  Future<bool> deleteById(int id);
}
