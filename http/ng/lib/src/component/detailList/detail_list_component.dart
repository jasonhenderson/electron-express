import 'dart:async';
import 'dart:html';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';

import '../../service/tournament_service.dart';
import '../../type/list_provider_interface.dart';

@Component(
  selector: 'my-itemlist',
  templateUrl: 'detail_list_component.html',
  styleUrls: ['detail_list_component.css'],
  directives: [
                coreDirectives,
                formDirectives
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
    print("Trying to get section title...");
    if(_serviceName == null){
        print("Empty return...");
        return "";
    }
    if(capital){
        print("Capitalizing service name...");
        return _serviceName[0].toUpperCase() + _serviceName.substring(1);
    } else {
        print("Raw service name...");
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

  void onButton(Event event, String name){
    String cmd = (event.currentTarget as ButtonElement).text;
    print("Button clicked with method ${cmd}");
    print("Button clicked for name: ${name}");
    event.stopPropagation();
    event.preventDefault();
    switch(cmd){
        case "Details":{
            print("Running details flow...");
            break;
        }
        case "Clone":{
            print("Running clone flow...");
            break;
        }
        case "Delete":{
            print("Running delete flow...");
            break;
        }
        default:{
            print("ERROR IN FLOW - BAD CMD: $cmd");
        }
    }
  }

}
