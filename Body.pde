class Body {
  public Body(double x1_, double x2_, double m_, color c_) {
    x1    = x1_;
    x2    = x2_;
    x1_0  = x1_;
    x2_0  = x2_;
    m     = m_;
    c     = c_;

  }
  color c;
  double x1_0;
  double x1;
  double x2_0;
  double x2;
  double v1;
  double v2;
  double m;
  boolean done = false;
  boolean added = false;
}
