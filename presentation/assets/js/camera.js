$( document ).ready(function() {

  $("#camera_btn").click(function () {
    // Grab elements, create settings, etc.
    var video = document.getElementById('camera_video');
    // Get access to the camera!
    if(navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
      // Not adding `{ audio: true }` since we only want video now
      navigator.mediaDevices.getUserMedia({ video: true }).then(function(stream) {
          video.src = window.URL.createObjectURL(stream);
          video.play();
      });
    }
  });
  function convertCanvasToImage(canvas) {
    var image = new Image();
    image.src = canvas.toDataURL("image/png");
    return image;
  }
  // Trigger photo take
  $("#snap").click(function () {
    // Elements for taking the snapshot
    var canvas = document.getElementById('canvas');
    var context = canvas.getContext('2d');
    var video = document.getElementById('camera_video');

    // Get access to the camera!
    // var width = document.getElementById('camera_video').offsetWidth;
    // var height = document.getElementById('camera_video').offsetHeight;
    // console.log(video.offsetWidth);
    // console.log(video.offsetHeight);
    document.getElementById('camera_video').style.display="none;";
    context.drawImage(video, 0, 0, 640, 480);
    // image = convertCanvasToImage(canvas);
    document.getElementById('snapshot').value = canvas.toDataURL();;
  });

  /* Legacy code below: getUserMedia
  else if(navigator.getUserMedia) { // Standard
    navigator.getUserMedia({ video: true }, function(stream) {
        video.src = stream;
        video.play();
    }, errBack);
  } else if(navigator.webkitGetUserMedia) { // WebKit-prefixed
    navigator.webkitGetUserMedia({ video: true }, function(stream){
        // video.src = window.webkitURL.createObjectURL(stream);
        video.srcObject = stream;
	video.play();
    }, errBack);
  } else if(navigator.mozGetUserMedia) { // Mozilla-prefixed
    navigator.mozGetUserMedia({ video: true }, function(stream){
        video.src = window.URL.createObjectURL(stream);
        video.play();
    }, errBack);
  }
  */
});
