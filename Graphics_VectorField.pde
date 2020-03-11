ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList<PVector> direction = new ArrayList<PVector>();

public int[] colorIds;

// colors used for points
color[] pal = {
  color (255, 255, 255), 
  color (235, 235, 235), 
  color (215, 215, 215), 
};

color[] pal2 = {
  color (160, 30, 9), 
  color (140, 140, 140), 
  color (120, 120, 120), 
};

float lastx;
float lasty;

public Amplitude amp;
public AudioIn in;
public float ampt;

PVector[] lp = new PVector [4];

int resetTimer = 0;

public void setupVectorField() {
  // Audio
  // Create an Input stream which is routed into the Amplitude analyzer
  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);

  // divide the screen in points
  for (float x=0; x<=width; x+= 14) {
    for (float y=0; y<=height; y+= 14) {
      // create point slightly distorted
      PVector v = new PVector(x+randomGaussian()*0.8, y+randomGaussian()*0.8);
      //asign vector to the created points
      points.add(v);
      PVector d = new PVector(12, 12);
      //d = PVector. random2D(v);
      direction.add(d);
    }
  }

  colorIds = new int[points.size()];

  for (int i = 0; i < colorIds.length; i++) {
    colorIds[i] = (int)(100*pal.length*noise(i))%pal.length;
  }

  for (int i=0; i<4; i++) {
    lp[i]= new PVector ();
  }
}

//stroke (220, 66, 117);
//  stroke (58, 33, 122);
//  stroke (115, 32, 193);
//  stroke (152, 43, 111);

public void drawAllBodies(PGraphics pg) {
  int[] bodyColors = {color(220, 66, 117), 
    color(58, 33, 122), 
    color(115, 32, 193), 
    color(152, 43, 111)};

  ArrayList<PImage> bodyTrackList = depthCamera.kinect.getBodyTrackUser(); 

  for (int i = 0; i < bodyTrackList.size(); i++) {
    opencv.loadImage(bodyTrackList.get(i));
    opencv.threshold();
    opencv.erode();
    opencv.dilate();
    pg.tint(bodyColors[i]);
    pg.image(opencv.getSnapshot(),0,0);
    pg.tint(255);
  }
}

