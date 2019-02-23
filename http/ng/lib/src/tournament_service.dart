import 'dart:async';

import 'tournament.dart';
import 'mock_tournaments.dart';

import 'list_provider_interface.dart';

class TournamentService implements DetailListService {

  String getName() => "tournament";

  Future<List<Tournament>> getAll() async => mockTournaments;

  Future<Tournament> get(int id) async =>
      (await getAll()).firstWhere((tournament) => tournament.id == id);
}
