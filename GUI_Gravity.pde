/* TODO:
 
 - dt Input
 - draw_every Input
 - corecount Input
 - continous Render Bang
 - save images when rendering?
 - draw image at correct location
 - bugtracking
 
 */
// Buttons und Textfelder
import controlP5.*;

// GUI handle
ControlP5 cp5;

String arg1, arg2, arg3, arg4, arg5, arg6;

// Display-Image location
int gridx;
int gridy;

//Display-Image size
int gridwidth;

// Thread-Number
int corecount = 8;
int draw_every = 100; // continous Render parameter - unused atm

boolean isZooming;
boolean isZoomDisplay = true;
boolean isJulia;
boolean isJuliaDisplay = false;

// List of massive Bodies
ArrayList<Planet> Planets = new ArrayList<Planet>();

// timestep
float dt = 0.05;

// Display-Images
PImage img;
PImage img_Julia;

void settings() {
  noSmooth();
  size(1000, 1000);
}

void setup() {
  gridx = 10;
  gridy = 75;
  gridwidth = width - 170;
  background(75);
  InitializeUI();
  isZooming = false;
}

void draw() {

  background(75);
  updateUIPositions();
  drawUI();
}


void drawUI() {
  drawPlanetOptions();

  drawGridOptions();
  if (img == null) {
    drawGrid();
  } else {
    if (isJuliaDisplay) {
      drawJuliaImage();
    } else if (isZoomDisplay) {
      drawImage();
    }
  }
  if (isZooming) {
    drawZoomUI();
  }
  if (isJulia) {
    drawJuliaUI();
  }
  if (!isJuliaDisplay && isZoomDisplay) {
    drawPlanets();
  }
}

void switchView() {
  if (img != null && img_Julia != null) {
    isJuliaDisplay = !isJuliaDisplay;
    isZoomDisplay = !isZoomDisplay;
  }
}

void drawImage() {
  pushMatrix();
  rotate(radians(90));
  translate( gridy - 10, -width + 85);
  image(img, gridx, gridy, gridwidth, gridwidth);
  popMatrix();

  textSize(30);
  text("Normal View", width/2 - 100, 50);
}

void drawJuliaImage() {
  pushMatrix();
  rotate(radians(90));
  translate( gridy - 10, -width + 85);
  image(img_Julia, gridx, gridy, gridwidth, gridwidth);
  popMatrix();

  textSize(30);
  text("Julia View", width/2 - 100, 50);
}

void drawPlanets() {
  stroke(0);
  strokeWeight(2);
  for (Planet p : Planets) {
    if (p.onGrid()) {
      p.show();
    }
  }
  noStroke();
}


void drawPlanetOptions() {
  // Planet Options Background
  fill(125);
  rect(width - 150, 380, 140, 300);
}

void drawGridOptions() {
  // Grid Options Background
  fill(125);
  rect(width - 150, 75, 140, 300);

  // Rote Punkte an den Ecken
  fill(255, 0, 0);
  ellipse(10, 75, 7, 7);
  ellipse(10 + width - 170, 75 + height - 170, 7, 7);

  // Ecken Koordinaten Beschriftung
  fill(255);
  String x1 = cp5.get(Textfield.class, "x1").getText();
  String y1 = cp5.get(Textfield.class, "y1").getText();
  String x2 = cp5.get(Textfield.class, "x2").getText();
  String y2 = cp5.get(Textfield.class, "y2").getText();
  textSize(12);
  text(x1 + ", " + y1, 10, 60);
  text(x2 + ", " + y2, width - 220, height - 80);
}

void Julia() {
  isJulia = !isJulia;
  isZooming = false;
  println("clicked Julia Button");
}

void Zoom() {
  isZooming = !isZooming;
  isJulia = false;
  println("clicked Zoom Button");
}

void drawJuliaUI() {

  strokeWeight(2);
  stroke(255, 0, 0);
  if (mouseInGrid()) {
    fill(255, 0, 0);
    ellipse(mouseX, mouseY, 10, 10);
    noFill();
    ellipse(mouseX, mouseY, 35, 35);
    ellipse(mouseX, mouseY, 50, 50);
  }
  noStroke();
}

