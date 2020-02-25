public class DepthCamera {
  private KinectPV2 kinect;
  private RealSenseCamera realSense;

  public int cameraWidth;
  public int cameraHeight;

  public int scaledWidth;
  public int scaledHeight;

  public boolean useKinect;
  
  private OpenCV cameraCV;

  public DepthCamera(PApplet p, boolean useKinect) {
    this.useKinect = useKinect;
    if (useKinect) {
      activateKinect(p);
    } else {
      activateRealSense(p);
    }

    float wS = 1.0 * width / cameraWidth;
    float hS = 1.0 * height / cameraHeight;
    float scaleFactor = (wS < hS) ? wS : hS;
    scaledWidth = (int)(cameraWidth * scaleFactor);
    scaledHeight = (int)(cameraHeight * scaleFactor);
    
    cameraCV = new OpenCV(p,cameraWidth,cameraHeight);
    
    println("Scaled Camera Size : " + scaledWidth + ":" + scaledHeight);
  }

  public void activateKinect(PApplet p) {
    kinect = new KinectPV2(p);

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

    cameraWidth = 512;
    cameraHeight = 424;
  }

  public void activateRealSense(PApplet p) {
    realSense = new RealSenseCamera(p);
    realSense.enableDepthStream(640,480);
    realSense.start();
    cameraWidth = 640;
    cameraHeight = 480;
  }

  public PImage getBodyBlobImage() {
    if (useKinect) {
      ArrayList<PImage> bodyTrackList = kinect.getBodyTrackUser(); 
      PImage bodyTrackImg = (PImage)bodyTrackList.get(0);
      return(bodyTrackImg);
    } else {
      PImage out = getDepthImage(); 
      cameraCV.loadImage(out);
      cameraCV.gray();
      cameraCV.threshold(100);
      out = cameraCV.getOutput();
      return(out);
    }
  }

  public PImage getDepthImage() {
    if (useKinect) {
      return kinect.getDepthImage();
    } else {
      realSense.readFrames();
      realSense.enableColorizer(ColorScheme.WhiteToBlack);
      //realSense.createDepthImage(300, 10000);
      return(realSense.getDepthImage());
    }
  }
}
