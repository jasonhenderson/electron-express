import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';

import 'src/service/section_service.dart';
import 'src/service/tournament_service.dart';
import 'src/conf/routes.dart';

@Component(
  selector: 'tr-app',
  template: '''
    <h1>{{title}}</h1>
    <nav>
      <a [routerLink]="RoutePaths.dashboard.toUrl()"
         [routerLinkActive]="'active'">Dashboard</a>
      <a [routerLink]="RoutePaths.blockchain.toUrl()"
         [routerLinkActive]="'active'">Blockchain</a>
      <a [routerLink]="RoutePaths.tournaments.toUrl()"
         [routerLinkActive]="'active'">Tournaments</a>
    </nav>
    <router-outlet [routes]="Routes.all"></router-outlet>
  ''',
  styleUrls: ['app_component.css'],
  directives: [routerDirectives],
  providers: [ClassProvider(SectionService), ClassProvider(TournamentService)],
  exports: [RoutePaths, Routes],
)
class AppComponent {
  final title = 'Tournament Runner';
}
