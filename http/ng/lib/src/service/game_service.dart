// ***************
// CORE IMPORTS
// ***************
import 'dart:async';
import 'dart:convert';
// See: https://pub.dartlang.org/packages/http @ "Using on the Browser"
import 'package:http/browser_client.dart';

// ***************
// PROJECT IMPORTS
// ***************
import '../type/game.dart';
import '../type/list_provider_interface.dart';

// ***************
// API DEFINITION
// ***************
/*
POST
​/round​/add
GET
​/round​/find
POST
​/round​/sync
GET
​/round​/{id}
DELETE
​/round​/{id}
*/

class GameService implements DetailListService<Game> {

  static String baseUrl = "http://localhost:8080/v1/";
  static String coreUrl = "game/";

  String endpointUrl(String endpoint){
    return baseUrl + coreUrl + endpoint;
  }

  Game getNew(){
    return new Game();
  }

  // Gets all Round entries from the DB
  Future<List<Game>> getAll() async {
    print("Getting: all");
    try{
      // Fire the request and wait for the response
      var response = await BrowserClient().get(endpointUrl("find"));
      print('Response status: ${response.statusCode}');
      if(response.statusCode == 200){
        // ********************************************************
        // WARNING - DO NOT CONCATENATE THESE FUNCTIONS IN ANY WAY
        // WARNING - SERIOUS TYPING ISSUES IF NOT LEFT AS-IS
        // ********************************************************
        List<dynamic> jsonList = (json.decode(response.body) as Map)["Data"];
        List<Game> playerList = new List();
        if(jsonList != null){
            playerList = jsonList.map((object){
              return new Game()
                          ..id = object['Id']
                          ..ownerId = object['OwnerId']
                          ..matchId = object['MatchId'];

            }).toList();
        }
        // ********************************************************
        return playerList;
      } else {
        throw new Exception("Bad status code - ${response.statusCode}");
      }
    } catch (e) {print("Error: ${e.toString()}");}
    return null;
  }

  // Use a simple map to craft a DB call to add a new round
  Future<Game> addByObject(Game object) async {
    String jsonBody = json.encode({
      "OwnerId": object.ownerId,
      "MatchId": object.matchId
    });
    print(jsonBody);
    try{
      // Fire the request with appropriate headers and wait for the response
      var response = await BrowserClient().post(endpointUrl("add"),
                                                headers: { "Content-Type": "application/json"},
                                                body: jsonBody);
      print('Response status: ${response.statusCode}');
      // If add was successful then use the incoming data to build new item
      if(response.statusCode == 200){
          dynamic jsonData = json.decode(response.body)["Data"];
          // TODO - Fix API and return "Id" for consistency
          print("Returning ID: ${jsonData['id']}");
          return new Game()
                      ..id = jsonData["id"]
                      ..ownerId = object.ownerId
                      ..matchId = object.matchId;
      }
      else {
        throw new Exception("Bad status code - ${response.statusCode}");
      }
    } catch (e) {print("Error: ${e.toString()}");}
    return null;
  }

  // TODO - finish
  Future<Game> updateByObject(Game object){
    return null;
  }

  // TODO - Rewrite to use DB function (/get/id)
  Future<Game> getById(int id) async {
    print("Getting: ${id}");
    try{
      // Fire the request with appropriate headers and wait for the response
      var response = await BrowserClient().get(endpointUrl(id.toString()));
      print('Response status: ${response.statusCode}');
      // If add was successful then use the incoming data to build new item
      if(response.statusCode == 200){
          dynamic jsonData = json.decode(response.body)["Data"];
          return new Game()
                      ..id = id
                      ..ownerId = jsonData['OwnerId']
                      ..matchId = jsonData['MatchId'];
      }
      else {
        throw new Exception("Bad status code - ${response.statusCode}");
      }
    } catch (e) {print("Error: ${e.toString()}");}
    return null;
  }

  // TODO - Combine (ID FIND) with (API SEARCH)
  Future<List<Game>> searchFor(String string) async {
    int testInt;
    try{
      return (await getAll()).where((game){
        // Try to parse as an int
        testInt = int.tryParse(string);
        if(testInt != null){
          // If we got an int, test against the player id
          if(game.id == testInt) return true;
        }
        return false;
      }).toList();
    } catch (e) {print("Error: ${e.toString()}"); return null;}
  }

  Future<bool> deleteById(int id) async {
    print("Deleting: ${id}");
    try{
      // Fire the request and wait for the response
      var response = await BrowserClient().delete(endpointUrl(id.toString()));
      print('Response status: ${response.statusCode}');
      if(response.statusCode == 200){
        return true;
      } else {
        throw new Exception("Bad status code - ${response.statusCode}");
      }
    } catch (e) {print("Error: ${e.toString()}");}
    return false;
  }

}
