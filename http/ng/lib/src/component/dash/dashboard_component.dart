import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../../type/dash_section.dart';
import 'sections.dart';
import '../../routing/routes.dart';

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
  List<DashSection> sections = dashSections;
  String getSectionLink(DashSection section){
    // TODO - Find a better place in the logic chain for this
    // Meant to allow auto-assignment from ngFor where sections are not listable
    switch(section.name.toLowerCase()){
      case "admin":
        return RoutePaths.admin.toUrl();
        break;
    }
    return RoutePaths.list.toUrl(parameters: {"type": section.name.toLowerCase()});
  }
}
