// ***************
// CORE IMPORTS
// ***************
import 'dart:async';
import 'dart:html';

// ***************
// ANGULAR IMPORTS
// ***************
import 'package:angular/angular.dart';

import 'package:angular_forms/angular_forms.dart';

import 'package:angular_components/angular_components.dart';
import 'package:angular_components/material_button/material_button.dart';
import 'package:angular_components/material_expansionpanel/material_expansionpanel.dart';
import 'package:angular_components/material_input/material_input.dart';
import 'package:angular_components/material_input/material_number_accessor.dart';

// ***************
// PROJECT IMPORTS
// ***************
import '../../../type/game.dart';

@Component(
  selector: 'game-detail',
  templateUrl: 'game.html',
  styleUrls: ['game.css'],
  directives: [
    coreDirectives,
    formDirectives,
    MaterialButtonComponent,
    MaterialExpansionPanel,
    materialInputDirectives,
    materialNumberInputDirectives,
  ],
  pipes: [commonPipes],
)
class GameDetailComponent implements OnInit {

  // Hold on to current item
  @Input()
  Game item;

  // Track lock level (UI MOD)
  // 0 - New/free entity (DB reject on duplicate keys, id, etc)
  // 1 - Edit normal entity (DB update with new name, settings, etc)
  @Input()
  int lockLevel;

  StageDetailComponent(){
    _buttonStreamer = new StreamController<String>.broadcast(sync: true);
  }

  StreamController<String> _buttonStreamer;
  Stream<String> get buttonStream => _buttonStreamer.stream;

  // Determine if UI element is locked
  // Lower levels are at decreased amounts of guarding from edits
  bool lockLevelIsAtLeast(int level){
    return lockLevel >= level;
  }

  // NO ACTION ON INIT
  void ngOnInit() async {
    print("Current Game : ${item.id.toString()}");
  }

  void buttonCall(UIEvent event, String cmd){
    event.preventDefault();
    event.stopPropagation();
    _buttonStreamer.add(cmd);
  }

}
