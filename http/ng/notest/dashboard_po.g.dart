// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_po.dart';

// **************************************************************************
// PageObjectGenerator
// **************************************************************************

// ignore_for_file: private_collision_in_mixin_application
// ignore_for_file: unused_field, non_constant_identifier_names
// ignore_for_file: overridden_fields, annotate_overrides
class $DashboardPO extends DashboardPO with $$DashboardPO {
  PageLoaderElement $__root__;
  $DashboardPO.create(PageLoaderElement currentContext)
      : $__root__ = currentContext {
    $__root__.addCheckers([]);
  }
  factory $DashboardPO.lookup(PageLoaderSource source) =>
      throw "'lookup' constructor for class "
      "DashboardPO is not generated and can only be used on Page Object "
      "classes that have @CheckTag annotation.";
  static String get tagName =>
      throw '"tagName" is not defined by Page Object "DashboardPO". Requires @CheckTag annotation in order for "tagName" to be generated.';
  String get title {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('DashboardPO', 'title');
    }
    final returnMe = super.title;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('DashboardPO', 'title');
    }
    return returnMe;
  }

  Iterable<String> get heroNames {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('DashboardPO', 'heroNames');
    }
    final returnMe = super.heroNames;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('DashboardPO', 'heroNames');
    }
    return returnMe;
  }

  Future<void> selectHero(int index) {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('DashboardPO', 'selectHero');
    }
    final returnMe = super.selectHero(index);
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('DashboardPO', 'selectHero');
    }
    return returnMe;
  }
}

class $$DashboardPO {
  PageLoaderElement $__root__;
  PageLoaderMouse __mouse__; // ignore: unused_field
  PageLoaderElement get $root => $__root__;
  PageLoaderElement get _title {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('DashboardPO', '_title');
    }
    final element = $__root__.createElement(First(ByCss('h3')), [], []);
    final returnMe = element;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('DashboardPO', '_title');
    }
    return returnMe;
  }

  PageObjectList<PageLoaderElement> get _heroes {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('DashboardPO', '_heroes');
    }
    final returnMe = PageObjectList<PageLoaderElement>(
        $__root__.createList(ByTagName('a'), [], []),
        (PageLoaderElement e) => e);
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('DashboardPO', '_heroes');
    }
    return returnMe;
  }
}
