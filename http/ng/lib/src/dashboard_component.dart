import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'section.dart';
import 'section_service.dart';
import 'route_paths.dart';

@Component(
  selector: 'tr-dashboard',
  templateUrl: 'dashboard_component.html',
  styleUrls: ['dashboard_component.css'],
  directives: [coreDirectives, routerDirectives],
)
class DashboardComponent implements OnInit {
  List<Section> sections;

  final SectionService _sectionService;

  DashboardComponent(this._sectionService);

  @override
  void ngOnInit() async {
    sections = (await _sectionService.getAll()).toList();
  }
}
