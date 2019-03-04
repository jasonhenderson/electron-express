import 'dart:async';

import '../type/tournament.dart';
import '../data/mock_tournaments.dart';

import '../type/list_provider_interface.dart';

class TournamentService implements DetailListService {

  String getName() => "tournament";

  Future<List<Tournament>> getAll() async => mockTournaments;
  Future<dynamic> addByMap(Map newObject){
    return null;
  }

  Future<Tournament> getById(int id) async =>
      (await getAll()).firstWhere((tournament) => tournament.id == id);

  Future<List<Tournament>> searchFor(String string) async {
    int testInt;
    return (await getAll()).where((tournament){
      // Try to parse as an int
      testInt = int.tryParse(string);
      if(testInt != null){
        // If we got an int, test against the tournament id
        if(tournament.id == testInt) return true;
      }
      // Try to catch the name
      return tournament.name.toLowerCase().contains(string.toLowerCase());
    }).toList();
  }

  Future<int> deleteById(int id){
    return null;
  }
}
