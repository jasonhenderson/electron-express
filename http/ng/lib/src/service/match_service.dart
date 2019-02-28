import 'dart:async';

import '../type/match.dart';
import '../data/mock_matches.dart';

import '../type/list_provider_interface.dart';

class MatchService implements DetailListService {

  String getName() => "results";

  Future<List<Match>> getAll() async => mockMatches;

  Future<Match> get(int id) async =>
      (await getAll()).firstWhere((match) => match.id == id);
}
