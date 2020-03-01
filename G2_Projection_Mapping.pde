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
public boolean useExternalDisplay = false;
public boolean useSpout = true;

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

  setupParticles();

  depthCamera = new DepthCamera(this, useKinect);

  //setupControlWindow();

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
  graphics.background(0);
  graphics = cvGetOutlines(graphics);
  updateParticles();
  
  graphics.pushMatrix();
  graphics.scale(-1,1);
  graphics.image(graphics.get(),-graphics.width,0);
  graphics.popMatrix();
  
  graphics.endDraw();

  controlImg = graphics.get();

  background(0);
  fill(0);
  rect(0,0,width,height);
  noFill();
  noStroke();

  drawProjection(this, graphics, 1);

  if (useSpout) spout.sendTexture();
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
}

public void setupSpout() {
  spout = new Spout(this);
  spout.createSender("Projection Mapping Source Graphics");
}
