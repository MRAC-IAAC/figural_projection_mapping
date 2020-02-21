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



import gab.opencv.*;
import KinectPV2.*;


import ch.bildspur.realsense.*;

import org.opencv.core.*;
import org.opencv.calib3d.Calib3d;
import org.opencv.video.BackgroundSubtractorMOG;
import org.opencv.objdetect.CascadeClassifier;
import org.opencv.imgproc.Imgproc;

public KinectPV2 kinect;
public RealSenseCamera realSense;
public OpenCV opencv;

import spout.*;

/** Scaling from kinect image resolution to screen resolution **/
public float scaleFactor = 1;

/** Kinect image width after scaling **/
public float iW = -1;

/** Kinect image height after scaling **/
public float iH = -1;

public PImage personMask;

public Spout spout;

//PGraphics output;

/**
 Uses Kinect camera if true
 Uses Intel RealSense camera if false
 */
public boolean useKinect = false;

public void setup() {
  //size(512, 424); 
  //fullScreen(P2D);
  size(960, 540, P2D);
  activateCamera();
  //output = createGraphics(1920,1080,P2D);
  println(width + " : " + height);

  activateCamera();

  float wS = 1.0 * width / cw;
  float hS = 1.0 * height / ch;

  scaleFactor = (wS < hS) ? wS : hS;

  iW = cw * scaleFactor;
  iH = ch * scaleFactor;

  opencv = new OpenCV(this, cw, ch);

  spout = new Spout(this);
  spout.createSender("Projection Mapping Source Graphics");
}

public void draw() {
  //background(0, 0, 50);
  background(0);
  
  PImage bodyTrackImg = getBodyBlobImage();

  opencv.loadImage(bodyTrackImg);

  opencv.gray();
  opencv.threshold(10);

  opencv.erode();
  opencv.dilate();

  //bodyTrackImg = opencv.getOutput();
  bodyTrackImg = cvGetOutlines();

  //PImage graphics = drawGraphics();
  ////println(graphics.width + " : " + graphics.height);
  ////println(bodyTrackImg.width + " : " + bodyTrackImg.height);
  //graphics.mask(bodyTrackImg);
  //background(0);
  //image(graphics, width / 2 - (iW / 2), height / 2 - (iH / 2), iW, iH);

  // Flip Image 
  translate(width, 0);
  scale(-1, 1);
  image(bodyTrackImg, width / 2 - (iW / 2), height / 2 - (iH / 2), iW, iH);

  spout.sendTexture();

  //println(frameRate);
}