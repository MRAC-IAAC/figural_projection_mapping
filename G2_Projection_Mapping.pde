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

import processing.sound.*;

import spout.*;

public DepthCamera depthCamera;
public OpenCV opencv;
public Spout spout;

public GWindow controlWindow;

public int vertexId = 0;

public PVector vertices[] = new PVector[4];
public PVector texVertices[] = new PVector[4];

// Used for drawing subpatches of distorted quad
public PVector subVertices[] = new PVector[4];
public PVector subTexVertices[] = new PVector[4];

/** Applet that runs in the calibration window **/
public PApplet controlApplet  = null;


/** Helpers, half and quarter of the main displays width and height **/
int w2;
int h2;
int w4;
int h4;


/** Primary graphics context, before projection transformations **/
public PGraphics graphics;
/** Copy of the main screen, drawn to the calibrationw window **/
public PImage controlImg;



// MODE CONTROLS
// useKinect : true = Kinect camera, false = realSense camera
// useExternalDisplay : true = main graphics are fullscreen on second display, false = main graphics are windowed
// useSpout : true = send final graphics through spout, false = ignore spout
// morphOutput : Whether or not to apply homography to the final stage of drawing. Not used for vector field
// calibrate : Whether to make the calibration window active. Adds some lag + visual artifacts
// drawOutlines : Draw multiple transparent outlines offset from the central body
// printFrameRate : Prints the framerate every 100 frames
public boolean useKinect = true;
public boolean useExternalDisplay = true;
public boolean useSpout = false;
public boolean morphOutput = false;
public boolean calibrate = false;
public boolean drawOutlines = false;
public boolean printFrameRate = false;

public void settings() {
  if (useExternalDisplay) {
    fullScreen(P2D, 2);
  } else {
    size(960, 540);
  }

  println("Main Display Size : " + width + "x" + height);
}

public void setup() {
  setupSize();
  graphics = createGraphics(width, height,P2D);
  controlImg = createImage(width, height, ARGB);

  //setupParticles();

  depthCamera = new DepthCamera(this, useKinect);

  setupControlWindow();

  if (useSpout) setupSpout();

  textureMode(NORMAL);

  // Computer Vision
  opencv = new OpenCV(this, width, height);

  setupVectorField();

  println(width + " : " + height);

  loadConfig();
}

public void draw() {
  background(0, 0, 50);

  ampt = amp.analyze();

  PImage body = depthCamera.getBodyBlobImage();
  if (body != null) {
    pushMatrix();
    scale(-1, 1);
    translate(-width, 0);
    image(body, (width - depthCamera.scaledWidth) / 2, (height - depthCamera.scaledHeight) / 2, depthCamera.scaledWidth, depthCamera.scaledHeight);
    popMatrix();
  }

  if (drawOutlines) {
    opencv.loadImage(get());
  }



  background(0);
  fill(0);
  rect(0, 0, width, height);

  graphics.beginDraw();
  graphics.background(0);
  graphics.fill(0);
  graphics.rect(0, 0, 1800, 1000); 

  if (drawOutlines) {
    graphics = cvGetOutlines(graphics);
    //updateParticles();
  } else {
    drawAllBodies(graphics);
  }




  graphics.endDraw();
  drawProjection(this, graphics, 1);
  //image(calculateImageHistory(get()),0,0);
  graphics.beginDraw();
  graphics.clear();

  drawVectorField(graphics);

  graphics.endDraw();

  if (calibrate) {
    controlImg = graphics.get();
  }

  noFill();
  noStroke();

  if (morphOutput) {
    drawProjection(this, graphics, 1);
  } else {
    image(graphics, 0, 0);
  }


  if (calibrate && controlApplet != null) {
    controlApplet.redraw();
  }

  if (printFrameRate && frameCount % 100 == 0) {
    println(frameRate);
  }

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

  println(vertices[2]);

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
