import 'dart:async';

import '../type/player.dart';
import '../data/mock_players.dart';

import '../type/list_provider_interface.dart';

class PlayerService implements DetailListService {

  String getName() => "players";

  Future<List<Player>> getAll() async => mockPlayers;

  Future<Player> get(int id) async =>
      (await getAll()).firstWhere((player) => player.id == id);
}
