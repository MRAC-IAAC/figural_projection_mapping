/**
 Author : Anna Batalle, Matt Gordon, Lorenzo Masini, Roberto Vargas
 Copyright : Copyright 2019, IAAC
 Credits: [Institute for Advanced Architecture of Catalonia - IAAC, MRAC group]
 License:  Apache License Version 2.0
 Version: 000
 Maintainer: 
 Email: 
 Status: development
 **/

import ch.bildspur.realsense.*;

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
public boolean useKinect = false;
public boolean useExternalDisplay = false;
public boolean useSpout = false;

public void settings() {
  if (useExternalDisplay) {
    fullScreen(P2D, 2);
  } else {
    size(960, 540, P2D);
  }

  println("Main Display Size : " + width + "x" + height);
}

public void setup() {
  setupSize();
  graphics = createGraphics(width, height);

  depthCamera = new DepthCamera(this, useKinect);

  setupControlWindow();

  if (useSpout) setupSpout();

  textureMode(NORMAL);

  opencv = new OpenCV(this, width, height);
}

public void draw() {
  background(0, 0, 50);
  
  PImage body = depthCamera.getBodyBlobImage();
  image(body, (width - depthCamera.scaledWidth) / 2, (height - depthCamera.scaledHeight) / 2, depthCamera.scaledWidth, depthCamera.scaledHeight);
  
  opencv.loadImage(get());

  graphics.beginDraw();
  graphics.background(0);
  graphics = cvGetOutlines(graphics);
  graphics.endDraw();

  controlImg = graphics.get();

  background(0);
  noFill();
  noStroke();

  float diff = 0.05;
  for (float u = 0; u < 1; u += diff) {
    for (float v = 0; v < 1; v += diff) {
      beginShape();
      texture(graphics);
      PVector v1 = quadLerp(vertices, u, v);
      PVector v2 = quadLerp(vertices, u+diff, v);
      PVector v3 = quadLerp(vertices, u+diff, v+diff);
      PVector v4 = quadLerp(vertices, u, v+diff);
      PVector vt1 = quadLerp(texVertices, u, v);
      PVector vt2 = quadLerp(texVertices, u+diff, v);
      PVector vt3 = quadLerp(texVertices, u+diff, v+diff);
      PVector vt4 = quadLerp(texVertices, u, v+diff);

      vertex(v1.x, v1.y, vt1.x, vt1.y);
      vertex(v2.x, v2.y, vt2.x, vt2.y);
      vertex(v3.x, v3.y, vt3.x, vt3.y);
      vertex(v4.x, v4.y, vt4.x, vt4.y);
      endShape();
    }
  }

  if (useSpout) spout.sendTexture();
}

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
}

public void setupSpout() {
  spout = new Spout(this);
  spout.createSender("Projection Mapping Source Graphics");
}