void drawZoomUI() {

  noFill();
  strokeWeight(2);
  stroke(255, 0, 0);
  if (mouseInGrid()) {
    rect(mouseX - (float)gridwidth/4, mouseY - (float)gridwidth/4, (float)gridwidth/2, (float)gridwidth/2);
  }
  noStroke();
}


///////////////////////////////////////////////////////
///////////////////// Renderers ///////////////////////
///////////////////////////////////////////////////////
void Render() {
  arg1 = cp5.get(Textfield.class, "Amount").getText();
  arg2 = cp5.get(Textfield.class, "x1").getText();
  arg3 = cp5.get(Textfield.class, "y1").getText();
  arg4 = cp5.get(Textfield.class, "x2").getText();
  arg5 = cp5.get(Textfield.class, "y2").getText();
  arg6 = cp5.get(Textfield.class, "Iterations").getText();

  int amount = isInteger(arg1) ? Integer.parseInt(arg1) : -1;
  int iterations = isInteger(arg6) ? Integer.parseInt(arg6) : -1;
  float x1 = isFloat(arg2) ? Float.parseFloat(arg2) : -1;
  float y1 = isFloat(arg3) ? Float.parseFloat(arg3) : -1;
  float x2 = isFloat(arg4) ? Float.parseFloat(arg4) : -1;
  float y2 = isFloat(arg5) ? Float.parseFloat(arg5) : -1;

  Renderer R = new Renderer(Planets, x1, y1, x2, y2, dt, amount, iterations, corecount, draw_every);
  R.initialize();
  R.iterate();
  R.update_img();
  img = R.img;
  isZoomDisplay = true;
  isJuliaDisplay = false;
  println("done");
}

void JuliaRender() {
  arg1 = cp5.get(Textfield.class, "Amount").getText();
  arg2 = cp5.get(Textfield.class, "x1").getText();
  arg3 = cp5.get(Textfield.class, "y1").getText();
  arg4 = cp5.get(Textfield.class, "x2").getText();
  arg5 = cp5.get(Textfield.class, "y2").getText();
  arg6 = cp5.get(Textfield.class, "Iterations").getText();

  int amount = isInteger(arg1) ? Integer.parseInt(arg1) : -1;
  int iterations = isInteger(arg6) ? Integer.parseInt(arg6) : -1;
  PVector p = relativeXY();

  Renderer JR = new Renderer(Planets, p.x, p.y, 0, 0, dt, amount, iterations, corecount, draw_every);
  JR.isJuliaRenderer = true;
  
  String vrange_ = cp5.get(Textfield.class, "VRange").getText();
  float vrange = isFloat(vrange_) ? Float.parseFloat(vrange_) : 0;
  
  JR.juliaVRange = vrange; // velocity range
  JR.initialize();
  JR.iterate();
  JR.update_img();
  img_Julia = JR.img;
  isJuliaDisplay = true;
  isZoomDisplay = false;
  println("done");
}
///////////////////////////////////////////////////////
/////////////////// Renderers-end /////////////////////
///////////////////////////////////////////////////////


int maxDrawSize = 500;
int minDrawSize = 3;
void drawGrid() {
  fill(125);
  rect(gridx, gridy, gridwidth, gridwidth);
  String s = cp5.get(Textfield.class, "Amount").getText();
  int size = 0;
  if (isInteger(s)) {
    size = Integer.parseInt(s);
  }
  if (size > maxDrawSize) {
    size = maxDrawSize;
  } else if (size < minDrawSize) {
    size = minDrawSize;
  }

  stroke(125);
  strokeWeight(1);
  fill(255);

  int x1 = gridx;
  int y1 = gridy;

  double stepsize = ((double)(gridwidth)) / (double)size;
  for (int i = 0; i < size; i++) {
    for (int j = 0; j < size; j++) {
      rect(
        (float)x1 + (float)(stepsize*i), 
        (float)y1 + (float)(stepsize *j), 
        (float)stepsize, 
        (float)stepsize);
    }
  }
}

