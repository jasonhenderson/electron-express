import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_button/material_button.dart';

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
                materialInputDirectives
              ],
  pipes: [commonPipes],
)
class DetailListComponent implements OnInit, OnActivate {
  DetailListService _currentService;
  String _serviceName;
  List<dynamic> listItems;
  dynamic selected;
  String _searchText = "";

  DetailListComponent();

  Future<void> _getServiceItems() async {
    listItems = await _currentService.getAll();
  }

  void ngOnInit(){
   print("Init finished");
  }

  @override
  void onActivate(_, RouterState current) async {
    print("Router state: $current");
    print("Router path:");
    print(current.routePath);
    _serviceName = current.routePath.path;
    print("Service : $_serviceName");
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
        print("Failed to find service... bad load!");
        break;
    }
     _getServiceItems();
    print("Done with service load!");
  }

  void gotoDetail(){
    print("NAME, ID, SERVICE:");
    print('${selected.name}, ${selected.id}, ${_currentService.getName()}');
    window.alert("${selected.name}, ${selected.id}, ${_currentService.getName()}");
  }

  String getSectionTitle(bool capital) {
    if(_serviceName == null){
        return "";
    }
    if(capital){
        return _serviceName[0].toUpperCase() + _serviceName.substring(1);
    } else {
        return _serviceName ?? "";
    }
  }
  void onSelect(dynamic item) => selected = item;

  void updateSearchText(String text){
    _searchText = text;
  }
  void onSearch(Event event){
    print("Search initiated...");
    print("Current value is: ${_searchText}");
    event.stopPropagation();
    event.preventDefault();
  }

  void onButton(UIEvent event, String name){
    String cmd = (event.currentTarget as HtmlElement).text.trim();
    print("Button clicked with method ${cmd}");
    print("Button clicked for name: ${name}");
    event.stopPropagation();
    event.preventDefault();
    switch(cmd){
        case "Details":
            print("Running details flow...");
            break;
        case "Clone":
            print("Running clone flow...");
            break;
        case "Delete":
            print("Running delete flow...");
            break;
        default:
            print("ERROR IN FLOW - BAD CMD: $cmd");
    }
  }

}
