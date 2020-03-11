# Projection Mapping
## IAAC MRAC 19-20 | Hardware 2 | Group 2

### Description

Project mapping is a projection technique used to turn objects, often irregularly shaped into a display surface for video projection. What we tried to accomplish during Hardware course is creating a Video Projection system done by code in processing, processing the input from a Kinect and use that with OpenCV to create visual and interactive effects.

![History](./doc/History.jpg)

### Process Description

**Software workflow:**

![workflow](./doc/workflow.jpg)

Calibration of the setting:
![calibration](./doc/calibration.jpg)


**Documentation:**

**1)** Blobs from OpenCV --> [link video](https://www.youtube.com/watch?v=LoU_e9nNRB8)
![First_Step](./doc/1.jpg)

**1.1)** *Blob Quality*
[![First_Step](./doc/Blob_Quality.jpg)

**2)** Clean Outlines 
![Second_Step](./doc/2.jpg) --> [link video](https://www.youtube.com/watch?v=uaYo_nu1j8A)

**3)** Calibration Homography --> [link video](https://www.youtube.com/watch?v=-CA7zrLlXVk)
![Third_Step](./doc/3.jpg)

**3.1)** *Calibration through Spout and Resolume Arena*
![Calibration](./doc/Delay_Test.jpg)

**3.1)** *Speed Test* --> [link video](https://www.youtube.com/watch?v=fbgv05gPEUY)
![Speed_Test](./doc/IMG_20200212_131307.jpg)

**3.2)** *Delay Test* --> [link video](https://www.youtube.com/watch?v=lHEGZzV15lw)
![Speed_Test](./doc/Delay_Test2.jpg)

**4)** Clean Outlines Offsets --> [link video](https://www.youtube.com/watch?v=eJJTYA-iC-M)
![Fourth_Step](./doc/4.jpg)

**5)** Physics Engine Implementation --> [link video](https://www.youtube.com/watch?v=-C0LxvOYOOE)
![Fifth_Step](./doc/5.jpg)

#### Graphics Exploration

**6)** Vector Fields V1
.
.

![Vector1](./doc/v1-tot.jpg)

.
.

Vector Fields V2

![Vector2](./doc/v2.jpg)

.
.

Vector Fields V3

![Vector2](./doc/v3.jpg)

.
.

Vector Fields V4

![Vector4](./doc/v4.jpg)

.
.

Vector Fields V5

![Vector5](./doc/v5.jpg)

.
.

Vector Fields V6

![Vector6](./doc/v61.jpg)

![Vector6](./doc/v62.jpg)

.
.

Vector Fields V7

![Vector6](./doc/v7.jpg)

.
.

### Requirements

**Processing Libraries:**

* *opencv*

* *KinectPV2*

* *Sound*

* *g4p_controls*

* *spout**

* *realSense**

**Optional*


#### Electronics and Hardware

Input and Output
![Workflow](./doc/diagram.jpg)

Kinect2 + Video Projector Casio xj-a242
 *   ![hardware](./doc/hardw.jpg)
 
 
### References:

