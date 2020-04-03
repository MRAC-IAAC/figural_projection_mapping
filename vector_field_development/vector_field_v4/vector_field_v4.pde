// dynamic list with our points, PVector holds position
ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList<PVector> direction = new ArrayList<PVector>();

// colors used for points
color[] pal = {
  color(0, 91, 197), 
  color(0, 180, 252), 
  color(23, 249, 255), 
  color(223, 147, 0), 
  color(248, 190, 0)
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

  // noiseSeed(1111); // sometimes we select one noise field

  // divide the screen in points
  for (float x=0; x<=width; x+= 20) {
    for (float y=0; y<=height; y+= 20) {
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
  int point_idx = 0; // point index 
  for (int i=0; i<points.size(); i++) {
    PVector p = points.get (i);
    PVector d = direction.get (i);
    if (dist(mouseX, mouseY, p.x, p.y) < 60) {
      d.add((mouseX-pmouseX), (mouseY-pmouseY));
      d.normalize();
      d.mult(40);
    }

    // select color from palette (index based on noise)
    int cn = (int)(100*pal.length*noise(point_idx))%pal.length;
    stroke(pal[cn], 255);
    point(p.x, p.y); //draw
    stroke(pal[cn], 200);
    line (p.x, p.y, p.x+d.x, p.y+d.y);

    // placeholder for vector field calculations

    // v is vector from the field/ change the values so they start moving
    PVector v = new PVector(0.0, 0.0);

    p.x += vector_scale * v.x;
    p.y += vector_scale * v.y;

    // go to the next point
    point_idx++;
  }
  time += 0.001;
}
