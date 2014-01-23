class Moon{
  
    private int colR=0, colG=0, colB=0; // COLOR
    private int xPos, yPos, direction;
    private int size = 17;
    private int angle = 0;
    private Planet planet; 
    private color col, changeCol;
    
    private boolean moonChange=false;
    private int moonCounter=0;
    
    public Moon(color col, Planet planet) {
      this.col = col;
      this.xPos = 50;
      this.yPos = 50;  
      this.planet = planet;
    }
    
    
    public void display() {
       angle += 3;
       //refreshPosition();
       
       int offset = getMoonOffset();
       
       pushMatrix();
       noStroke();
       fill(this.col);
       translate(planet.getxPos(), planet.getyPos());
       rotate(radians(angle%360));
       ellipse(xPos+offset,yPos,size,size);
       
       popMatrix();
       
       
       for(int i=1; i<10; i++) {
         pushMatrix();
         noStroke();
         fill(this.col, 170-i*15);
         translate(planet.getxPos(), planet.getyPos());
         rotate(radians((angle-i*4)%360));
         ellipse(xPos+offset,yPos,size-i,size-i);
         popMatrix();
       }
       
       
       
       int angleInv = 360-angle;
       
       pushMatrix();
       noStroke();
       fill(this.col);
       translate(planet.getxPos(), planet.getyPos());
       rotate(radians(angleInv%360));
       ellipse(xPos+30+offset,yPos,size,size);
       
       popMatrix();
       
       
       for(int i=1; i<10; i++) {
         pushMatrix();
         noStroke();
         fill(this.col, 170-i*15);
         translate(planet.getxPos(), planet.getyPos());
         rotate(radians((angleInv+i*4)%360));
         ellipse(xPos+30+offset,yPos,size-i,size-i);
         popMatrix();
       }
       
      }      
      
      
      public void triggerMoonChange(color c) {
        moonCounter=1;
        moonChange=true;
        changeCol=c;
      }
      
      public int getMoonOffset() {
         if(moonCounter<=0) {
           return 0;
         } 
         
         if((moonCounter<CANVAS_Y) && (moonChange)) {
           moonCounter+=8;
         } else {
           moonCounter-=8;
           moonChange=false;
           col=changeCol;
         }
         
         return moonCounter;
      }
      
      
      public void setColor(color col) {
        this.col=col;
      }
      
      public color getColor() {
        return this.col;
      }

}
