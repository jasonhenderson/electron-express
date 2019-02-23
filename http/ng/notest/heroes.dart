@TestOn('browser')

import 'package:angular/angular.dart';
import 'package:angular_router/angular_router.dart';
import 'package:angular_test/angular_test.dart';
import 'package:angular_tour_of_heroes/src/hero_list_component.dart';
import 'package:angular_tour_of_heroes/src/hero_list_component.template.dart'
    as ng;
import 'package:angular_tour_of_heroes/src/hero_service.dart';
import 'package:angular_tour_of_heroes/src/route_paths.dart';
import 'package:mockito/mockito.dart';
import 'package:pageloader/html.dart';
import 'package:test/test.dart';

import 'heroes.template.dart' as self;
import 'heroes_po.dart';
import 'utils.dart';

NgTestFixture<HeroListComponent> fixture;
HeroesPO po;

@GenerateInjector([
  ClassProvider(HeroService),
  ClassProvider(Router, useClass: MockRouter),
])
final InjectorFactory rootInjector = self.rootInjector$Injector;

void main() {
  final injector = InjectorProbe(rootInjector);
  final testBed = NgTestBed.forComponent<HeroListComponent>(
      ng.HeroListComponentNgFactory,
      rootInjector: injector.factory);

  setUp(() async {
    fixture = await testBed.create();
    final context =
        HtmlPageLoaderElement.createFromElement(fixture.rootElement);
    po = HeroesPO.create(context);
  });

  tearDown(disposeAnyRunningTest);

  group('Basics:', basicTests);
  group('Selected hero:', () => selectedHeroTests(injector));
}

void basicTests() {
  test('title', () {
    expect(po.title, 'Heroes');
  });

  test('hero count', () {
    expect(po.heroes.length, 10);
  });

  test('no selected hero', () {
    expect(po.selected, null);
  });
}

void selectedHeroTests(InjectorProbe injector) {
  const targetHero = {'id': 15, 'name': 'Magneta'};

  setUp(() async {
    await po.selectHero(4);
  });

  test('is selected', () {
    expect(po.selected, targetHero);
  });

  test('show mini-detail', () {
    expect(po.myHeroNameInUppercase, equalsIgnoringCase(targetHero['name']));
  });

  test('go to detail', () async {
    await po.gotoDetail();
    final mockRouter = injector.get<MockRouter>(Router);
    final c = verify(mockRouter.navigate(captureAny));
    expect(c.captured.single,
        RoutePaths.hero.toUrl(parameters: {idParam: '${targetHero['id']}'}));
  });

  test('select another hero', () async {
    await po.selectHero(0);
    final heroData = {'id': 11, 'name': 'Mr. Nice'};
    expect(await po.selected, heroData);
  });
}
