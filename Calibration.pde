public void setupControlWindow() {
  controlWindow = GWindow.getWindow(this, "Calibration", 50, 50, 800, 600, P2D);
  controlWindow.addData(new GWinData());
  controlWindow.addDrawHandler(this, "controlDraw");
  controlWindow.addMouseHandler(this, "controlMouse");
  controlWindow.addKeyHandler(this, "controlKey");

  // Letting the control PApplet run its own draw loop apparently causes a memory leak?
  controlWindow.noLoop();
}

public void controlDraw(PApplet pa, GWinData windata) {
  controlApplet = pa;

  pa.textureMode(NORMAL);
  pa.background(0);
  pa.fill(0);
  pa.rect(0, 0, pa.width, pa.height);
  pa.noFill();
  pa.noStroke();

  pa.pushMatrix();
  pa.translate((pa.width / 2) - (w4/2), (pa.height / 2) - (h4 / 2));

  drawProjection(pa, controlImg, 4);

  pa.noFill();
  pa.stroke(100);
  pa.beginShape();
  pa.vertex(vertices[0].x / 4, vertices[0].y / 4);
  pa.vertex(vertices[1].x / 4, vertices[1].y / 4);
  pa.vertex(vertices[2].x / 4, vertices[2].y / 4);
  pa.vertex(vertices[3].x / 4, vertices[3].y / 4);
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

    if (key == 's') {
      saveConfig();
    }

    if (key == 'l') {
      loadConfig();
    }
  }
}

public void moveCorner(int x, int y) {
  vertices[vertexId] = new PVector(x, y);
  //println(vertices);
}

/**
We lerp the individual values instead of using several PVector.lerp to avoid instantiating 
a lot of objects in the u/v loops
**/
public void quadLerp(PVector dst,PVector[] vertices, float u, float v) {
  float ax = lerp(vertices[0].x,vertices[1].x,u);
  float ay = lerp(vertices[0].y,vertices[1].y,u);
  
  float bx = lerp(vertices[3].x,vertices[2].x,u);
  float by = lerp(vertices[3].y,vertices[2].y,u);
  
  float cx = lerp(ax,bx,v);
  float cy = lerp(ay,by,v);
  
  dst.x = cx;
  dst.y = cy;
}


public void drawProjection(PApplet pa, PImage tex, int scale) {
  pa.pushMatrix();
  pa.scale(-1,1);
  pa.translate(-pa.width,0);
  float diff = 0.05;
  for (float u = 0; u < 1; u += diff) {
    for (float v = 0; v < 1; v += diff) {
      pa.beginShape();
      pa.texture(tex);
      quadLerp(subVertices[0],vertices, u, v);
      quadLerp(subVertices[1],vertices, u+diff, v);
      quadLerp(subVertices[2],vertices, u+diff, v+diff);
      quadLerp(subVertices[3],vertices, u, v+diff);
      
      subVertices[0].div(scale);
      subVertices[1].div(scale);
      subVertices[2].div(scale);
      subVertices[3].div(scale);
      
      quadLerp(subTexVertices[0],texVertices, u, v);
      quadLerp(subTexVertices[1],texVertices, u+diff, v);
      quadLerp(subTexVertices[2],texVertices, u+diff, v+diff);
      quadLerp(subTexVertices[3],texVertices, u, v+diff); 

      pa.vertex(subVertices[0].x, subVertices[0].y, subTexVertices[0].x, subTexVertices[0].y);
      pa.vertex(subVertices[1].x, subVertices[1].y, subTexVertices[1].x, subTexVertices[1].y);
      pa.vertex(subVertices[2].x, subVertices[2].y, subTexVertices[2].x, subTexVertices[2].y);
      pa.vertex(subVertices[3].x, subVertices[3].y, subTexVertices[3].x, subTexVertices[3].y);
      pa.endShape();
    }
  }
  pa.popMatrix();
}
