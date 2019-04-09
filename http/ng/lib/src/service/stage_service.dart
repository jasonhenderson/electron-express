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
import '../type/stage.dart';
import '../type/list_provider_interface.dart';
import '../type/advanceable_interface.dart';

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

class StageService implements DetailListService<Stage>, Advanceable {

  static String baseUrl = "http://localhost:8080/v1/";
  static String coreUrl = "stage/";

  String endpointUrl(String endpoint){
    return baseUrl + coreUrl + endpoint;
  }

  Stage getNew(){
    return new Stage();
  }

  // Gets all Stage entries from the DB
  Future<List<Stage>> getAll() async {
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
        List<Stage> playerList = new List();
        if(jsonList != null){
            playerList = jsonList.map((item){
              return new Stage()
                          ..id = item["Id"]
                          ..name = item["Name"]
                          ..ownerId = item["StageId"]
                          ..tournamentId = item["TournamentId"]
                          ..maxEntrants = item["MaxEntrants"]
                          ..maxRounds = item["MaxRounds"];

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

  // Use a simple map to craft a DB call to add a new user
  Future<Stage> addByObject(Stage object) async {
    String jsonBody = json.encode({
      "Name": object.name,
      "OwnerId": object.ownerId,
      "TournamentId": object.tournamentId,
      "MaxEntrants": object.maxEntrants,
      "MaxRounds": object.maxRounds
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
          return new Stage()
                      ..id = jsonData["id"]
                      ..name = object.name
                      ..ownerId = object.ownerId
                      ..tournamentId = object.tournamentId
                      ..maxEntrants = object.maxEntrants
                      ..maxRounds = object.maxRounds;
      }
      else {
        throw new Exception("Bad status code - ${response.statusCode}");
      }
    } catch (e) {print("Error: ${e.toString()}");}
    return null;
  }

  // TODO - finish
  Future<Stage> updateByObject(Stage object){
    return null;
  }

  // TODO - Rewrite to use DB function (/get/id)
  Future<Stage> getById(int id) async {
    print("Getting: ${id}");
    try{
      // Fire the request with appropriate headers and wait for the response
      var response = await BrowserClient().get(endpointUrl(id.toString()));
      print('Response status: ${response.statusCode}');
      // If add was successful then use the incoming data to build new item
      if(response.statusCode == 200){
          dynamic jsonData = json.decode(response.body)["Data"];
          return new Stage()
                      ..id = id
                      ..name = jsonData["Name"]
                      ..ownerId = jsonData["StageId"]
                      ..tournamentId = jsonData["TournamentId"]
                      ..maxEntrants = jsonData["MaxEntrants"]
                      ..maxRounds = jsonData["MaxRounds"];
      }
      else {
        throw new Exception("Bad status code - ${response.statusCode}");
      }
    } catch (e) {print("Error: ${e.toString()}");}
    return null;
  }

  // TODO - Combine (ID FIND) with (API SEARCH)
  Future<List<Stage>> searchFor(String string) async {
    int testInt;
    try{
      return (await getAll()).where((player){
        // Try to parse as an int
        testInt = int.tryParse(string);
        if(testInt != null){
          // If we got an int, test against the player id
          if(player.id == testInt) return true;
        }
        // Try to catch the name
        return player.name.toLowerCase().contains(string.toLowerCase());
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

  Future<bool> advance(int id) async {
    print("Stage service advancing ${id.toString()}...");
    return true;
  }

}
