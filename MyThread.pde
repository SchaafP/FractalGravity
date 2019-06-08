class MyThread extends Thread{
   ArrayList<Body> List;
   ArrayList<Body> Bodies;
   double dt;
 
   public MyThread(ArrayList<Body> List, ArrayList<Body> Bodies, double dt){
      this.List = List;
      this.Bodies = Bodies;
      this.dt = dt;
   }
 
   public void run(){
      List = iterateparticles(List, Bodies, dt);
   }
}
