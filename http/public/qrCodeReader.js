var videoElement = document.getElementById('theVideo');
var decoderReady = false;

dynamsoft.dbrEnv.licenseKey = "t0068NQAAAG/TwtdM274aeHmbwQYT/L389zMZ12yVQUTwecx6tXxHjvX0BrCKkQ5XzjLio0nwTdcchkpoSa+bsMm9p3+qABk=";
dynamsoft.dbrEnv.bUseWorker = true;
dynamsoft.dbrEnv.onAutoLoadWasmSuccess = function(){
  console.log("WASM load ok...");
  decoderReady = true;
};
dynamsoft.dbrEnv.onAutoLoadWasmError = function(){
  console.log("Error in WASM load!");
};

// Prefer camera resolution nearest to 1280x720.
var constraints = { audio: false, video: { width: 1280, height: 720 } };

var videoStreamer = {
  start: function(){
    console.log("Starting stream...");
    navigator.mediaDevices.getUserMedia(constraints)
    .then(function(mediaStream) {
      videoElement.srcObject = mediaStream;
      videoElement.onloadedmetadata = function(e) {
        console.log("Video feed beginning...");
        videoElement.play();
        loopReadVideo();
      };
    })
    .catch(function(err) { console.log(err.name + ": " + err.message); });
  },
  stop: function(){
    console.log("Stopping streams...");
    videoElement.srcObject
                .getTracks()
                .forEach( function(track){
                  track.stop();
                });
  }
};
var loopReadVideo = function(){
  if(!decoderReady){
    setTimeout(loopReadVideo, 100);
    return;
  }
  var reader = new dynamsoft.BarcodeReader();
  reader.decodeFileInMemory(videoElement)
        .then((results) => {
          // We don't want to support multiple codes being mixed up
          // We don't want to support actions on 0 codes found
          // We don't want to support actions on undefined codes
          if((results.length != 1) || (typeof results[0] === "undefined")){
            return;
          }
          // Send one barcode to the streamer
          // NOTE - Ensure this name is set in Dart during service construction
          //        and then only call from a deferred function (i.e. "start")
          jsInteropToDart(results[0]);
          return;
        })
        .catch((err) => {
          // Do nothing with errors from barcode reader
        }).finally(() => {
          setTimeout(loopReadVideo, 350);
          reader.deleteInstance();
        });
};
