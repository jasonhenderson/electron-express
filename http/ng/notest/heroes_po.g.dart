// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'heroes_po.dart';

// **************************************************************************
// PageObjectGenerator
// **************************************************************************

// ignore_for_file: private_collision_in_mixin_application
// ignore_for_file: unused_field, non_constant_identifier_names
// ignore_for_file: overridden_fields, annotate_overrides
class $HeroesPO extends HeroesPO with $$HeroesPO {
  PageLoaderElement $__root__;
  $HeroesPO.create(PageLoaderElement currentContext)
      : $__root__ = currentContext {
    $__root__.addCheckers([]);
  }
  factory $HeroesPO.lookup(PageLoaderSource source) =>
      throw "'lookup' constructor for class "
      "HeroesPO is not generated and can only be used on Page Object "
      "classes that have @CheckTag annotation.";
  static String get tagName =>
      throw '"tagName" is not defined by Page Object "HeroesPO". Requires @CheckTag annotation in order for "tagName" to be generated.';
  String get title {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('HeroesPO', 'title');
    }
    final returnMe = super.title;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('HeroesPO', 'title');
    }
    return returnMe;
  }

  Iterable<Map> get heroes {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('HeroesPO', 'heroes');
    }
    final returnMe = super.heroes;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('HeroesPO', 'heroes');
    }
    return returnMe;
  }

  Map get selected {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('HeroesPO', 'selected');
    }
    final returnMe = super.selected;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('HeroesPO', 'selected');
    }
    return returnMe;
  }

  String get myHeroNameInUppercase {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('HeroesPO', 'myHeroNameInUppercase');
    }
    final returnMe = super.myHeroNameInUppercase;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('HeroesPO', 'myHeroNameInUppercase');
    }
    return returnMe;
  }

  Future<void> selectHero(int index) {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('HeroesPO', 'selectHero');
    }
    final returnMe = super.selectHero(index);
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('HeroesPO', 'selectHero');
    }
    return returnMe;
  }

  Future<void> gotoDetail() {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('HeroesPO', 'gotoDetail');
    }
    final returnMe = super.gotoDetail();
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('HeroesPO', 'gotoDetail');
    }
    return returnMe;
  }

  Map<String, dynamic> _heroDataFromLi(String liText) {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('HeroesPO', '_heroDataFromLi');
    }
    final returnMe = super._heroDataFromLi(liText);
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('HeroesPO', '_heroDataFromLi');
    }
    return returnMe;
  }
}

class $$HeroesPO {
  PageLoaderElement $__root__;
  PageLoaderMouse __mouse__; // ignore: unused_field
  PageLoaderElement get $root => $__root__;
  PageLoaderElement get _title {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('HeroesPO', '_title');
    }
    final element = $__root__.createElement(First(ByCss('h2')), [], []);
    final returnMe = element;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('HeroesPO', '_title');
    }
    return returnMe;
  }

  PageLoaderElement get _selected {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('HeroesPO', '_selected');
    }
    final element =
        $__root__.createElement(ByTagName('li'), [WithClass('selected')], []);
    final returnMe = element;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('HeroesPO', '_selected');
    }
    return returnMe;
  }

  PageLoaderElement get _miniDetailHeading {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('HeroesPO', '_miniDetailHeading');
    }
    final element = $__root__.createElement(First(ByCss('div h2')), [], []);
    final returnMe = element;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('HeroesPO', '_miniDetailHeading');
    }
    return returnMe;
  }

  PageLoaderElement get _gotoDetail {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('HeroesPO', '_gotoDetail');
    }
    final element = $__root__.createElement(ByTagName('button'), [], []);
    final returnMe = element;
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('HeroesPO', '_gotoDetail');
    }
    return returnMe;
  }

  PageObjectList<PageLoaderElement> get _heroes {
    for (final __listener in $__root__.listeners) {
      __listener.startPageObjectMethod('HeroesPO', '_heroes');
    }
    final returnMe = PageObjectList<PageLoaderElement>(
        $__root__.createList(ByTagName('li'), [], []),
        (PageLoaderElement e) => e);
    for (final __listener in $__root__.listeners) {
      __listener.endPageObjectMethod('HeroesPO', '_heroes');
    }
    return returnMe;
  }
}
