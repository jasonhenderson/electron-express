import 'package:angular/angular.dart';

import 'package:angular_router/angular_router.dart';

import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/model/menu/menu.dart';

import '../raisableMenu/raisable_menu_component.dart';

import '../../routing/routes.dart';

@Component(
  selector: 'admin-comp',
  templateUrl: 'admin_component.html',
  styleUrls: ['admin_component.css'],
  directives: [
    routerDirectives,
    MaterialMenuComponent,
    RaisableMenuComponent,
    MaterialIconComponent,
    MaterialButtonComponent
  ]
)
class AdminComponent implements OnInit {
  // Get a handle to current router object when class is constructed
  final Router _router;
  AdminComponent(this._router);

  // Navigation menu for sub-component
  MenuModel<MenuItem> adminMenu;

  // Navigate back to the dashboard, using the current router object
  void goHome(){
    _router.navigate(RoutePaths.dash.toUrl());
  }

  void ngOnInit(){
    // Fill menu on init, since we need to attach to the current router object
    adminMenu = MenuModel<MenuItem>([
      MenuItemGroup<MenuItem>([
        MenuItem('Tournaments', action: () => _router.navigate(RoutePaths.list.toUrl())),
        MenuItem('Matches', action: () => _router.navigate(RoutePaths.list.toUrl())),
        MenuItem('Players', action: () => _router.navigate(RoutePaths.list.toUrl()))
      ])
    ]);
  }

}
