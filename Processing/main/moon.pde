class Moon{
  
    private int colR=0, colG=0, colB=0; // COLOR
    private int xPos, yPos, direction;
    private int size = 14;
    private int angle = 0;
    private Planet planet; 
    private color col;
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
       fill(this.col);
       translate(planet.getxPos(), planet.getyPos());
       rotate(radians(angle%360));
       
       ellipse(xPos,yPos,size,size);

       popMatrix();
       
      }      
      
      public void setColor(color col) {
        this.col=col;
      }
      
      public color getColor() {
        return this.col;
      }
}
