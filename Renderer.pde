/* TODO:
 
 - generate apropiate amount of colours!
 - 
 
 
 
 */


class Renderer {
  boolean isJuliaRenderer;
  double juliaVRange;
  PImage img;
  double x1, y1, x2, y2, dt;
  int amount, iterations, corecount, draw_every;
  ArrayList<Body> Particles;
  ArrayList<Body> Particles_done;
  ArrayList<Body> Bodies;
  public Renderer(ArrayList<Planet> planets, float x1, float y1, float x2, float y2, float dt, int amount, int iterations, int corecount, int draw_every) {
    this.x1 = x1;
    this.y1 = y1;
    this.x2 = x2;
    this.y2 = y2;
    this.dt = dt;
    this.amount = amount;
    this.iterations = iterations;
    this.corecount = corecount;
    this.draw_every = draw_every;

    img = createImage(amount, amount, RGB);

    Particles = new ArrayList<Body>();
    Particles_done = new ArrayList<Body>();
    Bodies = new ArrayList<Body>();

    for (int i = 0; i < planets.size(); i++) {
      Planet p = planets.get(i);
      Bodies.add(new Body(p.x, p.y, p.m, p.c));
    }
  }

  void iterate() {
    ArrayList<Body>[] split_particles = (ArrayList<Body>[]) new ArrayList[corecount];
    split_particles = split_array_list_in_n_parts(Particles, corecount);
    MyThread[] thread_array = new MyThread[corecount];

    // Iterate until we want to draw again
    for (int i = 0; i < iterations; i++) {
      for (int j = 0; j < split_particles.length; j++) {
        thread_array[j] = new MyThread(split_particles[j], Bodies, dt);
        thread_array[j].start();
      }

      for (int j = 0; j < thread_array.length; j++) {
        try {
          thread_array[j].join();
        } 
        catch(InterruptedException e) {
          e.printStackTrace();
        }
        catch(NullPointerException n) {
          n.printStackTrace();
        }
      }
    }
    // rejoin Particles into one list
    Particles = join_array_of_arraylists(split_particles);
    // Handle particles that fell onto Bodies
    for (int i = 0; i < Particles.size(); i++) {
      Body p = Particles.get(i);
      if (p.done && !p.added) {
        Particles_done.add(p);
        p.added = true;
      }
    }
  }

  ArrayList<Body>[] split_array_list_in_n_parts(ArrayList<Body> List, int n) {
    ArrayList<Body>[] ret = (ArrayList<Body>[]) new ArrayList[n];
    int size = List.size();
    int chunklength = (int)(size/n);
    if (chunklength <= 2) {
      ret[0] = List;
      return ret;
    }
    int i = size - 1;
    for (int j = 0; j < n; j++) {
      ret[j] = new ArrayList<Body>();
      while (i > size - (j+1) * chunklength - 1) {
        ret[j].add(List.get(i));
        List.remove(i);
        i--;
      }
    }
    return ret;
  }


  ArrayList<Body> join_array_of_arraylists(ArrayList<Body>[] arr) {
    ArrayList<Body> ret = new ArrayList<Body>();
    for (int i = 0; i < arr.length; i++) {
      for (int j = 0; j < arr[i].size(); j++) {
        ret.add(arr[i].get(j));
      }
    }
    return ret;
  }


  void initialize() {
    if (!isJuliaRenderer) { // normal Renderer
      background(0);
      for (int i = Particles.size() - 1; i > 0; i--) {
        Particles.remove(i);
      }
      for (int i = Particles_done.size() - 1; i > 0; i--) {
        Particles_done.remove(i);
      }
      
      
      for (int x = 0; x < amount; x++) {
        for (int y = 0; y < amount; y++) {
          double xi = (float)map((float)x, 0, (float)amount, (float)x1, (float)x2);
          double yi = (float)map((float)y, 0, (float)amount, (float)y2, (float)y1);
          Particles.add(new Body(xi, yi, 0, color(255)));
        }
      }
      
      /*
      old method - buggy.
      double stepsize = ((double)(x2 - x1)) / ((double)amount);
      for (double x = x1; x < x2; x += stepsize) {
        for (double y = y2; y < y1; y += stepsize) {
          Particles.add(new Body(x, y, 0, color(255)));
        }
      }
      */
    } else {  // Julia Renderer
      background(0);
      for (int i = Particles.size() - 1; i > 0; i--) {
        Particles.remove(i);
      }
      for (int i = Particles_done.size() - 1; i > 0; i--) {
        Particles_done.remove(i);
      }

      for (double i = 0; i < amount; i++) {
        for (double j = 0; j < amount; j++) {
          float vi = map((float)i,0,amount,(float)-juliaVRange,(float)juliaVRange);
          float vj = map((float)j,0,amount,(float)-juliaVRange,(float)juliaVRange);
          Body toAdd = new Body(x1, y1, 0, color(255));
          toAdd.v1 = vi;
          toAdd.v2 = vj;
          Particles.add(toAdd);
        }
      }
    }
  }
  void update_img() {
    img.loadPixels();
    println(Particles.size());
    println(img.pixels.length);
    for (int i = Particles.size() - 1; i >= 0; i--) {
      img.pixels[i%img.pixels.length] = Particles.get(i).c;
    }
    img.updatePixels();
  }
}
