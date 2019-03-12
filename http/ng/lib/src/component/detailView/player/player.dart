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

// ***************
// PROJECT IMPORTS
// ***************
import '../../../type/player.dart';
import '../../../type/barcode.dart';
import '../../../service/interop_barcode_service.dart';

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

  PlayerDetailComponent(this._interopService){
    _buttonStreamer = new StreamController<String>.broadcast(sync: true);
  }

  StreamController<String> _buttonStreamer;
  Stream<String> get buttonStream => _buttonStreamer.stream;

  InteropBarcodeService _interopService; // Injected from app_component

  // Reference to the Material-Input where we want to auto-fill with barcodes
  @ViewChild('barcode_slot', read: MaterialInputComponent)
  MaterialInputComponent barcodeSlot;

  // Determine if UI element is locked
  // Lower levels are at decreased amounts of guarding from edits
  bool lockLevelIsAtLeast(int level){
    return lockLevel >= level;
  }

  // NO ACTION ON INIT
  void ngOnInit() async {
    print("Current Item : ${item.name}");
    _interopService.barcodeStream.listen(_barcodeStreamHandler);
  }

  void buttonCall(UIEvent event, String cmd){
    event.preventDefault();
    event.stopPropagation();
    _buttonStreamer.add(cmd);
  }

  void _barcodeStreamHandler(Barcode barcode){
    if(barcodeSlot.focused && (!barcodeSlot.disabled)){
      item.key = barcode.value;
    }
  }

  void startBarcodeReader(){
    if(!barcodeSlot.disabled){
      _interopService.startStream();
    }
  }

  void stopBarcodeReader(){
    _interopService.stopStream();
  }

}