void mouseClicked() {
  // Right clicking aborts Render-Actions
  if (isZooming) {
    if (mouseButton == RIGHT) {
      isZooming = !isZooming;
      println("zooming aborted");
    }
  }
  if (isJulia) {
    if (mouseButton == RIGHT) {
      isJulia = !isJulia;
      println("Julia aborted");
    }
  }


  if (isZooming && !isJulia && mouseInGrid()) {  // ZOOM
    if (mouseButton == LEFT) {
      handleZoom();
      isZooming = !isZooming;
      println("done Zooming");
      Render();
    } else if (isZooming && !isJulia && !mouseInGrid()) { // not clicking in Grid aborts
      isZooming = !isZooming;
      println("zooming aborted");
    }
  }
  if (!isZooming && !isJulia && mouseInGrid()) {  // get location
    PVector p = relativeXY();
    cp5.get(Textfield.class, "PlanetX").setText(str(p.x));
    cp5.get(Textfield.class, "PlanetY").setText(str(p.y));
  }

  /////////////////////////////////////////////////////////
  if (!isZooming && isJulia && mouseInGrid()) {  // JULIA
    if (mouseButton == LEFT) {
      isJulia = !isJulia;
      println("done Julia");
      JuliaRender();
    } else if (!isZooming && isJulia && !mouseInGrid()) { // not clicking in Grid aborts
      isJulia = !isJulia;
      println("Julia aborted");
    }
  }
}


void handleZoom() {
  // get old x1, y1
  String oldx1_ = cp5.get(Textfield.class, "x1").getText();
  float oldx1 = isFloat(oldx1_) ? Float.parseFloat(oldx1_) : 0;
  String oldy1_ = cp5.get(Textfield.class, "y1").getText();
  float oldy1 = isFloat(oldy1_) ? Float.parseFloat(oldy1_) : 0;

  // get old x2, y2
  String oldx2_ = cp5.get(Textfield.class, "x2").getText();
  float oldx2 = isFloat(oldx1_) ? Float.parseFloat(oldx2_) : 0;
  String oldy2_ = cp5.get(Textfield.class, "y2").getText();
  float oldy2 = isFloat(oldy1_) ? Float.parseFloat(oldy2_) : 0;

  float relativeCenterX = map(mouseX, gridx, gridx+gridwidth, oldx1, oldx2);
  float relativeCenterY = map(mouseY, gridy, gridy+gridwidth, oldy1, oldy2);
  println(relativeCenterX);
  println(relativeCenterY);

  float newx1 = relativeCenterX - (oldx2 - oldx1)/4;
  float newy1 = relativeCenterY + (oldy1 - oldy2)/4;

  float newx2 = relativeCenterX + (oldx2 - oldx1)/4;
  float newy2 = relativeCenterY - (oldy1 - oldy2)/4;


  // set cp5.textfield stuff to new values
  cp5.get(Textfield.class, "x1").setText(str(newx1));
  cp5.get(Textfield.class, "y1").setText(str(newy1));
  cp5.get(Textfield.class, "x2").setText(str(newx2));
  cp5.get(Textfield.class, "y2").setText(str(newy2));
}

boolean mouseInGrid() {
  return ((mouseX > gridx && mouseX < gridx + gridwidth) && (mouseY > gridy && mouseY < gridy + gridwidth));
}

PVector relativeXY() {
  // get old x1, y1
  String oldx1_ = cp5.get(Textfield.class, "x1").getText();
  float oldx1 = isFloat(oldx1_) ? Float.parseFloat(oldx1_) : 0;
  String oldy1_ = cp5.get(Textfield.class, "y1").getText();
  float oldy1 = isFloat(oldy1_) ? Float.parseFloat(oldy1_) : 0;

  // get old x2, y2
  String oldx2_ = cp5.get(Textfield.class, "x2").getText();
  float oldx2 = isFloat(oldx1_) ? Float.parseFloat(oldx2_) : 0;
  String oldy2_ = cp5.get(Textfield.class, "y2").getText();
  float oldy2 = isFloat(oldy1_) ? Float.parseFloat(oldy2_) : 0;

  float relativeX = map(mouseX, gridx, gridx+gridwidth, oldx1, oldx2);
  float relativeY = map(mouseY, gridy, gridy+gridwidth, oldy1, oldy2);
  PVector p = new PVector(relativeX, relativeY);
  return p;
}

