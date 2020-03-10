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

// global configuration
float vector_scale = 8; // vector scaling factor, we want small steps
float time = 0; // time passes by

float lastx;
float lasty;

public Amplitude amp;
public AudioIn in;
public float ampt;

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
}

public void drawVectorField(PGraphics pg) {
  background(0);
  fill(0);
  rect(0, 0, 1800, 1000); 

  ampt = amp.analyze();

  float[] distances = new float [points.size()];
  for (int i= 0; i< distances.length; i++) {
    distances[i] = Float.MAX_VALUE;
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
      float x = joint.getX();
      float y = joint.getY();
      
      PVector currentHand = new PVector(x,y);
      quadLerp(currentHand,vertices,currentHand.x / depthCamera.cameraWidth,currentHand.y / depthCamera.cameraHeight);

      PVector kinect = new PVector((x-lastx), (y-lasty)+1);

      for (int j = 0; j < points.size(); j++) {
        PVector p = points.get (j);
        PVector d = direction.get (j);
        PVector kinect2 = kinect.get();
        float s = dist(x, y, p.x, p.y); 
        distances [j]= s;
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
      lastx = x;
      lasty = y;
    }
  }

  // Check audio input for sound to reset field
  if (ampt >= 0.01) {
    resetField();
  }

  // Draw Field
  for (int i = 0; i < points.size(); i++) {
    PVector p = points.get (i);
    PVector d = direction.get (i);
    float s = distances [i];

    //color shadow in the mouse
    if (s < 80) {
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
  for (PVector d : direction) {
    d.x = 12;
    d.y = 12;
  }
}
