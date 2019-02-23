// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_po.dart';

// **************************************************************************
// PageObjectGenerator
// **************************************************************************

// ignore_for_file: private_collision_in_mixin_application
// ignore_for_file: unused_field, non_constant_identifier_names
// ignore_for_file: overridden_fields, annotate_overrides
class $AppPO extends AppPO with $$AppPO {
  PageLoaderElement $__root__;
  $AppPO.create(PageLoaderElement currentContext) : $__root__ = currentContext {
    $__root__.addCheckers([]);
  }
  factory $AppPO.lookup(PageLoaderSource source) =>
      throw "'lookup' constructor for class "
      "AppPO is not generated and can only be used on Page Object "
      "classes that have @CheckTag annotation.";
  static String get tagName =>
      throw '"tagName" is not defined by Page Object "AppPO". Requires @CheckTag annotation in order for "tagName" to be generated.';
  String get pageTitle {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('AppPO', 'pageTitle');
    }
    final returnMe = super.pageTitle;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('AppPO', 'pageTitle');
    }
    return returnMe;
  }

  Iterable<String> get tabTitles {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('AppPO', 'tabTitles');
    }
    final returnMe = super.tabTitles;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('AppPO', 'tabTitles');
    }
    return returnMe;
  }

  bool get dashboardTabIsActive {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('AppPO', 'dashboardTabIsActive');
    }
    final returnMe = super.dashboardTabIsActive;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('AppPO', 'dashboardTabIsActive');
    }
    return returnMe;
  }

  bool get heroesTabIsActive {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('AppPO', 'heroesTabIsActive');
    }
    final returnMe = super.heroesTabIsActive;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('AppPO', 'heroesTabIsActive');
    }
    return returnMe;
  }

  Future<void> selectTab(int index) {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('AppPO', 'selectTab');
    }
    final returnMe = super.selectTab(index);
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('AppPO', 'selectTab');
    }
    return returnMe;
  }
}

class $$AppPO {
  PageLoaderElement $__root__;
  PageLoaderMouse __mouse__; // ignore: unused_field
  PageLoaderElement get $root => $__root__;
  PageLoaderElement get _h1 {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('AppPO', '_h1');
    }
    final element = $__root__.createElement(ByTagName('h1'), [], []);
    final returnMe = element;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('AppPO', '_h1');
    }
    return returnMe;
  }

  PageLoaderElement get _myDashboard {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('AppPO', '_myDashboard');
    }
    final element = $__root__.createElement(ByTagName('my-dashboard'), [], []);
    final returnMe = element;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('AppPO', '_myDashboard');
    }
    return returnMe;
  }

  PageLoaderElement get _myHeroes {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('AppPO', '_myHeroes');
    }
    final element = $__root__.createElement(ByTagName('my-heroes'), [], []);
    final returnMe = element;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('AppPO', '_myHeroes');
    }
    return returnMe;
  }

  PageObjectList<PageLoaderElement> get _tabLinks {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('AppPO', '_tabLinks');
    }
    final returnMe = PageObjectList<PageLoaderElement>(
        $__root__.createList(ByCss('nav a'), [], []),
        (PageLoaderElement e) => e);
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('AppPO', '_tabLinks');
    }
    return returnMe;
  }
}