void AddPlanet() {
  if (isZoomDisplay) {
    String x_ = cp5.get(Textfield.class, "PlanetX").getText();
    float x = isFloat(x_) ? Float.parseFloat(x_) : 0;
    String y_ = cp5.get(Textfield.class, "PlanetY").getText();
    float y = isFloat(y_) ? Float.parseFloat(y_) : 0;
    String m_ = cp5.get(Textfield.class, "PlanetMass").getText();
    float m = isFloat(m_) ? Float.parseFloat(m_) : 0;

    boolean isContained = false;
    for (Planet p : Planets) {
      if (p.x == x && p.y == y) {
        isContained = true;
      }
    }

    if (!isContained) {
      Planets.add(new Planet(x, y, m, color(random(0, 255), random(0, 255), random(0, 255))));
    }
  }
}

void RemoveLastPlanet() {
  if (Planets.size() != 0) {
    Planets.remove(Planets.size()-1);
  }
}

void ZoomOut() {
  // get old x1, y1
  String oldx1_ = cp5.get(Textfield.class, "x1").getText();
  float oldx1 = isFloat(oldx1_) ? Float.parseFloat(oldx1_) : 0;
  String oldy1_ = cp5.get(Textfield.class, "y1").getText();
  float oldy1 = isFloat(oldy1_) ? Float.parseFloat(oldy1_) : 0;

  // get old x2, y2
  String oldx2_ = cp5.get(Textfield.class, "x2").getText();
  float oldx2 = isFloat(oldx1_) ? Float.parseFloat(oldx2_) : 0;
  String oldy2_ = cp5.get(Textfield.class, "y2").getText();
  float oldy2 = isFloat(oldy1_) ? Float.parseFloat(oldy2_) : 0;

  float newx1 = oldx1 - (oldx2 - oldx1)/2;
  float newy1 = oldy1 + (oldy1 - oldy2)/2;
  float newx2 = oldx2 + (oldx2 - oldx1)/2;
  float newy2 = oldy2 - (oldy1 - oldy2)/2;

  cp5.get(Textfield.class, "x1").setText(str(newx1));
  cp5.get(Textfield.class, "y1").setText(str(newy1));
  cp5.get(Textfield.class, "x2").setText(str(newx2));
  cp5.get(Textfield.class, "y2").setText(str(newy2));
}

// iterate function for MyThread needs to be in Main-file
ArrayList<Body> iterateparticles(ArrayList<Body> particles, ArrayList<Body> Bodies, double dt) {
  for (int i = particles.size() - 1; i > 0; i--) {
    Body p = particles.get(i);
    if (!p.done) {
      double a = 0;
      double a1 = 0;
      double a2 = 0;
      for (int j = 0; j < Bodies.size(); j++) {
        Body B = Bodies.get(j);
        double d = sqrt(pow(((float)B.x1 - (float)p.x1), 2)+pow(((float)B.x2 - (float)p.x2), 2));
        if (d < 10) {
          p.c = B.c;
          p.x1 = p.x1_0;
          p.x2 = p.x2_0;
          p.done = true;
        }
        if (!p.done) {
          a = Bodies.get(j).m * (1/(d*d*d));
          a1 += a * (B.x1 - p.x1);
          a2 += a * (B.x2 - p.x2);
        }
      }
      p.v1 += a1 * dt;
      p.v2 += a2 * dt;

      p.x1 += 0.5 * a1 * dt * dt + p.v1 * dt;
      p.x2 += 0.5 * a2 * dt * dt + p.v2 * dt;
    }
  }
  return particles;
}

