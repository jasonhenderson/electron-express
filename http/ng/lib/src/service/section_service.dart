import 'dart:async';

import '../type/section.dart';
import '../data/mock_sections.dart';

import '../type/list_provider_interface.dart';

class SectionService implements DetailListService {

  String getName() => "section";

  Future<List<Section>> getAll() async => mockSections;

  Future<Section> get(int id) async =>
      (await getAll()).firstWhere((section) => section.id == id);
}
