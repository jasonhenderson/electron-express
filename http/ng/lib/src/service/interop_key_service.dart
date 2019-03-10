// ***************
// JS INTEROP IMPORTS
// ***************
import 'dart:js';

// ***************
// CORE IMPORTS
// ***************
import 'dart:async';

// ***************
// PROJECT IMPORTS
// ***************
import '../type/barcode.dart';

class InteropKeyService {

  InteropKeyService(){
    // Set JS global name to interop-enabled Dart function
    // Call from JS with provideValueToKeyService(Object)
    context['provideValueToKeyService'] = allowInterop(_acceptJsObject);
    // Initialize the event stream for this singleton
    _barcodeStreamer = new StreamController<Barcode>.broadcast(sync: true);
  }

  // Internal references to the StreamController and a getter for event stream
  StreamController<Barcode> _barcodeStreamer;
  Stream<Barcode> get barcodeStream => _barcodeStreamer.stream;

  void _acceptJsObject(JsObject object){
    Barcode barcode = new Barcode();
    barcode.value = object['value'];
    _barcodeStreamer.add(barcode);
  }

}

// Singleton to provide the factory when already instantiated
InteropKeyService keyServiceSingleton;

// Create a new service if necessary, return singleton to caller
InteropKeyService interopKeyServiceFactory(){
    if(keyServiceSingleton == null){
      keyServiceSingleton = new InteropKeyService();
    }
    return keyServiceSingleton;
}
