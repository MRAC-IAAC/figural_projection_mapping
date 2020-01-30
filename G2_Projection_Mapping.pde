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

import org.opencv.core.*;
import org.opencv.calib3d.Calib3d;
import org.opencv.video.BackgroundSubtractorMOG;
import org.opencv.objdetect.CascadeClassifier;
import org.opencv.imgproc.Imgproc;

// Kinect resolution : 512x424

KinectPV2 kinect;
OpenCV opencv;

/** Scaling from kinect image resolution to screen resolution **/
float scaleFactor = 1;

/** Kinect image width after scaling **/
float iW = -1;

/** Kinect image height after scaling **/
float iH = -1;

public void setup() {
  //size(512, 424); 
  fullScreen();
  print(width + " : " + height);

  float wS = width / 512.0;
  float hS = height / 424.0;

  scaleFactor = (wS < hS) ? wS : hS;

  iW = 512 * scaleFactor;
  iH = 424 * scaleFactor;

  opencv = new OpenCV(this, 512, 424);
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

public void draw() {
  background(0, 0, 50);

  ArrayList<PImage> bodyTrackList = kinect.getBodyTrackUser();
  for (int i = 0; i < bodyTrackList.size(); i++) {
    PImage bodyTrackImg = (PImage)bodyTrackList.get(i);
    opencv.loadImage(bodyTrackImg);

    opencv.gray();
    opencv.threshold(10);

    Mat forOpen = new Mat( 3, 3, CvType.CV_64FC1 );
    int row = 0, col = 0;
    forOpen.put(row, col, 1, 1, 1, 1, 1, 1, 1, 1, 1 );

    opencv.erode();
    opencv.dilate();
    //Imgproc.dilate(opencv.matGray, opencv.matGray, forOpen);
    bodyTrackImg = opencv.getOutput();

    // Flip Image 
    translate(width, 0);
    scale(-1, 1);
    image(bodyTrackImg, width / 2 - (iW / 2), height / 2 - (iH / 2), iW, iH);
  }
  if (bodyTrackList.size() == 0) {
    image(kinect.getDepth256Image(), width / 2 - (iW / 2), height / 2 - (iH / 2), iW, iH);
  }
}