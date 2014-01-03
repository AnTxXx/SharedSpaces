class Planet{
  
    private int colR=0, colG=0, colB=0; // COLOR
    private int xPos, yPos, direction;
    
    private int size = 50;
    private int sizeOrig = 50;
    private Moon moon;
    private int id;
    color col;
    private int angle = 0;
    
    private boolean pulsating = false;
    private boolean pulse_growing = false;
    
    private boolean growing = false;
    
    private int idle_counter = 0;
    
    public Planet(int id, int x, int y, color col) {

      this.col = col;
      this.xPos = x;
      this.yPos = y;
      
      this.id = id;
      
      moon = new Moon(this.col, this);
      
    }
     
    public void display() {
        moon.display();
        fill(col);
        
        
        if(pulsating == true){
          pulsate();
        }else if(growing == true){
          grow();
        }else if(pulsating == false){
          resetSize();
        }else if (growing == false){
          resetSize();
        }
        
        ellipse(xPos,yPos,size,size);
        //refreshPosition();
        //0-360 radians
        //println(angle);

        pushMatrix();
        translate(xPos, yPos);
        rotate(radians(angle));
        
        fill(col);
        triangle(0,0-size*0.7,    0-size*0.1, 0-size*0.6,     0+size*0.1, 0-size*0.6);   
        //xpos anpassen
        popMatrix();   
    
    }
    
    
    public void movePlanet(int xPos, int yPos, int angle){
      
      
      
      int xPos_old = this.xPos;
      int yPos_old = this.yPos;
      
      
      //xPos <= xPos_old + 50 && xPos >= xPos_old - 50 && yPos <= yPos_old + 50 && yPos >= yPos - 50
      
      
      
      
      if(xPos_old == xPos && yPos_old == yPos){
        idle_counter++;
      }else{
        idle_counter = 0;
      }
      
      this.xPos = xPos;
      this.yPos = yPos;   

      this.angle = angle;
      
      
    }
    
    public void moveKey(int dir){ 
     int xPos_old = xPos;
     int yPos_old = yPos; 
     
      switch(dir){
        case 1:
          yPos--;
          break;
        case 2:  
          yPos++;
          break;
        case 3:  
          xPos++;
          break;
        case 4:
          xPos--;
          break;
      }
      
      if(xPos_old == xPos && yPos_old == yPos){
        idle_counter++;
      }else{
        idle_counter = 0;
      }
      
    }
    public void rotateKey(int angle){
      this.angle = angle;
    }
    
    public void togglePulse(){
      if(pulsating == true){
        pulsating = false;
      }else if(pulsating == false){
        pulsating = true;
        
      }
    }
    
    public void toggleGrow(){
      if(growing == true){
        growing = false;
      }else if(growing == false){
        growing = true;  
      }
    }
    
    private void pulsate(){
      //hier die size ändern
      
      if(size == 80){
        pulse_growing = false;
      }else if(size == 50){
        pulse_growing = true;
      }
      
      if(pulse_growing == true && size < 80){
        size++;
      }else if(pulse_growing == false && size > 50){
        size--;
      }
    }
    
    private void grow(){
      if(size < 80){
        if(idle_counter%10 == 0){
          size++;
        }  
      }
    }
    
    private void resetSize(){
      if(size > 50){
        size--;
      }
    }
    
    public int getID(){
      return id;
    }
    
    public int getxPos(){
      return xPos;
    }
    
    public int getyPos(){
      return yPos;
    }
    
    public boolean isPulsating(){
      return pulsating;
    }
    
    public boolean isGrowing(){
      return growing;
    }
    
    public int getIdle(){
      return idle_counter;
    }
}
