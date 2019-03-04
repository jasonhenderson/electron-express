import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../../type/section.dart';
import '../../data/dash_sections.dart';
import '../../conf/routes.dart';

@Component(
  selector: 'tr-dashboard',
  templateUrl: 'dashboard_component.html',
  styleUrls: ['dashboard_component.css'],
  directives: [coreDirectives, routerDirectives],
  exports: [
    RoutePaths,
    Routes
  ]
)
class DashboardComponent{
  DashboardComponent();
  List<Section> sections = dashSections;
  String getSectionLink(String section){
    return RoutePaths.list.toUrl(parameters: {"type": section.toLowerCase()});
  }
}
