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
import '../../conf/routes.dart';

import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';

import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_button/material_fab.dart';
import 'package:angular_components/material_icon/material_icon.dart';
import 'package:angular_components/material_expansionpanel/material_expansionpanel.dart';
import 'package:angular_components/material_expansionpanel/material_expansionpanel_auto_dismiss.dart';
import 'package:angular_components/material_expansionpanel/material_expansionpanel_set.dart';
import 'package:angular_components/material_dialog/material_dialog.dart';
import 'package:angular_components/material_progress/material_progress.dart';

import 'package:angular_components/model/action/async_action.dart';
import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';

// ***************
// PROJECT IMPORTS
// ***************
import '../../service/tournament_service.dart';
import '../../service/match_service.dart';
import '../../service/player_service.dart';
import '../../type/list_provider_interface.dart';
import '../../component/detailView/tournament/tournament.template.dart' as tournament_component;
import '../../component/detailView/player/player.template.dart' as player_component;

@Component(
  selector: 'my-itemlist',
  templateUrl: 'type_list_component.html',
  styleUrls: ['type_list_component.css'],
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
    MaterialExpansionPanel,
    MaterialExpansionPanelSet,
    MaterialExpansionPanelAutoDismiss,
    MaterialProgressComponent
  ],
  pipes: [commonPipes],
)
class TypeListComponent implements OnActivate {

  // Default constructor, grab router at init
  TypeListComponent(this._router, this._loader);
  // Router for nav to detail view
  Router _router;
  // Component factory and loader for dynamically loaded content manipulation
  final ComponentLoader _loader;
  ComponentFactory _currentFactory;
  ComponentRef loadedComponent;

  // Hold on to current service and string title
  DetailListService _currentService;
  String _serviceName;
  bool loading = false;

  // List of items from calls to current service
  List <dynamic> listItems = new List();
  // Currently selected item handle
  dynamic selected;

  // Current value for search text-box
  String _searchText = "";
  void updateSearchText(String text) => _searchText = text;

  // Toggle the "New" feature for the current service
  // TODO - Rewrite with type/struct to enforce interface (add/edit)
  String mode = "edit";

  // Toggle the "Delete" modal for confirmation before sending DB request
  bool cancelModalVisible = false;
  bool deleteModalVisible = false;
  Completer<bool> modalCompleter;

  // Reference to our dynamically loaded content's DOM element
  @ViewChild('itemContainer', read: ViewContainerRef)
  ViewContainerRef domContainer;

  // Use the current service to get every item available (NO FILTER)
  Future <void> _getServiceItems() async {
    loading = true;
    listItems = (await _currentService.getAll()) ?? listItems;
    loading = false;
    // TODO - switch to "getShort()" and only return id/name
  }

  // Take current router path and parse into required service, then LOAD
  @override
  void onActivate(_, RouterState current) async {
    // Get current service from router parameters
    _serviceName = getTypeFrom(current.parameters);
    switch (_serviceName) {
      case "tournaments":
        print("Loading tournament service...");
        _currentService = TournamentService();
        _currentFactory = tournament_component.TournamentDetailComponentNgFactory;
        break;
      case "matches":
        print("Loading match service...");
        _currentService = MatchService();
        break;
      case "players":
        print("Loading player service...");
        _currentService = PlayerService();
        _currentFactory = player_component.PlayerDetailComponentNgFactory;
        break;
      default:
        window.alert("Oops, that service doesn't seem to exist!");
        print("Failed to find service... bad load!");
        _router.navigate(RoutePaths.dash.toUrl());
    }
    _getServiceItems();
  }