public void drawVectorField(PGraphics pg) {
  background(0);
  fill(0);
  rect(0, 0, 1800, 1000); 
  ampt = amp.analyze();

  float[][] distances = new float [4][points.size()];
  for (int i= 0; i< distances[0].length; i++) {
    distances[0][i] = Float.MAX_VALUE;
    distances[1][i] = Float.MAX_VALUE;
    distances[2][i] = Float.MAX_VALUE;
    distances[3][i] = Float.MAX_VALUE;
  }

  if (resetTimer > 0) {
    if (resetTimer > 12) {
      for (PVector d : direction) {
        d.mult(0.6);
      }
    } else {
      for (PVector d : direction) {
        d.x += 1;
        d.y += 1;
      }
    }

    resetTimer--;
  } else {
    //ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d();
    ArrayList<KSkeleton> skeletonArray =  depthCamera.kinect.getSkeletonColorMap();

    // Update field using skeletons
    for (int i = 0; i < skeletonArray.size(); i++) {
      KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
      if (skeleton.isTracked()) {

        KJoint[] joints = skeleton.getJoints();
        KJoint joint = joints[KinectPV2.JointType_HandRight];

        //Define Parameters
        float x = depthCamera.cameraWidth - joint.getX();
        float y = joint.getY();

        //PVector currentHand = new PVector(x,y);
        //quadLerp(currentHand,vertices,currentHand.x / depthCamera.cameraWidth,currentHand.y / depthCamera.cameraHeight);

        PVector kinect = new PVector((x-lastx), (y-lasty)+1);

        for (int j = 0; j < points.size(); j++) {
          PVector p = points.get (j);
          PVector d = direction.get (j);
          PVector kinect2 = kinect.get();
          float s = dist(x, y, p.x, p.y); 
          distances [i][j] = s;
          //distance between mouse-point)
          if (s < 80) {
            //distance between mouse movement
            kinect2.mult(map(s, 0, 80, 1, 0)); 
            d.add(kinect2);
            if (d.mag() > 80) {
              d.normalize();
              d.mult(80);
            }
          }
        }
        lp[i].x = x;
        lp[i].y = y;
      }
    }
  }

  //ArrayList<KSkeleton> skeletonArray =  kinect.getSkeleton3d();
  ArrayList<KSkeleton> skeletonArray =  depthCamera.kinect.getSkeletonColorMap();

  // Update field using skeletons
  for (int i = 0; i < skeletonArray.size(); i++) {
    KSkeleton skeleton = (KSkeleton) skeletonArray.get(i);
    if (skeleton.isTracked()) {

      KJoint[] joints = skeleton.getJoints();
      KJoint joint = joints[KinectPV2.JointType_HandRight];

      //Define Parameters
      float x = depthCamera.cameraWidth - joint.getX();
      float y = joint.getY();

      //PVector currentHand = new PVector(x,y);
      //quadLerp(currentHand,vertices,currentHand.x / depthCamera.cameraWidth,currentHand.y / depthCamera.cameraHeight);

      PVector kinect = new PVector((x-lastx), (y-lasty)+1);

      for (int j = 0; j < points.size(); j++) {
        PVector p = points.get (j);
        PVector d = direction.get (j);
        PVector kinect2 = kinect.get();
        float s = dist(x, y, p.x, p.y); 
        distances [i][j] = s;
        //distance between mouse-point)
        if (s < 80) {
          //distance between mouse movement
          kinect2.mult(map(s, 0, 80, 1, 0)); 
          d.add(kinect2);
          if (d.mag() > 80) {
            d.normalize();
            d.mult(80);
          }
        }
      }
      lp[i].x = x;
      lp[i].y = y;
    }
  }

  // Check audio input for sound to reset field 0.01
  if (ampt >= 0.5) {
    resetField();
  }

  // Draw Field
  for (int i = 0; i < points.size(); i++) {
    PVector p = points.get (i);
    PVector d = direction.get (i);
    float s0 = distances [0][i];
    float s1 = distances [1][i];
    float s2 = distances [2][i];
    float s3 = distances [3][i];

    //color shadow in the mouse
    if (s0 < 80) {
      strokeWeight (2);
      stroke (220, 66, 117);
      line (p.x, p.y, p.x+d.x, p.y+d.y);//draw
      strokeWeight (1.5);
    }
    if (s1 < 80) {
      strokeWeight (2);
      stroke (58, 33, 122);
      line (p.x, p.y, p.x+d.x, p.y+d.y);//draw
      strokeWeight (1.5);
    }
    if (s2 < 80) {
      strokeWeight (2);
      stroke (115, 32, 193);
      line (p.x, p.y, p.x+d.x, p.y+d.y);//draw
      strokeWeight (1.5);
    }
    if (s3 < 80) {
      strokeWeight (2);
      stroke (152, 43, 111);
      line (p.x, p.y, p.x+d.x, p.y+d.y);//draw
      strokeWeight (1.5);
    }

    // select color from palette 
    float a = d.heading();
    if (a < 0) {
      int cn = colorIds[i];
      pg.stroke(pal[cn], 255);//point transparecy
      pg.point(p.x, p.y); //draw
      pg.stroke(pal[cn], 200);//vector transparency
      pg.line(p.x, p.y, p.x+d.x, p.y+d.y);
    } else {
      int cn = colorIds[i];
      pg.stroke(pal2[cn], 255);//point transparecy
      pg.point(p.x, p.y); //draw
      pg.stroke(pal2[cn], 200);//vector transparency
      pg.line(p.x, p.y, p.x+d.x, p.y+d.y);//draw
    }
  }

  //text(skeletonArray.size(), 10, 10);
}

public void resetField() {
  println("hello");
  //for (PVector d : direction) {
  //  d.x = 0;
  //  d.y = 0;
  //}
  resetTimer = 24;
}
