import 'package:angular_router/angular_router.dart';

import 'route_paths.dart';
import '../component/dash/dashboard_component.template.dart' as dashboard_template;
import '../component/typeList/type_list_component.template.dart' as type_list_template;
import '../component/detailView/detail_view_component.template.dart' as type_detail_template;
import '../component/admin/admin_component.template.dart' as admin_template;

export 'route_paths.dart';

class Routes {
  static final dashboard = RouteDefinition(
    routePath: RoutePaths.dash,
    component: dashboard_template.DashboardComponentNgFactory,
  );
  static final list = RouteDefinition(
    routePath: RoutePaths.list,
    component: type_list_template.TypeListComponentNgFactory,
  );
  static final detail = RouteDefinition(
    routePath: RoutePaths.detail,
    component: type_detail_template.DetailViewComponentNgFactory
  );
  static final admin = RouteDefinition(
    routePath: RoutePaths.admin,
    component: admin_template.AdminComponentNgFactory,
  );

  static final all = <RouteDefinition>[
    dashboard,
    list,
    detail,
    admin,
    RouteDefinition.redirect(
      path: '',
      redirectTo: RoutePaths.dash.toUrl(),
    ),
  ];
}
