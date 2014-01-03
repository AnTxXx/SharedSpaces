class Moon{
  
    private int colR=0, colG=0, colB=0; // COLOR
    private int xPos, yPos, direction;
    private int size = 14;
    private int angle = 0;
    private Planet planet; 
    color col;
    public Moon(color col, Planet planet) {
      this.col = col;
      
      
      this.xPos = 50;
      this.yPos = 50;  
      this.planet = planet;
    }
    
    
    public void display() {
       angle += 3;
       //refreshPosition();
       pushMatrix();
       translate(planet.getxPos(), planet.getyPos());
       rotate(radians(angle%360));
       fill(col);
       ellipse(xPos,yPos,size,size);
       //xpos anpassen
       popMatrix();
       
      }      
}
