import 'dart:async';

import 'section.dart';
import 'mock_sections.dart';

import 'list_provider_interface.dart';

class SectionService implements DetailListService {

  String getName() => "section";

  Future<List<Section>> getAll() async => mockSections;

  Future<Section> get(int id) async =>
      (await getAll()).firstWhere((section) => section.id == id);
}
