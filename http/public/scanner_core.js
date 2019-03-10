
dynamsoft.dbrEnv.licenseKey = "t0068NQAAAG/TwtdM274aeHmbwQYT/L389zMZ12yVQUTwecx6tXxHjvX0BrCKkQ5XzjLio0nwTdcchkpoSa+bsMm9p3+qABk=";
dynamsoft.dbrEnv.bUseWorker = true; //uncomment it to use worker
dynamsoft.dbrEnv.onAutoLoadWasmSuccess = playvideo;

var video = document.querySelector('#theVideo');

var playvideo = () => {
  navigator.mediaDevices.getUserMedia({
    video: {
      width: {
        ideal: 1280
      },
      height: {
        ideal: 720
      },
      facingMode: {
        ideal: 'environment'
      }
    }
  }).then((stream) => {
    video.srcObject = stream;
    video.onloadedmetadata = () => {
      video.play();
      loopReadVideo();
    };
  }).catch ((ex) => {
    alert("Please make sure the camera is connected and the site is deployed in https: " + (ex.message || ex));
  });
};

var isLooping = true;

var loopReadVideo = function () {
  if (!isLooping) {
    return;
  }
  var timestart = (new Date()).getTime();

  var reader = new dynamsoft.BarcodeReader();
  reader.decodeFileInMemory(video).then(results => {
    for (var i = 0; i < results.length; ++i) {
      var result = results[i];
    }
    result == undefined ? undefined : console.log(result)
    setTimeout(loopReadVideo, 350);
    return reader.deleteInstance();
  }).catch (ex => {
    setTimeout(loopReadVideo, 350);
    reader.deleteInstance();
  });
};