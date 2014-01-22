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
    
    private final int pulseArea = 60;
    
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
        float planet_xPos = CANVAS_X-(skeletons1[i-1].getFloat("xPos")+1)/2*CANVAS_X;
        float planet_yPos = (skeletons1[i-1].getFloat("zPos")+1)/2*CANVAS_Y;
        float planet_angle = (skeletons1[i-1].getFloat("orientation")+1);
        int planet_id = skeletons1[i-1].getInt("skeleton_ID");
        
        if(MIRROR_REMOTE && !local) {
             planet_xPos = (skeletons1[i-1].getFloat("xPos")+1)/2*CANVAS_X;
             planet_yPos = CANVAS_Y-(skeletons1[i-1].getFloat("zPos")+1)/2*CANVAS_Y;
             planet_angle = 360-(skeletons1[i-1].getFloat("orientation")+1);
        }
        
        
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
          text("Remote", 240, (textOffset++)*20); 
      }
      
      
      while (it.hasNext()) {
          Map.Entry pairs = (Map.Entry)it.next();
          
          if( ((Planet)pairs.getValue()).getTStamp() < (tStamp-5) ) {
            it.remove();
          }
          
          try {
            
            Planet P = (Planet)pairs.getValue();
            
            if(!local) {
               P.display();
               checkInteractions(P);
               
            } else if(showLocal()) {
                P.display();
            }
              
              
            if(P.getIdle() >= 130){
              if(P.isGrowing() == false){
                P.toggleGrow(); 
              }
            }else{
              if(P.isGrowing() == true){
                P.toggleGrow(); 
              }
            }
            
            // == DEBUG OUTPUT
            if(isDebug()) {
              textSize(15);
              fill(0);
              if(local)
                text("ID: " + P.getID() + " - X:" + P.getxPos() + " - Y:" + P.getyPos()  + " - " + P.getAngle() + "°", 10, (textOffset++)*20); 
              else 
                text("ID: " + P.getID() + " - X:" + P.getxPos() + " - Y:" + P.getyPos()  + " - " + P.getAngle() + "°", 240, (textOffset++)*20); 
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
    private void checkInteractions(Planet remote) {
      
          Planet local, lookAt=null;
          Iterator it = localPlanets.entrySet().iterator();
          boolean checkPulse=true;

          while (it.hasNext()) {
            
            
            Map.Entry pairs = (Map.Entry)it.next();
            local = (Planet)pairs.getValue();
        
        
          /**
          * PULSE
          */
                int plt1_x = remote.getxPos();
                int plt1_y = remote.getyPos();
                
                int plt2_x = local.getxPos();
                int plt2_y = local.getyPos();
                //get both planets and check their x and y
                //if similar and not pulse => togglepulse
                //if not and pulse => togglepulse
                
                
                //noch intervall machen und nicht genaue position
                //wenn überschneidung pulsieren starten
                if(checkPulse) {
                  if(plt1_x >= plt2_x - pulseArea && plt1_x <= plt2_x + pulseArea 
                    && plt1_y >= plt2_y - pulseArea && plt1_y <= plt2_y + pulseArea){
                          remote.setPulsating(true);
                          checkPulse=false;
                      }else{
                        if(remote.isPulsating()){
                          remote.setPulsating(false);
                        }
                  }
                }
                
  
          /**
          * LOOK AT
          * - call "checkIntersecting()" for local and remote planet
          * -  
          */
                if(lookAt==null) {
                      
                      if(local.getAngle()>180) {
                        if(checkIntersecting(remote, local))
                          lookAt=local;
                      } else {
                        if(checkIntersecting(local, remote))
                          lookAt=local;
                      }
                }   
                
          } 
          
          remote.setIntersecting(lookAt);
    }
    
    
    private boolean checkIntersecting(Planet alpha, Planet beta) {
        
        // Abweichungstoleranz
        int tolAngle=20;
        int tolA=30; 
      
        // Wenn sich beide exakt betrachten, ist Winkel Alpha genau 180° kleiner als Winkel Beta
        if( (alpha.getAngle() < (beta.getAngle() - 180 + tolAngle*0.5)) &&
            (alpha.getAngle() > (beta.getAngle() - 180 - tolAngle*0.5)) ) {
           
           
           // Aus den beiden Punkten lassen sich die Katheten errechnen
           // danach a über Tangens/Winkel und b errechnen
           // -> Stimmt dies mit a überein, sehen sich beide wirklich an
           
           int a, b, aTan;
           
           if(alpha.getAngle() > 90) {
             a = beta.getxPos()-alpha.getxPos();
             b = beta.getyPos()-alpha.getyPos();
             
             
             aTan = (int)(tan(radians(alpha.getAngle()-90))*b);
           } else {
             a = beta.getxPos()-alpha.getxPos();
             b = alpha.getyPos()-beta.getyPos();
             
             aTan = (int)(tan(radians(alpha.getAngle()))*b);
           }     
            
           if( ((a+tolA*0.5)>aTan) &&
               ((a-tolA*0.5)<aTan)) {
               return true;
           }
              
        } 
      
      return false;
    }

  
    private color getPlanetColor(){
      
      color col = getColor(planet_colors.get(0));
      planet_colors.add(planet_colors.get(0));
      planet_colors.remove(0);
      
      return col; 
    }
      
}
