import 'package:angular/angular.dart';

import 'package:angular_router/angular_router.dart';

import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/model/menu/menu.dart';

import 'src/component/raisableMenu/raisable_menu_component.dart';

import 'package:http/http.dart' as http;

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
            <raisable-menu
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
  // Get a handle to current router object when class is constructed
  final Router _router;
  AppComponent(this._router);

  // Navigation menu for sub-component
  MenuModel<MenuItem> navMenu;

  // Function call to open second window in Electron - see host application
  void openUiWindow(){
    // Place request as per router config in Electron host
    http.get("http://localhost:3000/open/BCUI")
    .then((response) {
        // status 200 is ok, 201 is error from Electron host
        print("Response status: ${response.statusCode}");
    });
  }

  // Navigate back to the dashboard, using the current router object
  void goHome(){
    _router.navigate(RoutePaths.dash.toUrl());
  }

  void ngOnInit(){
    print("Filling menu...");
    // Fill menu on init, since we need to attach to the current router object
    navMenu = MenuModel<MenuItem>([
      MenuItemGroup<MenuItem>([
        MenuItem('Tournaments', action: () =>
          _router.navigate(RoutePaths.list
                            .toUrl(parameters: {
                              "type": "tournaments",
                            }))
        ), // END OF ITEM
        MenuItem('Matches', action: () =>
          _router.navigate(RoutePaths.list
                            .toUrl(parameters: {
                              "type": "matches",
                            }))
        ), // END OF ITEM
        MenuItem('Players', action: () =>
          _router.navigate(RoutePaths.list
                            .toUrl(parameters: {
                              "type": "players",
                            }))
        ), // END OF ITEM
      ])
    ]);
    print("Done...");
  }

}
