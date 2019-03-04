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
import '../type/player.dart';
import '../type/list_provider_interface.dart';

class PlayerService implements DetailListService {

  // Static name for all services created by this class
  String getName() => "players";

  // Use a simple map to craft a DB call to add a new player
  Future<Player> addByMap(Map object) async {
    // Get a handle to a new XHR builder and build a url for it
    var client = BrowserClient();
    var url = 'http://localhost:8080/v1/user/add';
    print("Adding: ${object['name']}");
    // Build an XHR body by encoding values from the passed Map object
    String jsonBody = json.encode( {"Name": object["name"]} );
    print(jsonBody);
    // Fire the request with appropriate headers and wait for the response
    var response = await client.post(url,
                                    headers: { "Content-Type": "application/json"},
                                    body: jsonBody);
    print('Response status: ${response.statusCode}');
    // If add was successful then use the incoming data to build new item
    if(response.statusCode == 200){
        Map jsonData = json.decode(response.body)["Data"];
        int responseId = jsonData["id"];
        // NOTE - THIS BLOCK CAN BE DROPPED IN IF PARSING NEEDED
        // int responseId;
        // if(jsonData["id"] is int){
        //     responseId = jsonData["id"];
        // } else if(int.tryParse(jsonData["id"]) is int){
        //     responseId = int.tryParse(jsonData["id"]);
        // }
        print("Returning ID: ${responseId}");
        // Build new item and return
        return Player(responseId, object["name"]);
    }
    else {
        print("Error, code: ${response.statusCode}");
        return null;
    }
  }

  // Gets all Player entries from the DB
  Future<List<Player>> getAll() async {
    // Get a handle to a new XHR builder and build a url for it
    var client = BrowserClient();
    var url = 'http://localhost:8080/v1/user/find/\*';
    // Fire the request and wait for the response
    var response = await client.get(url);
    print('Response status: ${response.statusCode}');

    // ********************************************************
    // WARNING - DO NOT CONCATENATE THESE FUNCTIONS IN ANY WAY
    // WARNING - SERIOUS TYPING ISSUES IF NOT LEFT AS-IS
    // ********************************************************
    List<dynamic> jsonList = (json.decode(response.body) as Map)["Data"];
    List<Player> playerList = new List();
    if(jsonList != null){
        playerList = jsonList.map((item) => Player(item["Id"], item["Name"])).toList();
    }
    // ********************************************************

    return playerList;
  }

  // TODO - Rewrite to use DB function (/get/id)
  Future<Player> getById(int id) async =>
      (await getAll()).firstWhere((player) => player.id == id);

  // TODO - Combine (ID FIND) with (API SEARCH)
  Future<List<Player>> searchFor(String string) async {
    int testInt;
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
  }

  Future<int> deleteById(int id) async {
    // Announce
    print("Deleting: ${id}");
    // Get a handle to a new XHR builder and build a url for it
    var client = BrowserClient();
    String url = 'http://localhost:8080/v1/user/';
    url += id.toString();
    // Fire the request and wait for the response
    var response = await client.delete(url);
    print('Response status: ${response.statusCode}');
    // Vanilla response code return
    return response.statusCode;
  }
}