* [Withouttitle-interactive, generative Online Application](https://www.liaworks.com/theprojects/withouttitle/)
* [Vector Field by tsulej](https://generateme.wordpress.com/2016/04/24/drawing-vector-field/)



### CODE

 ```import ch.bildspur.realsense.*;
import ch.bildspur.realsense.type.ColorScheme;

import gab.opencv.*;
import org.opencv.core.*;
import org.opencv.calib3d.Calib3d;
import org.opencv.video.BackgroundSubtractorMOG;
import org.opencv.objdetect.CascadeClassifier;
import org.opencv.imgproc.Imgproc;

import KinectPV2.*;

import g4p_controls.*;

import spout.*;

public DepthCamera depthCamera;
public OpenCV opencv;
public Spout spout;

public GWindow controlWindow;

public int vertexId = 0;

public PVector vertices[] = new PVector[4];
public PVector texVertices[] = new PVector[4];

public PVector subVertices[] = new PVector[4];
public PVector subTexVertices[] = new PVector[4];

public PApplet controlApplet  = null;



/** Helpers, half and quarter of the main displays width and height **/
int w2;
int h2;
int w4;
int h4;


/** Primary graphics context, before projection transformations **/
public PGraphics graphics;
public PImage controlImg;



// MODE CONTROLS
// useKinect : true = Kinect camera, false = realSense camera
// useExternalDisplay : true = main graphics are fullscreen on second display, false = main graphics are windowed
// useSpout : true = send final graphics through spout, false = ignore spout
public boolean useKinect = true;
public boolean useExternalDisplay = true;
public boolean useSpout = false;

public void settings() {
  if (useExternalDisplay) {
    fullScreen(P2D, 2);
  } else {
    size(960, 540, P2D);
    //fullScreen(P2D);
  }

  println("Main Display Size : " + width + "x" + height);
}

public void setup() {
  setupSize();
  graphics = createGraphics(width, height);
  controlImg = createImage(width, height, ARGB);

  setupParticles();

  depthCamera = new DepthCamera(this, useKinect);

  setupControlWindow();

  if (useSpout) setupSpout();

  textureMode(NORMAL);

  opencv = new OpenCV(this, width, height);
}

public void draw() {
  background(0, 0, 50);

  PImage body = depthCamera.getBodyBlobImage();
  if (body != null) {
    image(body, (width - depthCamera.scaledWidth) / 2, (height - depthCamera.scaledHeight) / 2, depthCamera.scaledWidth, depthCamera.scaledHeight);
  }

  opencv.loadImage(get());


  graphics.beginDraw();
  //graphics.background(0);
  //if (body != null) {
  //  graphics.image(body, (width - depthCamera.scaledWidth) / 2, (height - depthCamera.scaledHeight) / 2, depthCamera.scaledWidth, depthCamera.scaledHeight);
  //  graphics.filter(THRESHOLD);
  //}


  //graphics = cvGetOutlines(graphics);
  ////updateParticles();

  //graphics.pushMatrix();
  //graphics.scale(-1,1);
  //graphics.image(graphics.get(),-graphics.width,0);
  //graphics.popMatrix();

  graphics.background(200);
  drawCircles(graphics);
  graphics.endDraw();

  controlImg = graphics.get();
  //controlImg.copy(graphics,0,0,graphics.width,graphics.height,0,0,graphics.width,graphics.height);

  background(0);
  fill(0);
  rect(0, 0, width, height);
  noFill();
  noStroke();

  drawProjection(this, graphics, 1);

  if (controlApplet != null) {
    //controlApplet.redraw();
  }

  if (useSpout) spout.sendTexture();

  if (frameCount % 100 == 0) {
    println(frameRate);
  }
}

/**
 Called during setup, also call again whenever size of main display changes.
 This will really only happen if it fails to correctly fullscreen on the second display at first
 **/
public void setupSize() {
  w2 = width / 2;
  h2 = height / 2;
  w4 = width / 4;
  h4 = height / 4;
  vertices[0] = new PVector(0, 0);
  vertices[1] = new PVector(width, 0);
  vertices[2] = new PVector(width, height);
  vertices[3] = new PVector(0, height);

  texVertices[0] = new PVector(0, 0);
  texVertices[1] = new PVector(1, 0);
  texVertices[2] = new PVector(1, 1);
  texVertices[3] = new PVector(0, 1);

  for (int i = 0; i < 4; i++) {
    subVertices[i] = new PVector(0, 0);
    subTexVertices[i] = new PVector(0, 0);
  }
}

public void setupSpout() {
  spout = new Spout(this);
  spout.createSender("Projection Mapping Source Graphics");
}
 ```




 **Credits**


 _Based on IAAC publishing guidelines:
 (Metal Rod Bending for ABB) is a project of IaaC, Institute for Advanced Architecture of Catalonia. developed at Master in Robotics and Advanced Construction in 2019-2020 by:
 Students: (Anna Batalle, Matt Gordon, Lorenzo Masini, Roberto Vargas)
 Faculty: (Angel Muñoz)_