  // Simple utility to parse service name from router into capitalized (?) value
  String getSectionTitle(bool capital) {
    if (_serviceName == null) {
      return "";
    }
    if (capital) {
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
    loading = true;
    listItems = await _currentService.searchFor(_searchText);
    loading = false;
  }

  // If we are in edit mode, add a new item and open in free UI
  // If we are already in add mode, ignore the button event
  void onAddButton(UIEvent event) async {
    event.stopPropagation();
    event.preventDefault();
    if(mode == "add"){
      return;
    }
    selected = _currentService.getNew();
    listItems.insert(0, selected);
    mode = "add";
  }

  // Handle the cancellation of a panel
  void onCancel(AsyncAction event) async {
    modalCompleter = new Completer();
    event.cancelIf(modalCompleter.future);
    print("Cancel requested...");
    cancelModalVisible = true;
  }
  // Handle the cancellation of a panel
  void onConfirmCancel(bool cancel) {
    print("Cancel confirmed: ${cancel.toString()}");
    // Signal modal that a decision has been made
    modalCompleter.complete(!cancel);
    if(cancel){
      if(mode == "add"){
        mode = "edit";
        print("Removed blank item at root index...");
        listItems.removeAt(0);
      }
      selected = null;
      print("Reset selected item...");
    }
    cancelModalVisible = false;
  }

  // Handle the cancellation of a panel
  void onDelete() {
    print("Delete requested...");
    deleteModalVisible = true;
  }
  // Handle the cancellation of a panel
  void onConfirmDelete() async {
    print("Delete confirmed...");
    // Immediately kill UI element to prevent double click issues
    deleteModalVisible = false;
    int statusCode = await _currentService.deleteById(selected.id);
    if (statusCode == 200) {
      // If we removed from DB successfully then remove from UI list
      listItems.removeWhere((item) => item.id == selected.id);
      selected = null;
    } else {
      window.alert("Couldn't finish deleting current item!");
      print("Status code: ${statusCode}");
    }
  }

  // Handle the saving of a panel - panels will not auto-close on success/fail
  void onSave(AsyncAction event) async {
    print("Save requested...");
    // Get a handle to injected object
    // TODO - "item" is injected from "selected" - ref is possible duplicate
    dynamic loadedItem = loadedComponent.instance.item;
    dynamic itemRef;
    // If adding, attempt to add and insert into list if successful
    if(mode == "add"){
      if(loadedItem != null){
        // Ensure we have an updated object when moving forward
        itemRef = await _currentService.addByObject(loadedItem);
        if(itemRef != null){
          mode = "edit";
          listItems.removeAt(0);
          // Insert new ref for consistency (bad field sets in DB, etc)
          listItems.insert(0, itemRef);
        }
      }
    }
    // If editing, attempt to update existing entry in DB
    else {
      itemRef = await _currentService.updateByObject(loadedItem);
    }
    // If edit/add return null then alert and do nothing.
    if(itemRef == null){
      // Null return from current service is bad operation in connector
      window.alert("Couldn't finish current item save!");
    }
    // Add non-null handled, successful edit/update procedure below
    else {
      int indexPosition = listItems.indexWhere((element)=>element.id == loadedItem.id);
      listItems.removeAt(indexPosition);
      listItems.insert(indexPosition, itemRef);
    }
  }

  // Do other stuff (placeholder event handling)
  void _childButtonListener(String cmd) async {
    print("Child button clicked with method ${cmd}");
    switch (cmd) {
      case "clone":
        print("Running clone flow...");
        break;
      case "delete":
        print("Running delete flow...");
        onDelete();
        break;
      default:
        print("ERROR IN FLOW - BAD CMD: $cmd");
    }
  }

  // If we're loading a new thing then replace the dynamic DOM element
  void changeHandler(bool loading, dynamic thing) {
    if (loading) {
      // Delay long enough for template region to register in DOM
      Timer(Duration(milliseconds: 10), () {
        selected = thing;
        // Get component handle after factory injects into DOM
        loadedComponent = _loader.loadNextToLocation(_currentFactory, domContainer);
        // Set current item for view component
        loadedComponent.instance.item = selected;
        // Set UI locking level
        loadedComponent.instance.lockLevel = (mode == "add" ? 0 : 1);
        // Add a button listener for child callbacks
        loadedComponent.instance.buttonStream.listen(_childButtonListener);
      });
    }
  }

}
