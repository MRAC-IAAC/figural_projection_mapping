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

/**
 // Kinect resolution : 512x424
 **/

import gab.opencv.*;
import KinectPV2.*;

import org.opencv.core.*;
import org.opencv.calib3d.Calib3d;
import org.opencv.video.BackgroundSubtractorMOG;
import org.opencv.objdetect.CascadeClassifier;
import org.opencv.imgproc.Imgproc;

public KinectPV2 kinect;
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

public void setup() {
  //size(512, 424); 
  //fullScreen(P2D);
  size(960,540,P2D);
  
  //output = createGraphics(1920,1080,P2D);
  println(width + " : " + height);

  float wS = width / 512.0;
  float hS = height / 424.0;

  scaleFactor = (wS < hS) ? wS : hS;

  iW = 512 * scaleFactor;
  iH = 424 * scaleFactor;

  opencv = new OpenCV(this, 512, 424);

  spout = new Spout(this);
  spout.createSender("Projection Mapping Source Graphics");

  setupKinect();
}

public void draw() {
  //background(0, 0, 50);
  background(0);

  ArrayList<PImage> bodyTrackList = kinect.getBodyTrackUser();
  for (int i = 0; i < bodyTrackList.size(); i++) {
    PImage bodyTrackImg = (PImage)bodyTrackList.get(i);
    opencv.loadImage(bodyTrackImg);

    opencv.gray();
    opencv.threshold(10);

    //Mat forOpen = new Mat( 3, 3, CvType.CV_64FC1 );
    //int row = 0, col = 0;
    //forOpen.put(row, col, 1, 1, 1, 1, 1, 1, 1, 1, 1 );
    //Imgproc.dilate(opencv.matGray, opencv.matGray, forOpen);

    opencv.erode();
    opencv.dilate();

    //bodyTrackImg = opencv.getOutput();
    bodyTrackImg = cvGetOutlines();
    
    PImage graphics = drawGraphics();
    graphics.mask(bodyTrackImg);
    background(0);
    //image(graphics, width / 2 - (iW / 2), height / 2 - (iH / 2), iW, iH);

    // Flip Image 
    translate(width, 0);
    scale(-1, 1);
    image(bodyTrackImg, width / 2 - (iW / 2), height / 2 - (iH / 2), iW, iH);
  }
  if (bodyTrackList.size() == 0) {
    image(kinect.getDepth256Image(), width / 2 - (iW / 2), height / 2 - (iH / 2), iW, iH);
  }

  spout.sendTexture();
  
  //println(frameRate);
}
