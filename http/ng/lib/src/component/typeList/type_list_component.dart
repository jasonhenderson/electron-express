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

@ Component(
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
  ],
  pipes: [commonPipes], )
  class TypeListComponent implements OnActivate {
    // Router for nav to detail view
    Router _router;
    // Hold on to current service and string title
    DetailListService _currentService;
    String _serviceName;
    // Component factory and loader for dynamically loaded content manipulation
    final ComponentLoader _loader;
    ComponentFactory _currentFactory;

    // List of items from calls to current service
    List < dynamic > listItems = new List();
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
    AsyncAction cancelModalAction;
    Completer<bool> cancelModalCompleter;
    // Reference to our dynamically loaded content's DOM element
    @ViewChild('itemContainer', read: ViewContainerRef)
    ViewContainerRef domContainer;

    // Default constructor, grab router at init
    TypeListComponent(this._router, this._loader);

    // Use the current service to get every item available (NO FILTER)
    Future < void > _getServiceItems() async {
      print("Updating with old length: ${listItems.length.toString()}");
      List<dynamic> newList = await _currentService.getAll();
      print("Updating with new length: ${newList.length.toString()}");
      listItems = newList;
      print("Updated to new length: ${listItems.length.toString()}");
      // TODO - switch to "getShort()" and only return id/name
    }

    // Take current router path and parse into required service, then LOAD
    @ override
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
        break;
        default:
        window.alert("Oops, that service doesn't seem to exist!");
        print("Failed to find service... bad load!");
        _router.navigate(RoutePaths.dash.toUrl());
        return;
        break;
      }
      _getServiceItems();
      print("Done with service load!");
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
    void onSearch(Event event)async {
      print("Search initiated...");
      print("Current value is: ${_searchText}");
      event.stopPropagation();
      event.preventDefault();
      listItems = await _currentService.searchFor(_searchText);
    }

    // If we are in edit mode, add a new item and open in free UI
    // If we are already in add mode, ignore the button event
    void onAddButton(UIEvent event)async {
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
      cancelModalCompleter = new Completer();
      event.cancelIf(cancelModalCompleter.future);
      print("Cancel requested...");
      cancelModalVisible = true;
    }
    // Handle the cancellation of a panel
    void onConfirmCancel(bool cancel) {
      print("Cancel confirmed: ${cancel.toString()}");
      cancelModalCompleter.complete(!cancel);
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
    void onSave(AsyncAction event) async {
      print("Save requested...");
      if(mode == "add"){
        mode = "edit";
        await _getServiceItems();
      }
    }

    // // Extinguish the current event and attempt to confirm DELETE with modal
    // void onDelete() {
    //   print("Running delete flow...");
    //   deleteModalVisible = true;
    // }
    //
    // // Modal confirms DELETE, use current selection ID and feed to current service
    // void onConfirmDelete()async {
    //   deleteModalVisible = false;
    //   int statusCode = 200; // await _currentService.deleteById(selected.id);
    //   if (statusCode == 200) {
    //     // If we removed from DB successfully then remove from UI list
    //     listItems.removeWhere((item) => item.id == selected.id);
    //     selected = null;
    //   } else {
    //     window.alert("Couldn't finish deleting current item!");
    //     print("Status code: ${statusCode}");
    //   }
    // }

    // Do other stuff (placeholder event handling)
    void onButton(UIEvent event, dynamic thing)async {
      String cmd = (event.currentTarget as HtmlElement).text.trim();
      print("Button clicked with method ${cmd}");
      event.stopPropagation();
      event.preventDefault();
      switch (cmd) {
        case "Details":
        print("Running details flow...");
        // _router.navigate(RoutePaths.detail.toUrl(parameters: {
        //   "id": thing.id.toString(),
        //   "function": "details",
        //   "type": _serviceName
        // }));
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

    // If we're loading a new thing then replace the dynamic DOM element
    void changeHandler(bool loading, dynamic thing) {
      if (loading) {
        // Delay long enough for template region to register in DOM
        Timer(Duration(milliseconds: 10), () {
          selected = thing;
          print("Running delayed injection method...");
          // Get component handle after factory injects into DOM
          ComponentRef component = _loader.loadNextToLocation(_currentFactory, domContainer);
          // Set current item for view component
          print("Injecting thing with stuff...");
          component.instance.item = thing;
          component.instance.lockLevel = (mode == "add" ? 0 : 1);
          print("Injecting thing finished...");
        });
      }
    }

  }
