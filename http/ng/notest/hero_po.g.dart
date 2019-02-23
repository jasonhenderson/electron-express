// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hero_po.dart';

// **************************************************************************
// PageObjectGenerator
// **************************************************************************

// ignore_for_file: private_collision_in_mixin_application
// ignore_for_file: unused_field, non_constant_identifier_names
// ignore_for_file: overridden_fields, annotate_overrides
class $HeroDetailPO extends HeroDetailPO with $$HeroDetailPO {
  PageLoaderElement $__root__;
  $HeroDetailPO.create(PageLoaderElement currentContext)
      : $__root__ = currentContext {
    $__root__.addCheckers([]);
  }
  factory $HeroDetailPO.lookup(PageLoaderSource source) =>
      throw "'lookup' constructor for class "
      "HeroDetailPO is not generated and can only be used on Page Object "
      "classes that have @CheckTag annotation.";
  static String get tagName =>
      throw '"tagName" is not defined by Page Object "HeroDetailPO". Requires @CheckTag annotation in order for "tagName" to be generated.';
  Map get heroFromDetails {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('HeroDetailPO', 'heroFromDetails');
    }
    final returnMe = super.heroFromDetails;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('HeroDetailPO', 'heroFromDetails');
    }
    return returnMe;
  }

  Future<void> clear() {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('HeroDetailPO', 'clear');
    }
    final returnMe = super.clear();
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('HeroDetailPO', 'clear');
    }
    return returnMe;
  }

  Future<void> type(String s) {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('HeroDetailPO', 'type');
    }
    final returnMe = super.type(s);
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('HeroDetailPO', 'type');
    }
    return returnMe;
  }

  Future<void> back() {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('HeroDetailPO', 'back');
    }
    final returnMe = super.back();
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('HeroDetailPO', 'back');
    }
    return returnMe;
  }
}

class $$HeroDetailPO {
  PageLoaderElement $__root__;
  PageLoaderMouse __mouse__; // ignore: unused_field
  PageLoaderElement get $root => $__root__;
  PageLoaderElement get _title {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('HeroDetailPO', '_title');
    }
    final element = $__root__.createElement(First(ByCss('div h2')), [], []);
    final returnMe = element;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('HeroDetailPO', '_title');
    }
    return returnMe;
  }

  PageLoaderElement get _id {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('HeroDetailPO', '_id');
    }
    final element = $__root__.createElement(First(ByCss('div div')), [], []);
    final returnMe = element;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('HeroDetailPO', '_id');
    }
    return returnMe;
  }

  PageLoaderElement get _input {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('HeroDetailPO', '_input');
    }
    final element = $__root__.createElement(ByTagName('input'), [], []);
    final returnMe = element;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('HeroDetailPO', '_input');
    }
    return returnMe;
  }

  PageLoaderElement get _button {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('HeroDetailPO', '_button');
    }
    final element = $__root__.createElement(ByTagName('button'), [], []);
    final returnMe = element;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('HeroDetailPO', '_button');
    }
    return returnMe;
  }
}
