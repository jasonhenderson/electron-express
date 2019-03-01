import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import '../../type/section.dart';
import '../../data/dash_sections.dart';

@Component(
  selector: 'tr-dashboard',
  templateUrl: 'dashboard_component.html',
  styleUrls: ['dashboard_component.css'],
  directives: [coreDirectives, routerDirectives],
)
class DashboardComponent{
  List<Section> sections = dashSections;
}
