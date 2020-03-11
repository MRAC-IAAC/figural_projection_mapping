public ArrayList<Particle> particles;

public void setupParticles() {
  particles = new ArrayList<Particle>();
  for (int i =0; i < 100; i++) {
    particles.add(new Particle(new PVector(random(width), random(height)), 0xFF00AAFF));
  }
}

public void updateParticles() {
  for (Particle part : particles) {
    part.update();
  }
  for (Particle part : particles) {
    part.draw(graphics);
  }
}

public class Particle {
  PVector position;
  PVector velocity;
  float maxVelocity = 3 + random(-0.2, 0.2);
  int particleColor;

  public Particle(PVector position, int particleColor) {
    this.position = position;
    this.particleColor = particleColor;
    this.velocity = new PVector(0, 0);
  }

  public void draw(PGraphics pg) {
    pg.stroke(particleColor);
    pg.ellipse(position.x, position.y, 3, 3);
  }

  public void update() {

    velocity.add(0, 0.1);



    if (velocity.mag() > maxVelocity) {
      velocity = velocity.normalize();
      velocity = velocity.mult(maxVelocity);
    }

    for (Contour c : currentContours) {
      testContour(c);
    }

    position.add(velocity);


    if (position.y > height) {
      position.y = 0;
      position.x = random(width);
    }

    if (position.x < (width - depthCamera.scaledWidth) / 2) {
      position.x = (width - depthCamera.scaledWidth) / 2;
      velocity.x = -velocity.x;
    }
    if (position.x > (width- ((width - depthCamera.scaledWidth) / 2))) {
      position.x = (width - ((width - depthCamera.scaledWidth) / 2));
      velocity.x = -velocity.x;
    }
  }

  public void testContour(Contour c) {
    if (c.containsPoint((int)position.x, (int)position.y)) {
      ArrayList<PVector> points = c.getPoints();
      float bestDistance = 999999999;
      PVector bestPoint = null;
      for (PVector point : points) {
        float d = PVector.dist(point, position);
        if (bestPoint == null || d < bestDistance) {
          bestPoint = point;
          bestDistance = d;
        }
      }
      PVector vec = PVector.sub(bestPoint, position);
      position = PVector.lerp(position,bestPoint,0.5);
      vec.normalize();
      vec.mult(3);
      velocity.add(vec);
    }
  }
}