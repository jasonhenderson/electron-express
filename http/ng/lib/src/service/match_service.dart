import 'dart:async';

import '../type/match.dart';
import '../data/mock_matches.dart';

import '../type/list_provider_interface.dart';

class MatchService implements DetailListService {

  String getName() => "results";

  Future<dynamic> addByMap(Map newObject){
    return null;
  }

  Future<List<Match>> getAll() async => mockMatches;

  Future<Match> getById(int id) async =>
      (await getAll()).firstWhere((match) => match.id == id);

  Future<List<Match>> searchFor(String string) async {
    int testInt;
    return (await getAll()).where((match){
      // Try to parse as an int
      testInt = int.tryParse(string);
      if(testInt != null){
        // If we got an int, test against the match id
        if(match.id == testInt) return true;
      }
      // Try to catch the name
      return match.name.toLowerCase().contains(string.toLowerCase());
    }).toList();
  }

  Future<int> deleteById(int id){
    return null;
  }
  Match getNew(){
    return new Match(0, "New");
  }
}
