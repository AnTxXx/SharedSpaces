import java.util.Map;
class SolarSystem{
    
     /*for poor key-processing*/
     int key_id;
     /*****/
  
  
    HashMap<Integer, Planet> planets = new HashMap<Integer, Planet>();
    //ArrayList<Planet> planets = new ArrayList<Planet>();
    JSONObject[] skeletons1 = new JSONObject[6];
    private  int CANVAS_X, CANVAS_Y;
    ArrayList<String> planet_colors = new ArrayList<String>();
    
    public SolarSystem(int CANVAS_X, int CANVAS_Y) {
     
      this.CANVAS_X = CANVAS_X;
      this.CANVAS_Y = CANVAS_Y;
      
      //color_list
      
      planet_colors.add("red");
      planet_colors.add("orange");
      planet_colors.add("yellow");
      planet_colors.add("blue");
      planet_colors.add("green");
    }
    
    //1 = up, 2 = d, 3 = r, 4 = l
    public void moveKey(int dir){
      if(planets.size() > 0){
        planets.get(key_id).moveKey(dir);
      }
    }
    public void rotateKey(int angle){
      if(planets.size() > 0){
        planets.get(key_id).rotateKey(angle);
      }
    }
    
    
    
    public void addPlanet() {
      
        
    }
    
    public void removePlanet() {
      
        
    }
    
    public void updatePlanets(){
      skeletons1 = getSkeletons();
      for(int i = 1; i <= getJSONsize(); i++) {
        
        //get Skeleton-Values
        float planet_xPos = (skeletons1[i-1].getFloat("xPos")+1)/2*CANVAS_X;
        float planet_yPos = (skeletons1[i-1].getFloat("zPos")+1)/2*CANVAS_Y;
        float planet_angle = (skeletons1[i-1].getFloat("orientation")+1);
        int planet_id = skeletons1[i-1].getInt("skeleton_ID");
        
        
        
        //planet entfernen, falls nicht verfügbar
        
        if(planets.containsKey(planet_id) == false){
          
          //****for poor key-processing****//
          key_id = planet_id;
          
          planets.put(planet_id, new Planet(planet_id, (int)planet_xPos, (int)planet_yPos, getPlanetColor()));
        }else{
          
          
          Planet planet_1 = planets.get(planet_id);
          //check, ob punkte überdeckt sind
          //TODO nur bei JSONGröße > 1
          //TODO planet entfernen, wenn skeleton weg
          
          
          
          for(int e = 1; e <= getJSONsize(); e++) {
            
            int planet_id_2 = skeletons1[e-1].getInt("skeleton_ID");
            
            if(planet_id != planet_id_2){
                //hier checken
                
                
                Planet planet_2 = planets.get(planet_id_2);
                
                int plt1_x = planet_1.getxPos();
                int plt1_y = planet_1.getyPos();
                
                int plt2_x = planet_2.getxPos();
                int plt2_y = planet_2.getyPos();
                //get both planets and check their x and y
                //if similar and not pulse => togglepulse
                //if not and pulse => togglepulse
                
                
                //noch intervall machen und nicht genaue position
                 //wenn überschneidung pulsieren starten
                 
                 
                 
                //println(planet_1.getIdle());
                if(plt1_x >= plt2_x - 50 && plt1_x <= plt2_x + 50 && plt1_y >= plt2_y - 50 && plt1_y <= plt2_y + 50){
               
                  if(planet_1.isPulsating() == false){
                    planet_1.togglePulse();
                  }
                }else{
                  if(planet_1.isPulsating() == true){
                    //set planets to normal size
                    planet_1.togglePulse();
                  }
                } 

               if(planet_1.getIdle() >= 130){
                  
                  if(planet_1.isGrowing() == false){
                    
                    planet_1.toggleGrow();
                    
                  }
                  //TODO bei Bewegung wieder kleiner
                }else{
                  if(planet_1.isGrowing() == true){
                    
                    planet_1.toggleGrow();
                    
                  }
                }  
            }
          }
          
          
          
          //***uncomment for kinect-movement****//
          planets.get(planet_id).movePlanet((int)planet_xPos, (int)planet_yPos, (int)planet_angle);
          try {
            noStroke();
            //println(planets.size());
            
            
            
            
            planets.get(planet_id).display();
          }
          catch (Exception e) {
            e.printStackTrace();
          } 
        }
      }
    }  
  
    private color getPlanetColor(){
      
      color col = getColor(planet_colors.get(0));
      planet_colors.add(planet_colors.get(0));
      planet_colors.remove(0);
      
      return col; 
    }
      
}
