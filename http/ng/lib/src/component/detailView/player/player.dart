// ***************
// CORE IMPORTS
// ***************
import 'dart:async';
import 'dart:html';

// ***************
// ANGULAR IMPORTS
// ***************
import 'package:angular/angular.dart';

import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';

import 'package:angular_components/material_button/material_button.dart';

import 'package:angular_components/laminate/components/modal/modal.dart';
import 'package:angular_components/auto_dismiss/auto_dismiss.dart';

import 'package:angular_components/material_expansionpanel/material_expansionpanel.dart';

// ***************
// PROJECT IMPORTS
// ***************
import '../../../type/player.dart';

@Component(
  selector: 'player-detail',
  templateUrl: 'player.html',
  styleUrls: ['player.css'],
  directives: [
    coreDirectives,
    formDirectives,
    MaterialButtonComponent,
    MaterialExpansionPanel,
    materialInputDirectives,
    AutoDismissDirective,
    MaterialDialogComponent,
    ModalComponent,
  ],
  pipes: [commonPipes],
)
class PlayerDetailComponent implements OnInit {

  // Hold on to current item
  @Input()
  Player item;

  // Track lock level (UI MOD)
  @Input()
  int lockLevel;

  PlayerDetailComponent();

  // NO ACTION ON INIT
  void ngOnInit() async {
    print("Init finished");
    print("Current Item : ${item.name}");
  }

  // Extinguish the current event and attempt to confirm DELETE with modal
  void onDelete(UIEvent event) async {
    event.stopPropagation();
    event.preventDefault();
    print("Running delete flow...");
  }

  // Modal confirms DELETE, use current selection ID and feed to current service
  void onConfirmDelete() async {
    // int statusCode = await _currentService.deleteById(selected.id);
    // if(statusCode == 200){
    //   // Success
    //   // TODO - Go back
    // } else {
    window.alert("Couldn't finish deleting current item!");
    //   print("Status code: ${statusCode}");
    // }
  }

  String capitalizedFunction(){
    // TODO - Fix or ditch
    return "STUB VALUE";
  }

  void printString(String str){
    print(str);
  }
}
