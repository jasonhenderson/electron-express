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

class PlayerService implements DetailListService<Player> {

  Future<Player> updateByObject(Player object){
    return null;
  }

  // Use a simple map to craft a DB call to add a new player
  Future<Player> addByObject(Player object) async {
    // Get a handle to a new XHR builder and build a url for it
    var client = BrowserClient();
    var url = 'http://localhost:8080/v1/user/add';
    print("Adding: ${object.name}");
    print("Key: ${object.key}");
    // Build an XHR body by encoding values from the passed Map
    String jsonBody = json.encode({
      "Name": object.name,
      "Key": object.key
    });
    print(jsonBody);
    try{
      // Fire the request with appropriate headers and wait for the response
      var response = await client.post(url,
                                      headers: { "Content-Type": "application/json"},
                                      body: jsonBody);
      print('Response status: ${response.statusCode}');
      // If add was successful then use the incoming data to build new item
      if(response.statusCode == 200){
          dynamic jsonData = json.decode(response.body)["Data"];
          // TODO - Fix API and return "Id" for consistency
          print("Returning ID: ${jsonData['id']}");
          return new Player()
                      ..id = jsonData["id"]
                      ..name = object.name
                      ..key = object.key;
      }
      else {
          print("Error, code: ${response.statusCode}");
      }
    } catch (e) {print("Error: ${e.toString()}");}
    return null;
  }

  // Gets all Player entries from the DB
  Future<List<Player>> getAll() async {
    // Get a handle to a new XHR builder and build a url for it
    var client = BrowserClient();
    var url = 'http://localhost:8080/v1/user/find/\*';
    try{
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
          playerList = jsonList.map((item){
            return new Player()
                        ..id = item['Id']
                        ..name = item['Name']
                        ..key = item['Key'];

          }).toList();
      }
      // ********************************************************
      return playerList;
    } catch (e) {print("Error: ${e.toString()}"); return null;}
  }

  // TODO - Rewrite to use DB function (/get/id)
  Future<Player> getById(int id) async {
    try{
      // Value is filled if match on ID, null if not found (opaque vs error)
      return (await getAll()).firstWhere((player) => player.id == id,
                                          orElse: () => null);
    } catch (e) {print("Error: ${e.toString()}");}
    return null;
  }

  // TODO - Combine (ID FIND) with (API SEARCH)
  Future<List<Player>> searchFor(String string) async {
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

  Future<int> deleteById(int id) async {
    // Announce
    print("Deleting: ${id}");
    // Get a handle to a new XHR builder and build a url for it
    var client = BrowserClient();
    String url = 'http://localhost:8080/v1/user/';
    url += id.toString();
    try{
      // Fire the request and wait for the response
      var response = await client.delete(url);
      print('Response status: ${response.statusCode}');
      // Vanilla response code return
      return response.statusCode;
    } catch (e) {print("Error: ${e.toString()}"); return null;}
  }

  Player getNew(){
    return new Player();
  }
}
