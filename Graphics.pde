public PGraphics drawGraphics() {
  PGraphics pg = createGraphics(int(iW), int(iH));

  pg.beginDraw();
  pg.fill(100, 100, 255);
  pg.rect(0,0,pg.width,pg.height);
  pg.endDraw();

  return pg;
}
