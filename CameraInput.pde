int cw;
int ch;

/**
 // Kinect resolution : 512x424
 // Realsense resolution : 640x480
 **/
public void activateCamera() {
   if (useKinect) {
      activateKinect(); 
   }
   else {
      activateRealSense(); 
   }
}

public PImage getBodyBlobImage() {
  if (useKinect) {
   ArrayList<PImage> bodyTrackList = kinect.getBodyTrackUser(); 
   PImage bodyTrackImg = (PImage)bodyTrackList.get(0);
   return(bodyTrackImg);
  }
  else {
   PImage out = getDepthImage(); 
   opencv.loadImage(out);
   opencv.gray();
   opencv.threshold(100);
   out = opencv.getOutput();
   return(out);
  }
  
}

public PImage getDepthImage() {
  if (useKinect) {
    return kinect.getDepthImage();
  }
  else {
    realSense.readFrames();
    realSense.createDepthImage(300,10000);
    return(realSense.getDepthImage());
  }
}




public void activateKinect() {
  kinect = new KinectPV2(this);

  // A grayscale image showing depth, values from 0-255
  // kinect.getDepthImage()
  kinect.enableDepthImg(true);

  // Depth mask, but blanks out people blobs
  // kinect.getDepthMaskImage()
  kinect.enableDepthMaskImg(true);

  // Seems the same as DepthImg?
  // kinect.getPointCloudDepthImage()
  kinect.enablePointCloud(true);

  // One bit mask showing body blobs
  // kinect.getBodyTrackImage()
  // kinect.getBodyTrackUser() -> Returns an arraylist of blobs sorted by different people
  kinect.enableBodyTrackImg(true);

  kinect.init();
  
  cw = 512;
  ch = 424;
}

public void activateRealSense() {
   realSense = new RealSenseCamera(this);
   realSense.start(640, 480, 30, true, false);
   cw = 640;
   ch = 480;
}