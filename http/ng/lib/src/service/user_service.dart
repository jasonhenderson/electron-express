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
import '../type/user.dart';
import '../type/list_provider_interface.dart';

// ***************
// API DEFINITION
// ***************
/*
POST
​/user​/add
GET
​/user​/find
POST
​/user​/login
GET
​/user​/logout
POST
​/user​/sync
GET
​/user​/{id}
DELETE
​/user​/{id}
*/

class UserService implements DetailListService<User> {

  static String baseUrl = "http://localhost:8080/v1/";
  static String coreUrl = "user/";

  String endpointUrl(String endpoint){
    return baseUrl + coreUrl + endpoint;
  }

  User getNew(){
    return new User();
  }

  // Gets all User entries from the DB
  Future<List<User>> getAll() async {
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
        List<User> playerList = new List();
        if(jsonList != null){
            playerList = jsonList.map((item){
              return new User()
                          ..id = item['Id']
                          ..name = item['Name']
                          ..key = item['Key'];

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
  Future<User> addByObject(User object) async {
    String jsonBody = json.encode({
      "Name": object.name,
      "Key": object.key
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
          return new User()
                      ..id = jsonData["id"]
                      ..name = object.name
                      ..key = object.key;
      }
      else {
        throw new Exception("Bad status code - ${response.statusCode}");
      }
    } catch (e) {print("Error: ${e.toString()}");}
    return null;
  }

  // TODO - finish
  Future<User> updateByObject(User object){
    return null;
  }

  // TODO - Rewrite to use DB function (/get/id)
  Future<User> getById(int id) async {
    print("Getting: ${id}");
    try{
      // Fire the request with appropriate headers and wait for the response
      var response = await BrowserClient().get(endpointUrl(id.toString()));
      print('Response status: ${response.statusCode}');
      // If add was successful then use the incoming data to build new item
      if(response.statusCode == 200){
          dynamic jsonData = json.decode(response.body)["Data"];
          return new User()
                      ..id = id
                      ..name = jsonData["Name"]
                      ..key = jsonData["Key"];
      }
      else {
        throw new Exception("Bad status code - ${response.statusCode}");
      }
    } catch (e) {print("Error: ${e.toString()}");}
    return null;
  }

  // TODO - Combine (ID FIND) with (API SEARCH)
  // TODO - Alternatively, just use DB search API
  Future<List<User>> searchFor(String string) async {
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
