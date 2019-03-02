import 'package:angular/angular.dart';

import 'package:angular_router/angular_router.dart';

import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_menu/dropdown_menu.dart';
import 'package:angular_components/material_menu/material_menu.dart';
import 'package:angular_components/model/menu/menu.dart';

import 'src/component/raisableMenu/raisable_menu_component.dart';

import 'package:http/http.dart' as http;
import 'dart:html';

import 'src/service/tournament_service.dart';
import 'src/conf/routes.dart';

@Component(
  selector: 'tr-app',
  template: '''
    <div class="appcontainer">
        <div class="hrdiv">
            <material-button
              [raised]="true"
              (click)="goHome()" >Dashboard</material-button>
            <raisable-menu id="sectionmenu"
                [menu]="navMenu"
                [raised]="true" >
                <section menu-button>
                    Services
                    <material-icon icon="arrow_drop_down" size="medium" baseline></material-icon>
                </section>
            </raisable-menu>
            <material-button
              [raised]="true"
              style="float: right;"
              (click)="openUiWindow()" >Open ChainUI</material-button>
        <br>
        <br>
        </div>
        <router-outlet [routes]="Routes.all"></router-outlet>
    </div>
  ''',
  styleUrls: ['app_component.css'],
  directives: [
    routerDirectives,
    MaterialMenuComponent,
    RaisableMenuComponent,
    DropdownMenuComponent,
    MaterialIconComponent,
    MaterialButtonComponent
  ],
  providers: [
    ClassProvider(TournamentService),
    materialProviders
  ],
  exports: [
    RoutePaths,
    Routes
  ],
)
class AppComponent implements OnInit {
  final Router _router;
  AppComponent(this._router);
  final title = 'Tournament Runner';
  void openUiWindow(){
    // Put in a call to the Electron host to trigger some upstream function
    http.get("http://localhost:3000/open/BCUI")
    .then((response) {
        print("Response status: ${response.statusCode}");
    });
  }
  void goHome(){
    _router.navigate(RoutePaths.dashboard.toUrl());
  }
  MenuModel<MenuItem> navMenu;
  void ngOnInit(){
    // Build menu
    navMenu = MenuModel<MenuItem>([
      MenuItemGroup<MenuItem>([
        MenuItem('Tournaments', action: () => _router.navigate(RoutePaths.tournaments.toUrl())),
        MenuItem('Matches', action: () => _router.navigate(RoutePaths.matches.toUrl())),
        MenuItem('Players', action: () => _router.navigate(RoutePaths.players.toUrl()))
      ])
    ]);
  }

}
