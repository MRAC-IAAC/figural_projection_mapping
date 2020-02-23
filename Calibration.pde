public void setupControlWindow() {
  controlWindow = GWindow.getWindow(this, "Calibration", 50, 50, 800, 600, P2D);
  controlWindow.addData(new GWinData());
  controlWindow.addDrawHandler(this, "controlDraw");
  controlWindow.addMouseHandler(this, "controlMouse");
  controlWindow.addKeyHandler(this, "controlKey");
}

public void controlDraw(PApplet pa, GWinData windata) {
  pa.textureMode(NORMAL);
  pa.background(0);
  pa.noFill();
  pa.noStroke();

  pa.pushMatrix();
  pa.translate((pa.width / 2) - (w4/2), (pa.height / 2) - (h4 / 2));

  drawProjection(pa,controlImg,4);
  
  pa.noFill();
  pa.stroke(100);
  pa.beginShape();
  pa.vertex(vertices[0].x / 4,vertices[0].y / 4);
  pa.vertex(vertices[1].x / 4,vertices[1].y / 4);
  pa.vertex(vertices[2].x / 4,vertices[2].y / 4);
  pa.vertex(vertices[3].x / 4,vertices[3].y / 4);
  pa.endShape(CLOSE);
  
  pa.noFill();
  pa.stroke(255);
  pa.strokeWeight(3);
  pa.rect(0, 0, w4, h4);

  pa.ellipse(vertices[vertexId].x / 4, vertices[vertexId].y / 4, 10, 10);
  pa.popMatrix();
  pa.fill(255);
  pa.text(frameRate, 20, 20);
}

public void controlMouse(PApplet pa, GWinData windata, MouseEvent mouseEvent) {
  int mod = mouseEvent.getAction();
  if (mod  == MouseEvent.PRESS || mod  == MouseEvent.DRAG) {
    int x = mouseEvent.getX();
    int y = mouseEvent.getY();
    x -= ((pa.width / 2) - (w4 /2));
    y -= ((pa.height / 2) - (h4 / 2));
    x *= 4;
    y *= 4;

    moveCorner(x, y);
  }
}

public void controlKey(PApplet pa, GWinData windata, KeyEvent keyEvent) {
  int action = keyEvent.getAction();
  if (action == KeyEvent.PRESS) {
    char c = keyEvent.getKey();
    if (c == '1') {
      vertexId = 0;
    } else if (c == '2') {
      vertexId = 1;
    } else if (c == '3') {
      vertexId = 2;
    } else if (c == '4') {
      vertexId = 3;
    }
  }
}

public void moveCorner(int x, int y) {
  vertices[vertexId] = new PVector(x, y);
  //println(vertices);
}

public PVector quadLerp(PVector[] vertices, float u, float v) {
  PVector a = PVector.lerp(vertices[0], vertices[1], u);
  PVector b = PVector.lerp(vertices[3], vertices[2], u);
  PVector c = PVector.lerp(a, b, v);
  return(c);
}