class Body {
  public Body(double x1_, double x2_, double m_, color c_) {
    x1    = x1_;
    x2    = x2_;
    x1_0  = x1_;
    x2_0  = x2_;
    m     = m_;
    c     = c_;

  }
  color c;        // color of landing Planet
  double x1_0;    // initial x position
  double x1;      // current x position
  double x2_0;    // initial y position
  double x2;      // current y position
  double v1;      // current x velocity
  double v2;      // current y velocity
  double m;       // mass
  boolean done = false;
  boolean added = false;
}
