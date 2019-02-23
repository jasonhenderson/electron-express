import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../../service/tournament_service.dart';
import '../../type/list_provider_interface.dart';

@Component(
  selector: 'my-itemlist',
  templateUrl: 'detail_list_component.html',
  styleUrls: ['detail_list_component.css'],
  directives: [coreDirectives],
  pipes: [commonPipes],
)
class DetailListComponent implements OnInit, OnActivate {
  DetailListService _currentService;
  String _serviceName;
  List<dynamic> listItems;
  dynamic selected;

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
  }

  void gotoDetail(){
    print("NAME, ID, SERVICE:");
    print('${selected.name}, ${selected.id}, ${_currentService.getName()}');
  }

  String getSectionTitle() => _serviceName;
  void onSelect(dynamic item) => selected = item;

}
