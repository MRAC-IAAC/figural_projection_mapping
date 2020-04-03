// dynamic list with our points, PVector holds position
ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList<PVector> direction = new ArrayList<PVector>();

// import sound library
import processing.sound.*;
Amplitude amp;
AudioIn in;
float ampt;

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
  size(1800, 1000, P2D);
  strokeWeight(1.5);
  background(0);
  noFill();
  smooth();

  // Create an Input stream which is routed into the Amplitude analyzer
  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  amp.input(in);

  // divide the screen in points
  for (float x=0; x<=width; x+= 14) {
    for (float y=0; y<=height; y+= 14) {
      // create point slightly distorted
      PVector v = new PVector(x+randomGaussian()*0.8, y+randomGaussian()*0.8);
      //asign vector to the created points
      points.add(v);
      PVector d = new PVector(12, 12);
      //d = PVector. random2D(v);
      direction.add(d);
    }
  }
}

void draw() {
  background(0);
  fill(0);
  rect(0, 0, 1800, 1000);
  PVector mouse = new PVector((mouseX-pmouseX), (mouseY-pmouseY));

  ampt = amp.analyze();

  //int point_idx = 0; // point index 
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
  }

  if (ampt >= 0.01) {
    resetField();
  }

  for (int i = 0; i < points.size(); i++) {
    //int point_idx = 0; // point index 
    PVector p = points.get (i);
    PVector d = direction.get (i);
    float s = dist(mouseX, mouseY, p.x, p.y);

    if (s < 80) {
      strokeWeight (2);
      stroke (58, 33, 122);
      line (p.x, p.y, p.x+d.x, p.y+d.y);//draw
      strokeWeight (1.5);
    }

    // select color from palette 
    float a = d.heading();
    if (a < 0) {
      int cn = (int)(100*pal.length*noise(i))%pal.length;
      stroke(pal[cn], 255);//point transparecy
      point(p.x, p.y); //draw
      stroke(pal[cn], 200);//vector transparency
      line (p.x, p.y, p.x+d.x, p.y+d.y);
    } else {
      int cn = (int)(100*pal2.length*noise(i))%pal2.length;
      stroke(pal2[cn], 255);//point transparecy
      point(p.x, p.y); //draw
      stroke(pal2[cn], 200);//vector transparency
      line (p.x, p.y, p.x+d.x, p.y+d.y);//draw
    }
  }
}


public void resetField() {
  for (PVector d : direction) {
    d.x = 12;
    d.y = 12;
  }
}

public void mousePressed() {
  resetField();
}
