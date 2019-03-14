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
import '../type/event.dart';
import '../type/list_provider_interface.dart';

// ***************
// API DEFINITION
// ***************
/*
POST
​/tournament​/add
GET
​/tournament​/find
POST
​/tournament​/sync
GET
​/tournament​/{id}
DELETE
​/tournament​/{id}
*/

class EventService implements DetailListService<Event> {

  static String baseUrl = "http://localhost:8080/v1/";
  static String coreUrl = "event/";

  String endpointUrl(String endpoint){
    return baseUrl + coreUrl + endpoint;
  }

  Event getNew(){
    return new Event();
  }

  Future<List<Event>> getAll() async {
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
        List<Event> tournamentList = new List();
        if(jsonList != null){
            tournamentList = jsonList.map((item){
              return new Event()
                          ..id = item['Id']
                          ..name = item['Name']
                          ..ownerId = item['OwnerId'];
            }).toList();
        }
        // ********************************************************
        return tournamentList;
      } else {
        throw new Exception("Bad status code - ${response.statusCode}");
      }
    } catch (e) {print("Error: ${e.toString()}");}
     return null;
  }

  Future<Event> addByObject(Event object) async {
    String jsonBody = json.encode({
      "Name": object.name,
      "OwnerId": object.ownerId,
      // TODO - Encode/pass settings from a Map<d,d> to some JSON values
      //"Settings": json.encode(object.settings)
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
        return new Event()
                    ..id = jsonData["id"]
                    ..name = object.name
                    ..ownerId = object.ownerId;
      }
      else {
        throw new Exception("Bad status code - ${response.statusCode}");
      }
    } catch (e) {print("Error: ${e.toString()}");}
    return null;
  }

  // TODO - finish
  Future<Event> updateByObject(Event object){
    return null;
  }

  Future<Event> getById(int id) async{
    print("Getting: ${id}");
    try{
      // Fire the request with appropriate headers and wait for the response
      var response = await BrowserClient().get(endpointUrl(id.toString()));
      print('Response status: ${response.statusCode}');
      // If add was successful then use the incoming data to build new item
      if(response.statusCode == 200){
          dynamic jsonData = json.decode(response.body)["Data"];
          return new Event()
                      ..id = id
                      ..name = jsonData["Name"]
                      ..ownerId = jsonData["OwnerId"];
      }
      else {
        throw new Exception("Bad status code - ${response.statusCode}");
      }
    } catch (e) {print("Error: ${e.toString()}");}
    return null;
  }

  Future<List<Event>> searchFor(String string) async {
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

  Future<bool> deleteById(int id) async {
    print("Deleting: ${id}");
    try{
      // Fire the request and wait for the response
      var response = await BrowserClient().delete(endpointUrl(id.toString()));
      print('Response status: ${response.statusCode}');
      // Vanilla response code return
      if(response.statusCode == 200){
        return true;
      } else {
        throw new Exception("Bad status code - ${response.statusCode}");
      }
    } catch (e) {print("Error: ${e.toString()}");}
    return false;
  }

}
