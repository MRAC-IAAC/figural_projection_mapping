public void setupKinect() {
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
}