public void drawProjection(PApplet pa,PImage tex, int scale) {
    float diff = 0.05;
  for (float u = 0; u < 1; u += diff) {
    for (float v = 0; v < 1; v += diff) {
      pa.beginShape();
      pa.texture(tex);
      PVector v1 = quadLerp(vertices, u, v).div(scale);
      PVector v2 = quadLerp(vertices, u+diff, v).div(scale);
      PVector v3 = quadLerp(vertices, u+diff, v+diff).div(scale);
      PVector v4 = quadLerp(vertices, u, v+diff).div(scale);
      PVector vt1 = quadLerp(texVertices, u, v);
      PVector vt2 = quadLerp(texVertices, u+diff, v);
      PVector vt3 = quadLerp(texVertices, u+diff, v+diff);
      PVector vt4 = quadLerp(texVertices, u, v+diff); 

      pa.vertex(v1.x, v1.y, vt1.x, vt1.y);
      pa.vertex(v2.x, v2.y, vt2.x, vt2.y);
      pa.vertex(v3.x, v3.y, vt3.x, vt3.y);
      pa.vertex(v4.x, v4.y, vt4.x, vt4.y);
      pa.endShape();
    }
  }
}