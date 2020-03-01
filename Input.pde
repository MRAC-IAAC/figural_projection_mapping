public void keyPressed() {
  if (key == '1') {
    vertexId = 0;
  } else if (key == '2') {
    vertexId = 1;
  } else if (key == '3') {
    vertexId = 2;
  } else if (key == '4') {
    vertexId = 3;
  } else if (key == 'r') {
    setupSize();
  }

  if (key == 's') {
    saveConfig();
  }

  if (key == 'l') {
    loadConfig();
  }
}

public void saveConfig() {
  ArrayList<String> out = new ArrayList<String>();

  out.add(vertices[0].x + "");
  out.add(vertices[0].y + "");
  out.add(vertices[1].x + "");
  out.add(vertices[1].y + "");
  out.add(vertices[2].x + "");
  out.add(vertices[2].y + "");
  out.add(vertices[3].x + "");
  out.add(vertices[3].y + "");

  String[] outStrings = new String[out.size()];
  for (int i= 0; i < out.size(); i++) {
    outStrings[i] = out.get(i);
  }
  saveStrings("config.txt", outStrings);
  println("Saved config file");
}

public void loadConfig() {

  String[] input = loadStrings("config.txt");
  vertices[0].x = float(input[0]);
  vertices[0].y = float(input[1]);
  vertices[1].x = float(input[2]);
  vertices[1].y = float(input[3]);
  vertices[2].x = float(input[4]);
  vertices[2].y = float(input[5]);
  vertices[3].x = float(input[6]);
  vertices[3].y = float(input[7]);
  println("Loaded config file");
}
