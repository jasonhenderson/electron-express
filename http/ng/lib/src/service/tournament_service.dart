import 'dart:async';

import '../type/tournament.dart';
import '../data/mock_tournaments.dart';

import '../type/list_provider_interface.dart';

class TournamentService implements DetailListService {

  String getName() => "tournament";

  Future<List<Tournament>> getAll() async => mockTournaments;

  Future<Tournament> get(int id) async =>
      (await getAll()).firstWhere((tournament) => tournament.id == id);
}
