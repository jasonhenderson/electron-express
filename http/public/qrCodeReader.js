var videoElement = document.getElementById('theVideo');

dynamsoft.dbrEnv.licenseKey = "t0068NQAAAG/TwtdM274aeHmbwQYT/L389zMZ12yVQUTwecx6tXxHjvX0BrCKkQ5XzjLio0nwTdcchkpoSa+bsMm9p3+qABk=";
dynamsoft.dbrEnv.bUseWorker = true;

// Prefer camera resolution nearest to 1280x720.
var constraints = { audio: false, video: { width: 1280, height: 720 } };

navigator.mediaDevices.getUserMedia(constraints)
.then(function(mediaStream) {
  videoElement.srcObject = mediaStream;
  videoElement.onloadedmetadata = function(e) {
    videoElement.play();
    dynamsoft.dbrEnv.onAutoLoadWasmSuccess = function(){
      loopReadVideo();
    };
    dynamsoft.dbrEnv.onAutoLoadWasmError = function(){
      console.log("Error in WASM load!");
    };
  };
})
.catch(function(err) { console.log(err.name + ": " + err.message); });

var keyFilteringPipeToProvider = function(barcode){
  if( (barcode.BarcodeFormatString == "QR_CODE") &&
      (barcode.BarcodeBytes.length == 42) ){
    try{
      provideValueToKeyService({"value": barcode.BarcodeText.substring(2)});
    } catch(e){
      // Access error, function name not set in context by Dart yet
    }
  } else {
    // Not a valid ETHEREUM address
  }
};
var loopReadVideo = function(){
  var reader = new dynamsoft.BarcodeReader();
  reader.decodeFileInMemory(videoElement)
        .then((results) => {
          // We don't want to support multiple codes being mixed up
          if((results.length != 1) || (typeof results[0] === "undefined")){
            setTimeout(loopReadVideo, 350);
            reader.deleteInstance();
            return;
          }
          var firstResult = results[0];
          keyFilteringPipeToProvider(firstResult);
          setTimeout(loopReadVideo, 350);
          reader.deleteInstance();
          return;
        })
        .catch((ex) => {
          setTimeout(loopReadVideo, 350);
          reader.deleteInstance();
          return;
        });
};
