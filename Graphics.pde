public PGraphics drawGraphics() {
  //PGraphics pg = createGraphics(int(iW), int(iH));
  PGraphics pg = createGraphics(652,height);

  pg.beginDraw();
  pg.fill(100, 100, 255);
  pg.rect(0,0,pg.width,pg.height);
  pg.endDraw();

  return pg;
}

PVector tex0 = new PVector(0,0);
PVector tex1 = new PVector(width,0);
PVector tex2 = new PVector(width,height);
PVector tex3 = new PVector(0,height);

public void drawTexture() {
  textureMode(NORMAL);
}