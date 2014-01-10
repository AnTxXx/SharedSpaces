import java.util.Map;
import java.util.Date;
import java.util.Iterator;

class SolarSystem{
    
     /*for poor key-processing*/
     int key_id;
     /*****/
  
  
    HashMap<Integer, Planet> localPlanets = new HashMap<Integer, Planet>();
    HashMap<Integer, Planet> remotePlanets = new HashMap<Integer, Planet>();
    HashMap<Integer, Planet> planets;
    
    //HashMap<Integer, Planet> planets = new HashMap<Integer, Planet>();
    
    JSONObject[] skeletons1 = new JSONObject[6];
    
    private  int CANVAS_X, CANVAS_Y;
    ArrayList<String> planet_colors = new ArrayList<String>();
    
    private final int pulseArea = 120;
    
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
      if(remotePlanets.size() > 0){
        //planets.get(key_id).moveKey(dir);
      }
    }
    public void rotateKey(int angle){
      if(remotePlanets.size() > 0){
        //planets.get(key_id).rotateKey(angle);
      }
    }

    
    /**
    * Updates the planet datastructure and draws each planet
    * @param local   update & draw local planets
    */
    public void updatePlanets(boolean local){
      int JSONsize=0;
      
      if(local) {
        skeletons1 = getLocalSkeletons();
        planets = localPlanets;
        JSONsize = getLocalJSONsize();
      } else {
        skeletons1 = getRemoteSkeletons();
        planets = remotePlanets;
        JSONsize = getRemoteJSONsize();
      }

      if(skeletons1==null)
        return;

      
      
      Date d = new Date();
      long tStamp=d.getTime()/1000;
	  

      // alle Planeten vom Webservice in lokale Datenstruktur (planets) hängen
      for(int i = 1; i <= JSONsize; i++) {
        
        //get Skeleton-Values
        float planet_xPos = (skeletons1[i-1].getFloat("xPos")+1)/2*CANVAS_X;
        float planet_yPos = (skeletons1[i-1].getFloat("zPos")+1)/2*CANVAS_Y;
        float planet_angle = (skeletons1[i-1].getFloat("orientation")+1);
        int planet_id = skeletons1[i-1].getInt("skeleton_ID");
        
        
        
        //planet entfernen, falls nicht verfügbar
        
        if(planets.containsKey(planet_id) == false){
          
          //****for poor key-processing****//
          key_id = planet_id;
          
          planets.put(planet_id, new Planet(planet_id, (int)planet_xPos, (int)planet_yPos, getPlanetColor(), local, tStamp) );
        }else{
          
          //checkInteractions(planet_id);
                    
          //***uncomment for kinect-movement****//
          planets.get(planet_id).movePlanet((int)planet_xPos, (int)planet_yPos, (int)planet_angle);
          planets.get(planet_id).setTStamp(tStamp);

        }
      }
      
      
      // Draw all elements of planets
      Iterator it = planets.entrySet().iterator();
      int textOffset=1;
      
      // == DEBUG OUTPUT
      if(isDebug()) {
        textSize(15);
        fill(0);
        if(local)
          text("Local", 10, (textOffset++)*20); 
        else
          text("Remote", 220, (textOffset++)*20); 
      }
      
      
      while (it.hasNext()) {
          Map.Entry pairs = (Map.Entry)it.next();
          
          if( ((Planet)pairs.getValue()).getTStamp() < (tStamp-5) ) {
            it.remove();
          }
          
          try {
            
            if((!local) || (showLocal()))
              ((Planet)pairs.getValue()).display();
            
            // == DEBUG OUTPUT
            if(isDebug()) {
              Planet P = (Planet)pairs.getValue();
              
              textSize(15);
              fill(0);
              if(local)
                text("ID: " + P.getID() + " - X:" + P.getxPos() + " - Y:" + P.getyPos(), 10, (textOffset++)*20); 
              else 
                text("ID: " + P.getID() + " - X:" + P.getxPos() + " - Y:" + P.getyPos(), 220, (textOffset++)*20); 
            }
          }
          catch (Exception e) {
            e.printStackTrace();
          } 
      }


      // update changed planets map
      if(local) {
         localPlanets = planets;
      } else {
        remotePlanets = planets;
      }
      
      
    }  
  
  
  
    /**
    *  Calculates and triggers interaction between planets
    */
    private void checkInteractions(int planet_id) {
      
          Planet planet_1 = planets.get(planet_id);
      
          for(int e = 1; e <= getLocalJSONsize(); e++) {
            
            int planet_id_2 = skeletons1[e-1].getInt("skeleton_ID");
            
            if(planet_id != planet_id_2){
                //hier checken
                
                
                Planet planet_2 = planets.get(planet_id_2);
                
                if(planet_2==null)
                  break;
        
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
                if(plt1_x >= plt2_x - pulseArea && plt1_x <= plt2_x + pulseArea && plt1_y >= plt2_y - pulseArea && plt1_y <= plt2_y + pulseArea){
               
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
    }
  
  
    private color getPlanetColor(){
      
      color col = getColor(planet_colors.get(0));
      planet_colors.add(planet_colors.get(0));
      planet_colors.remove(0);
      
      return col; 
    }
      
}
