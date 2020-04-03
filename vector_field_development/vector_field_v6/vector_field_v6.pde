// dynamic list with our points, PVector holds position
ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList<PVector> direction = new ArrayList<PVector>();

// colors used for points
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

void setup() {
  size(1800, 1000);
  strokeWeight(1);
  background(0, 5, 25);
  noFill();
  smooth();

  // divide the screen in points
  for (float x=0; x<=width; x+= 14) {
    for (float y=0; y<=height; y+= 14) {
      // create point slightly distorted
      PVector v = new PVector(x+randomGaussian()*0.003, y+randomGaussian()*0.003);
      points.add(v);
      PVector d = new PVector(10, 10);
      direction.add(d);
    }
  }
}

void draw() {
  background(0);
  PVector mouse = new PVector((mouseX-pmouseX), (mouseY-pmouseY));

  int point_idx = 0; // point index 
  for (int i=0; i<points.size(); i++) {
    PVector p = points.get (i);
    PVector d = direction.get (i);
    PVector mouse2 = mouse.get();
    float s = dist(mouseX, mouseY, p.x, p.y); 
    //distance between mouse-point)
    if (s < 80) {
      //distance between mouse movement
      mouse2.mult(map(s, 0, 80, 1, 0)); 
      d.add(mouse2);
      if (d.mag() > 80) {
        d.normalize();
        d.mult(80);
      }
    }

    //// select color from palette (index based on noise)
    //int cn = (int)(100*pal.length*noise(point_idx))%pal.length;
    //stroke(pal[cn], 255);
    //point(p.x, p.y); //draw
    //stroke(pal[cn], 200);
    //line (p.x, p.y, p.x+d.x, p.y+d.y);
    
    int cn = (int)(100*pal2.length*noise(point_idx))%pal2.length;
    stroke(pal2[cn], 255);//point transparecy
    point(p.x, p.y); //draw
    stroke(pal2[cn], 200);//vector transparency
    line (p.x, p.y, p.x+d.x, p.y+d.y);//draw

    // go to the next point
    point_idx++;
  }
  time += 0.001;
}
