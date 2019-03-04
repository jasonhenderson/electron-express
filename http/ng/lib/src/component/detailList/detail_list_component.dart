// ***************
// CORE IMPORTS
// ***************
import 'dart:async';
import 'dart:html';

// ***************
// ANGULAR IMPORTS
// ***************
import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';

import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_button/material_fab.dart';
import 'package:angular_components/material_icon/material_icon.dart';

import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';

// ***************
// PROJECT IMPORTS
// ***************
import '../../service/tournament_service.dart';
import '../../service/match_service.dart';
import '../../service/player_service.dart';
import '../../type/list_provider_interface.dart';

@Component(
  selector: 'my-itemlist',
  templateUrl: 'detail_list_component.html',
  styleUrls: ['detail_list_component.css'],
  directives: [
                coreDirectives,
                formDirectives,
                MaterialButtonComponent,
                MaterialFabComponent,
                MaterialIconComponent,
                materialInputDirectives,
                AutoDismissDirective,
                MaterialDialogComponent,
                ModalComponent,
              ],
  pipes: [commonPipes],
)
class DetailListComponent implements OnInit, OnActivate {
  // Hold on to current service and string title
  DetailListService _currentService;
  String _serviceName;
  // List of items from calls to current service
  List<dynamic> listItems = new List();
  // Currently selected item handle
  dynamic selected;
  void onSelect(dynamic item) => selected = item;
  // Current value for search text-box
  String _searchText = "";
  void updateSearchText(String text) => _searchText = text;
  // Toggle the "New" feature for the current service and hold value (text-box)
  bool adding = false;
  String addingText = "";
  // Toggle the "Delete" modal for confirmation before sending DB request
  bool deleteModalVisible = false;

  DetailListComponent();

  // Use the current service to get every item available (NO FILTER)
  Future<void> _getServiceItems() async {
    listItems = await _currentService.getAll();
  }

  // NO ACTION ON INIT
  void ngOnInit(){
   print("Init finished");
  }

  // Take current router path and parse into required service, then LOAD
  @override
  void onActivate(_, RouterState current) async {
    print("Router state: $current");
    print("Router path:");
    print(current.routePath);
    // Get current path from router
    _serviceName = current.routePath.path;
    print("Service : $_serviceName");
    // Use current path to determine service to load
    // WARNING - THIS WILL BREAK WHEN PARAMETERS ARE PASSED
    // TODO - Build better parsing logic, path.split("/")[0] etc should work
    switch (_serviceName) {
      case "tournaments":
        print("Loading tournament service...");
        _currentService = TournamentService();
        break;
      case "matches":
        print("Loading match service...");
        _currentService = MatchService();
        break;
      case "players":
        print("Loading player service...");
        _currentService = PlayerService();
        break;
      default:
        window.alert("Oops, that service doesn't seem to exist!");
        print("Failed to find service... bad load!");
        break;
    }
    _getServiceItems();
    print("Done with service load!");
  }

  // TODO - Load some component when DETAIL view is required by user
  void gotoDetail(){
    print("NAME, ID, SERVICE:");
    print('${selected.name}, ${selected.id}, ${_currentService.getName()}');
    window.alert("${selected.name}, ${selected.id}, ${_currentService.getName()}");
  }

  // Simple utility to parse service name from router into capitalized (?) value
  String getSectionTitle(bool capital) {
    if(_serviceName == null){
        return "";
    }
    if(capital){
        return _serviceName[0].toUpperCase() + _serviceName.substring(1);
    } else {
        return _serviceName;
    }
  }

  // Extinguish the current event and initiate a text search on current service
  void onSearch(Event event) async {
    print("Search initiated...");
    print("Current value is: ${_searchText}");
    event.stopPropagation();
    event.preventDefault();
    listItems = await _currentService.searchFor(_searchText);
  }

  // Take the current text value and add it to the DB using the current service
  void addClicked() async {
    print("Add button clicked!");
    print("Adding: ${addingText}");
    // Create new object
    Map newObject = {};
    newObject["name"] = addingText;
    // Feed new object to current service for DB translate/insert
    dynamic newItem = await _currentService.addByMap(newObject);
    if(newItem != null){
        if(newItem.id > 0){
            // If we insert successfully then push onto current UI list
            listItems.insert(0, newItem);
        } else {
            print("Error with response: ${newItem.id}");
        }
    }
    // Close UI elements used for (ADD)
    adding = false;
    addingText = "";
  }

  // Extinguish the current event and attempt to confirm DELETE with modal
  void onDelete(UIEvent event, dynamic thing) async {
    event.stopPropagation();
    event.preventDefault();
    print("Running delete flow...");
    // Select thing and open confim modal
    selected = thing;
    deleteModalVisible = true;
  }

  // Modal confirms DELETE, use current selection ID and feed to current service
  void onConfirmDelete() async {
    deleteModalVisible = false;
    int statusCode = await _currentService.deleteById(selected.id);
    if(statusCode == 200){
      // If we removed from DB successfully then remove from UI list
      listItems.removeWhere((item) => item.id == selected.id);
      selected = null;
    } else {
      window.alert("Couldn't finish deleting current item!");
      print("Status code: ${statusCode}");
    }
  }

  // Do other stuff (placeholder event handling)
  void onButton(UIEvent event, dynamic thing) async {
    String cmd = (event.currentTarget as HtmlElement).text.trim();
    print("Button clicked with method ${cmd}");
    event.stopPropagation();
    event.preventDefault();
    switch(cmd){
        case "Details":
            print("Running details flow...");
            // String jsonDetails = await _currentService.details(thing);
            // doSomethingWithDetails(jsonDetails);
            break;
        case "Clone":
            print("Running clone flow...");
            // dynamic clone = await _currentService.clone(thing);
            // listItems.insert(0, thing);
            // selected = thing;
            break;
        default:
            print("ERROR IN FLOW - BAD CMD: $cmd");
    }
  }

}
