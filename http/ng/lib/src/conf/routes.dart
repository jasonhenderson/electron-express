import 'package:angular_router/angular_router.dart';

import 'route_paths.dart';
import '../component/dash/dashboard_component.template.dart' as dashboard_template;
import '../component/detailList/detail_list_component.template.dart' as detaillist_template;
import '../component/admin/admin_component.template.dart' as admin_template;

export 'route_paths.dart';

class Routes {
  static final dashboard = RouteDefinition(
    routePath: RoutePaths.dashboard,
    component: dashboard_template.DashboardComponentNgFactory,
  );
  static final tournaments = RouteDefinition(
    routePath: RoutePaths.tournaments,
    component: detaillist_template.DetailListComponentNgFactory,
  );
  static final matches = RouteDefinition(
    routePath: RoutePaths.matches,
    component: detaillist_template.DetailListComponentNgFactory,
  );
  static final players = RouteDefinition(
    routePath: RoutePaths.players,
    component: detaillist_template.DetailListComponentNgFactory,
  );
  static final admin = RouteDefinition(
    routePath: RoutePaths.admin,
    component: admin_template.AdminComponentNgFactory,
  );

  static final all = <RouteDefinition>[
    dashboard,
    tournaments,
    matches,
    players,
    admin,
    RouteDefinition.redirect(
      path: '',
      redirectTo: RoutePaths.dashboard.toUrl(),
    ),
  ];
}
