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

// SINGLETON - Binds to global JS scope, service must be only one to do so
class InteropBarcodeService {

  InteropBarcodeService(){
    // Set JS global name to interop-enabled Dart function
    // Call from JS with provideValueToKeyService(Object)
    context['jsInteropToDart'] = allowInterop(_acceptJsObject);
    // Initialize the event stream for this singleton
    _barcodeStreamer = new StreamController<Barcode>.broadcast(sync: true);
  }

  // Internal references to the StreamController and a getter for event stream
  StreamController<Barcode> _barcodeStreamer;
  Stream<Barcode> get barcodeStream => _barcodeStreamer.stream;

  // Interop function base, handles JsObject conversion into Dart ecosystem
  void _acceptJsObject(JsObject object){
    Barcode barcode = new Barcode();
    // TODO - Add types/filtering to Dart intake function _acceptJsObject
    // TODO - This, better
    print(object);
    barcode.value = object["BarcodeText"].toString().substring(2);
    _barcodeStreamer.add(barcode);
  }

  void startStream(){
    context['videoStreamer'].callMethod('start', []);
  }

  void stopStream(){
    context['videoStreamer'].callMethod('stop', []);
  }
}

// Singleton to provide the factory when already instantiated
InteropBarcodeService serviceSingleton;

// Create a new service if necessary, return singleton to caller
InteropBarcodeService interopBarcodeServiceFactory(){
    if(serviceSingleton == null){
      serviceSingleton = new InteropBarcodeService();
    }
    return serviceSingleton;
}
