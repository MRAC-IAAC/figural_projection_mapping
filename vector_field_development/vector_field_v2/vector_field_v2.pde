// dynamic list with our points, PVector holds position
ArrayList<PVector> points = new ArrayList<PVector>();
 
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
  strokeWeight(2);
  background(0, 5, 25);
  noFill();
  smooth(8);
 
  // noiseSeed(1111); // sometimes we select one noise field
 
  // create points from [-3,3] range
  for (float x=-3; x<=3; x+=0.1) {
    for (float y=-3; y<=3; y+=0.1) {
      // create point slightly distorted
      PVector v = new PVector(x+randomGaussian()*0.003, y+randomGaussian()*0.003);
      points.add(v);
    }
  }
}
 
void draw() {
  int point_idx = 0; // point index
  for (PVector p : points) {
    // map floating point coordinates to screen coordinates
    float xx = map(p.x, -6.5, 6.5, 0, width);
    float yy = map(p.y, -6.5, 6.5, 0, height);
    float angle = map (mouseX, 0, width, 0, TWO_PI);
     
    // select color from palette (index based on noise)
    int cn = (int)(100*pal.length*noise(point_idx))%pal.length;
    stroke(pal[cn], 15);
    point(xx, yy); //draw
    line (xx,yy,40,0);
    translate(50, 50);
    rotate(angle);
 
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
