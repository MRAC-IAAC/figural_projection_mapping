public PGraphics drawGraphics() {
  PGraphics pg = createGraphics(int(iW), int(iH));

  pg.beginDraw();
  pg.fill(100, 100, 255);
  pg.endDraw();

  return pg;
}