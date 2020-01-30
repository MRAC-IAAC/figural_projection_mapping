/**
 Takes a PImage 'src' of depth camera data. 
 Finds the contours of the image and draws them in solid white, to be used as a mask. 
 Returns the resulting PImage
 **/
public PImage cvGetOutlines(PImage src) {
  opencv.loadImage(src);
  opencv.gray();
  opencv.threshold(10);

  // open to reduce noise
  opencv.erode();
  opencv.dilate();

  PGraphics output = createGraphics(width, height);
  output.beginDraw();

  // Arguments to findContours are 'findHoles' and 'sort'
  ArrayList<Contour> contours = opencv.findContours(false, false);
  for (Contour contour : contours) {
    //float polygonFactor = 1.0 * mouseX / width * 10.0;
    float polygonFactor = 1;
    contour.setPolygonApproximationFactor(polygonFactor);
    if (contour.numPoints() > 50) {
      //stroke(0, 200, 200);
      //noFill();
      output.fill(255);
      output.noStroke();

      output.beginShape();

      for (PVector point : contour.getPolygonApproximation ().getPoints()) {
        output.vertex(point.x, point.y);
      }
      output.endShape();
    }
  }

  output.endDraw();
  return output;
}

PImage[] imgHistory = new PImage[3];

public PImage calculateImageHistory(PImage newImg) {
  for (int i = 0; i < imgHistory.length - 1; i++) {
    imgHistory[i] = (imgHistory[i + 1] != null) ? imgHistory[i + 1] : newImg;
  }
  imgHistory[imgHistory.length-1] = newImg;

  PGraphics output = createGraphics(width,height);
  output.beginDraw();
  for (int i = 0; i < imgHistory.length; i++) {
    float a = 1.0 / (i + 1) * 255.0;
    output.tint(255, a);
    output.image(imgHistory[i], 0, 0);
  }
  output.tint(255, 255);
  output.endDraw();
  
  return(output);
}