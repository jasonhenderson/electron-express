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
import '../../../type/barcode.dart';
import '../../../service/interop_key_service.dart';

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
  // 0 - New/free entity (DB reject on duplicate keys, id, etc)
  // 1 - Edit normal entity (DB update with new name, settings, etc)
  @Input()
  int lockLevel;

  PlayerDetailComponent(this._interopService);
  InteropKeyService _interopService;

  // Reference to our dynamically loaded content's DOM element
  @ViewChild('ethkeyslot', read: MaterialInputComponent)
  MaterialInputComponent ethereumKeySlot;

  // Determine if UI element is unlocked
  // Lower levels are at increased amounts of guarding from edits
  bool disabledFromLevel(int level){
    return lockLevel >= level;
  }

  // NO ACTION ON INIT
  void ngOnInit() async {
    print("Init finished");
    print("Current Item : ${item.name}");
    _interopService.barcodeStream.listen(_streamHandler);
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

  void _streamHandler(Barcode barcode){
    MaterialInputComponent input = ethereumKeySlot;
    if(input.focused && (!input.disabled)){
      input.inputText = barcode.value;
    }
  }

  String capitalizedFunction(){
    // TODO - Fix or ditch
    return "STUB VALUE";
  }

  void printer(dynamic thing){
    print(thing);
  }
}
