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
import '../../routing/routes.dart';

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
import '../../service/event_service.dart';
import '../../service/tournament_service.dart';
import '../../service/stage_service.dart';
import '../../service/round_service.dart';
import '../../service/game_service.dart';
import '../../service/match_service.dart';
import '../../service/result_service.dart';
import '../../service/entrant_service.dart';
import '../../service/user_service.dart';
import '../../component/detailView/event/event.template.dart' as event_component;
import '../../component/detailView/tournament/tournament.template.dart' as tournament_component;
import '../../component/detailView/stage/stage.template.dart' as stage_component;
import '../../component/detailView/match/match.template.dart' as match_component;
import '../../component/detailView/result/result.template.dart' as result_component;
import '../../component/detailView/round/round.template.dart' as round_component;
import '../../component/detailView/game/game.template.dart' as game_component;
import '../../component/detailView/entrant/entrant.template.dart' as entrant_component;
import '../../component/detailView/user/user.template.dart' as user_component;

import '../../type/list_provider_interface.dart';
import '../../type/advanceable_interface.dart';

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

  /*
  **************************************************
    HANDLE CONSTRUCTION AND SETUP ITEM LIST
  **************************************************
  */
  // Default constructor, grab router at init
  TypeListComponent(this._router, this._loader);
  // Router for nav to detail view
  Router _router;
  final ComponentLoader _loader;

  // List of items from calls to current service
  List <dynamic> listItems = new List();
  // Currently selected item handle
  dynamic selected;

  /*
  **************************************************
    HANDLE DYNAMIC SERVICE AND FACTORY CREATION
  **************************************************
  */
  // Component factory and loader for dynamically loaded content manipulation
  ComponentFactory _currentFactory;
  // Hold on to current service and string title
  DetailListService _currentService;
  String _serviceName;
  // Simple utility to parse service name from router into capitalized (?) value
  String getServiceTitle(bool capital) {
    if (_serviceName == null) {
      return "";
    }
    if (capital) {
      return _serviceName[0].toUpperCase() + _serviceName.substring(1);
    } else {
      return _serviceName;
    }
  }
  // Use the current service to get every item available (NO FILTER)
  bool loading = false;
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
    bool _serviceLoaded = true;
    switch (_serviceName) {
      case "events":
        print("Loading event service...");
        _currentService = EventService();
        _currentFactory = event_component.EventDetailComponentNgFactory;
        break;
      case "tournaments":
        print("Loading tournament service...");
        _currentService = TournamentService();
        _currentFactory = tournament_component.TournamentDetailComponentNgFactory;
        break;
      case "stages":
        print("Loading stage service...");
        _currentService = StageService();
        _currentFactory = stage_component.StageDetailComponentNgFactory;
        break;
      case "matches":
        print("Loading match service...");
        _currentService = MatchService();
        _currentFactory = match_component.MatchDetailComponentNgFactory;
        break;
      case "results":
        print("Loading result service...");
        _currentService = ResultService();
        _currentFactory = result_component.ResultDetailComponentNgFactory;
        break;
      case "rounds":
        print("Loading round service...");
        _currentService = RoundService();
        _currentFactory = round_component.RoundDetailComponentNgFactory;
        break;
      case "games":
        print("Loading game service...");
        _currentService = GameService();
        _currentFactory = game_component.GameDetailComponentNgFactory;
        break;
      case "entrants":
        print("Loading entrant service...");
        _currentService = EntrantService();
        _currentFactory = entrant_component.EntrantDetailComponentNgFactory;
        break;
      case "users":
        print("Loading user service...");
        _currentService = UserService();
        _currentFactory = user_component.UserDetailComponentNgFactory;
        break;
      default:
        window.alert("Oops, that service doesn't seem to exist!");
        print("Failed to find service... bad load!");
        _serviceLoaded = false;
        _router.navigate(RoutePaths.dash.toUrl());
    }
    if(_serviceLoaded) _getServiceItems();
  }

  /*
  **************************************************
    HANDLE NEW ITEM CREATION
  **************************************************
  */
  // Toggle the "New" feature for the current service
  // TODO - Rewrite with type/struct to enforce interface (add/edit)
  String mode = "edit";
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

  /*
  **************************************************
    HANDLE TEXT SEARCH FOR CURRENT SERVICE
  **************************************************
  */
  // Current value for search text-box
  String _searchText = "";
  void updateSearchText(String text) => _searchText = text;
  // Initiate a text search on current service
  void onSearch(Event event) async {
    print("Search initiated...");
    print("Current value is: ${_searchText}");
    event.stopPropagation();
    event.preventDefault();
    loading = true;
    listItems = await _currentService.searchFor(_searchText);
    loading = false;
  }

  /*
  **************************************************
    HANDLE PANEL ACTION AND MODAL STATE
  **************************************************
  */
  // Toggle the modals before confirming
  bool cancelModalVisible = false;
  Completer<bool> modalCompleter;
  // Handle the cancellation of a panel
  void onCancel(AsyncAction event) async {
    // Set up a future observable and add as resolver for cancel event
    modalCompleter = new Completer();
    event.cancelIf(modalCompleter.future);
    print("Cancel requested...");
    cancelModalVisible = true;
  }
  // Handle the cancellation of a panel
  void onConfirmCancel(bool cancel) {
    print("Cancel confirmed: ${cancel.toString()}");
    // Complete observable with action value
    modalCompleter.complete(!cancel);
    // Reset app state if add cancelled
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
  // Handle the saving of a panel - panels will not auto-close on success/fail
  void onSave(AsyncAction event) async {
    print("Save requested...");
    // Get a handle to injected object
    // TODO - "item" is injected from "selected" - ref is possible duplicate
    dynamic loadedItem = loadedComponent.instance.item;
    dynamic newItem;
    // If adding, attempt to add and insert into list if successful
    if(mode == "add"){
      // Ensure we have an updated object when moving forward
      newItem = await _currentService.addByObject(loadedItem);
    }
    // If editing, attempt to update existing entry in DB
    else {
      newItem = await _currentService.updateByObject(loadedItem);
    }
    // If edit/add return null then alert and do nothing.
    if(newItem == null){
      // Null return from current service is bad operation in connector
      window.alert("Couldn't finish current item save!");
    }
    // Add non-null handled, successful edit/update procedure below
    else {
      mode = "edit";
      int indexPosition = listItems.indexWhere((element)=>element.id == loadedItem.id);
      listItems.removeAt(indexPosition);
      listItems.insert(indexPosition, newItem);
    }
  }

  /*
  **************************************************
    HANDLE TRACKING OF OPENED EXPANSION PANEL
  **************************************************
  */
  // Reference to our dynamically loaded content's DOM element
  @ViewChild('itemContainer', read: ViewContainerRef)
  ViewContainerRef domContainer;
  // Dynamic reference to newly inflated panel, on creation
  ComponentRef loadedComponent;
  // If we're loading a new panel then replace the dynamic DOM element
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

  /*
  **************************************************
    HANDLE CHILD PANEL ACTIONS FROM BUTTON STREAM
  **************************************************
  */
  // Do stuff when children request it
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
      case "advance":
        print("Running advance flow...");
        await onAdvance();
        break;
      default:
        print("ERROR IN FLOW - BAD CMD: $cmd");
    }
  }
  bool deleteModalVisible = false;
  // Handle the deletion of an item
  void onDelete() {
    print("Delete requested...");
    deleteModalVisible = true;
  }
  // Handle the deletion panel actions
  void onConfirmDelete() async {
    print("Delete confirmed...");
    // Immediately kill UI element to prevent double click issues
    deleteModalVisible = false;
    if (await _currentService.deleteById(selected.id)) {
      // If we removed from DB successfully then remove from UI list
      listItems.removeWhere((item) => item.id == selected.id);
      selected = null;
    } else {
      window.alert("Couldn't finish deleting current item!");
    }
  }
  // Move stage/round to next iteration
  void onAdvance() async {
    if(_currentService is Advanceable){
      bool success = await (_currentService as Advanceable).advance(selected.id);
      print("Advancement ok? --> ${success.toString()}");
    } else {
      // This is a bad error, if triggered then some architecture is broken
      print("Not an advanceable service/item!");
    }
  }
}
