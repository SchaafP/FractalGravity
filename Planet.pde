// GUI Punkte für die Planeten, welche man platzieren kann
class Planet {
  public Planet(double x_, double y_, double m_, color c_) {
    x   = x_;
    y   = y_;
    m   = m_;
    c   = c_;
  }
  double x;
  double y;
  double m;
  color c;

  boolean onGrid() {
    String x1_ = cp5.get(Textfield.class, "x1").getText();
    float x1 = isFloat(x1_) ? Float.parseFloat(x1_) : 0;
    
    String y1_ = cp5.get(Textfield.class, "y1").getText();
    float y1 = isFloat(y1_) ? Float.parseFloat(y1_) : 0;
    
    String x2_ = cp5.get(Textfield.class, "x2").getText();
    float x2 = isFloat(x2_) ? Float.parseFloat(x2_) : 0;
    
    String y2_ = cp5.get(Textfield.class, "y2").getText();
    float y2 = isFloat(y2_) ? Float.parseFloat(y2_) : 0;
    
    return ((x > x1) && (x < x2) && (y < y1) && (y > y2));
  }
  void show() {
    String x1_ = cp5.get(Textfield.class, "x1").getText();
    float x1 = isFloat(x1_) ? Float.parseFloat(x1_) : 0;
    String y1_ = cp5.get(Textfield.class, "y1").getText();
    float y1 = isFloat(y1_) ? Float.parseFloat(y1_) : 0;
    String x2_ = cp5.get(Textfield.class, "x2").getText();
    float x2 = isFloat(x1_) ? Float.parseFloat(x2_) : 0;
    String y2_ = cp5.get(Textfield.class, "y2").getText();
    float y2 = isFloat(y1_) ? Float.parseFloat(y2_) : 0;
    fill(c);
    ellipse(
      map((float)x,x1,x2,gridx,gridx+gridwidth),
      map((float)y,y1,y2,gridy,gridy+gridwidth),
      15,
      15    
    );
  }
}
