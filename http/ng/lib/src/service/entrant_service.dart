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
import '../type/entrant.dart';
import '../type/list_provider_interface.dart';

// ***************
// API DEFINITION
// ***************
/*
POST
​/entrant​/add
GET
​/entrant​/find
POST
​/entrant​/sync
POST
​/entrant​/upload
GET
​/entrant​/{id}
DELETE
​/entrant​/{id}
*/

class EntrantService implements DetailListService<Entrant> {

  static String baseUrl = "http://localhost:8080/v1/";
  static String apiUrl = "entrant/";

  String endpointUrl(String endpoint){
    return baseUrl + apiUrl + endpoint;
  }

  Entrant getNew(){
    return new Entrant();
  }

  // Gets all User entries from the DB
  Future<List<Entrant>> getAll() async {
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
        List<Entrant> playerList = new List();
        if(jsonList != null){
            playerList = jsonList.map((item){
              return new Entrant()
                          ..id = item['Id']
                          ..name = item['Name']
                          ..eventId = item['EventId']
                          ..ownerId = item["OwnerId"];

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

  // Use a simple map to craft a DB call to add a new entrant
  Future<Entrant> addByObject(Entrant object) async {
    String jsonBody = json.encode({
      "Name": object.name,
      "EventId": object.eventId,
      "OwnerId": object.ownerId
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
          return new Entrant()
                      ..id = jsonData["id"]
                      ..name = object.name
                      ..eventId = object.eventId
                      ..ownerId = object.ownerId;
      }
      else {
        throw new Exception("Bad status code - ${response.statusCode}");
      }
    } catch (e) {print("Error: ${e.toString()}");}
    return null;
  }

  // TODO - finish
  Future<Entrant> updateByObject(Entrant object){
    return null;
  }

  // TODO - Rewrite to use DB function (/get/id)
  Future<Entrant> getById(int id) async {
    print("Getting: ${id}");
    try{
      // Fire the request with appropriate headers and wait for the response
      var response = await BrowserClient().get(endpointUrl(id.toString()));
      print('Response status: ${response.statusCode}');
      // If add was successful then use the incoming data to build new item
      if(response.statusCode == 200){
          dynamic jsonData = json.decode(response.body)["Data"];
          return new Entrant()
                      ..id = id
                      ..name = jsonData["Name"]
                      ..eventId = jsonData["EventId"];
      }
      else {
        throw new Exception("Bad status code - ${response.statusCode}");
      }
    } catch (e) {print("Error: ${e.toString()}");}
    return null;
  }

  // TODO - Combine (ID FIND) with (API SEARCH)
  Future<List<Entrant>> searchFor(String string) async {
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

}
