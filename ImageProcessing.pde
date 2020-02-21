/**
 Assumes an image is already loaded into OpenCV
 Finds the contours of the image and draws them in solid white, to be used as a mask. 
 Returns the resulting PImage
 **/
public PImage cvGetOutlines() {
  //opencv.loadImage(src);
  opencv.gray();
  opencv.threshold(10);

  // open to reduce noise
  opencv.erode();
  opencv.dilate();

  // Evil hardcoded size
  PGraphics output = createGraphics(652, 540);
  output.beginDraw();

  // Arguments to findContours are 'findHoles' and 'sort'
  ArrayList<Contour> contours = opencv.findContours(false, true);
  for (Contour contour : contours) {
    //float polygonFactor = 1.0 * mouseX / width * 10.0;
    float polygonFactor = 1;
    //println(polygonFactor);
    contour.setPolygonApproximationFactor(polygonFactor);
    if (contour.numPoints() > 50) {
      ArrayList<PVector> points = contour.getPolygonApproximation().getPoints();
      output.stroke(255,0,0);
      //output.noFill();
      output.fill(255);
      //output.noStroke();

      output.beginShape();
      for (PVector point : points) {
        output.vertex(point.x, point.y);
      }
      output.endShape();
      output.noFill();
      drawMultipleOutlines(output,points,20);
    }
  }

  output.endDraw();
  return output;
}

public void drawMultipleOutlines(PGraphics pg, ArrayList<PVector> points, int count) {
  PVector average = new PVector();
  for (PVector p : points) {
    average.add(p);
  }
  average.div(points.size());
  for (int i =0; i < count; i++) {
    float n = 1.0 * i / count;  
    pg.stroke(255,0,0,(1-n) * 255); 
    n /= 3;

    pg.beginShape();
    for (PVector point : points) {
      point = PVector.lerp(point,average,-n);   
      pg.vertex(point.x, point.y);
    }
    pg.endShape(CLOSE);
  }
}

PImage[] imgHistory = new PImage[3];

public PImage calculateImageHistory(PImage newImg) {
  for (int i = 0; i < imgHistory.length - 1; i++) {
    imgHistory[i] = (imgHistory[i + 1] != null) ? imgHistory[i + 1] : newImg;
  }
  imgHistory[imgHistory.length-1] = newImg;

  PGraphics output = createGraphics(width, height);
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