void InitializeUI() {
  cp5 = new ControlP5(this);

  // Anzahl Partikel in x/y Richtung
  cp5.addTextfield("Amount")
    .setPosition(width-125, 100)
    .setSize(75, 25)
    .setAutoClear(false)
    .setValue("100"); // default size value

  // Links oben x
  cp5.addTextfield("x1")
    .setPosition(width-125, 150)
    .setSize(75, 25)
    .setAutoClear(false)
    .setValue("-100.0");

  // Links oben y
  cp5.addTextfield("y1")
    .setPosition(width-125, 200)
    .setSize(75, 25)
    .setAutoClear(false)
    .setValue("100.0");

  // Rechts unten x
  cp5.addTextfield("x2")
    .setPosition(width-125, 250)
    .setSize(75, 25)
    .setAutoClear(false)
    .setValue("100.0");

  // Rechts unten y
  cp5.addTextfield("y2")
    .setPosition(width-125, 300)
    .setSize(75, 25)
    .setAutoClear(false)
    .setValue("-100.0");

  // Render-Button
  cp5.addBang("Render")
    .setPosition(width - 125, height - 125)
    .setSize(80, 20);

  cp5.addTextfield("Iterations")
    .setPosition(width - 125, height - 165)
    .setSize(75, 25)
    .setAutoClear(false)
    .setValue("1000");

  // Zoom-In-Button
  cp5.addBang("Zoom")
    .setPosition(width - 125, height - 245)
    .setSize(80, 20);

  cp5.addBang("ZoomOut")
    .setPosition(width - 125, height - 285)
    .setSize(80, 20);

  // Add-Planet-Button
  cp5.addBang("AddPlanet")
    .setPosition(width - 125, height - 440)
    .setSize(80, 20);  

  //Remove-Planet-Button
  cp5.addBang("RemoveLastPlanet")
    .setPosition(width - 125, height - 400)
    .setSize(80, 20);

  // Planet x
  cp5.addTextfield("PlanetX")
    .setPosition(width-125, height - 600)
    .setSize(75, 25)
    .setAutoClear(false)
    .setValue("0.0");

  // Planet y
  cp5.addTextfield("PlanetY")
    .setPosition(width-125, height - 550)
    .setSize(75, 25)
    .setAutoClear(false)
    .setValue("0.0");

  // Planet Mass
  cp5.addTextfield("PlanetMass")
    .setPosition(width-125, height - 500)
    .setSize(75, 25)
    .setAutoClear(false)
    .setValue("1000");

  cp5.addBang("Julia")
    .setPosition(width/2, height-50)
    .setSize(80, 20);
  
  cp5.addTextfield("VRange")
    .setPosition(width/2 - 100, height - 50)
    .setSize(80, 20)
    .setAutoClear(false)
    .setValue("5");

  cp5.addBang("switchView")
    .setPosition(50, height-50)
    .setSize(80, 20);
}
void updateUIPositions() {
  // Partikelzahl in x/y Richtung
  cp5.get(Textfield.class, "Amount").setPosition(width-125, 100);
  // Links oben x
  cp5.get(Textfield.class, "x1").setPosition(width-125, 150);
  // Links oben y
  cp5.get(Textfield.class, "y1").setPosition(width-125, 200);
  // Rechts unten x
  cp5.get(Textfield.class, "x2").setPosition(width-125, 250);
  // Rechts unten y
  cp5.get(Textfield.class, "y2").setPosition(width-125, 300);
  // Render-Button
  cp5.get(Bang.class, "Render").setPosition(width - 125, 1000 - 125);
  // Iterationen
  cp5.get(Textfield.class, "Iterations").setPosition(width - 125, 1000 - 165);
  // Zoom-In-Button
  cp5.get(Bang.class, "Zoom").setPosition(width - 125, 1000 - 245);
  //Zoom-Out-Button
  cp5.get(Bang.class, "ZoomOut").setPosition(width - 125, 1000 - 285);
  // Add-Planet-Button
  cp5.get(Bang.class, "AddPlanet").setPosition(width - 125, 1000 - 440);
  //Remove-Planet-Button
  cp5.get(Bang.class, "RemoveLastPlanet").setPosition(width - 125, 1000 - 400);
  // Planet x
  cp5.get(Textfield.class, "PlanetX").setPosition(width-125, 1000 - 600);
  // Planet y
  cp5.get(Textfield.class, "PlanetY").setPosition(width-125, 1000 - 550);
  // Planet Mass
  cp5.get(Textfield.class, "PlanetMass").setPosition(width-125, 1000 - 500);
  //Julia-Button
  cp5.get(Bang.class, "Julia").setPosition(width/2, height-50);
  
  cp5.get(Textfield.class, "VRange").setPosition(width/2 - 100, height - 50);
}


boolean isInteger(String s) {
  boolean result = false;
  try {
    Integer.parseInt(s);
    result = true;
  }
  catch(NumberFormatException e) {
  }
  return result;
}

boolean isFloat(String s) {
  boolean result = false;
  try {
    Float.parseFloat(s);
    result = true;
  }
  catch(NumberFormatException e) {
  }
  return result;
}
