//planet_handler
//canvas size
private final int CANVAS_X=600, CANVAS_Y=600;
private int angle = 0;
private SolarSystem solarsystem = new SolarSystem(CANVAS_X, CANVAS_Y);
void setup() {
  size(CANVAS_X, CANVAS_Y);
  ellipseMode(CENTER);
  thread("sexyFunction");
}

void draw() {

    if (keyPressed) {
      if (key == 'w' || key == 'W') {
        solarsystem.moveKey(1);
      } else if (key == 's' || key == 'S') {
        solarsystem.moveKey(2);
      } else if (key == 'd' || key == 'D') {
        solarsystem.moveKey(3);
      } else if (key == 'a' || key == 'A') { 
        solarsystem.moveKey(4);
      } else if (key == 'q' || key == 'Q') { 
        angle--;
        solarsystem.rotateKey(angle);
      } else if (key == 'e' || key == 'E') { 
        angle++;
        solarsystem.rotateKey(angle);
      }
    }else{
      solarsystem.moveKey(5);
    }
  
    background(200);
    solarsystem.updatePlanets();
}


JSONObject json;
int nextchange = 0;
boolean threadrun=true;
int client_id = 2;
static JSONObject[] skeletons1 = new JSONObject[6];
static int JSONsize = 0;
public static JSONObject[] getSkeletons(){
  return skeletons1;
}

public static int getJSONsize(){
  return JSONsize;
}

void sexyFunction() {
  while(threadrun){
    if(millis()>nextchange){
      json = loadJSONObject("http://9ifvp.w4yserver.at/uni/sharedSpace/stage_getSkeletons.php");
      
      //Save Skeletons from Webserver to datastructure
      
      try {
        JSONObject jsonClientID = json.getJSONObject("client_ID"+client_id);
        JSONsize = jsonClientID.size();
        for(int i = 1; i <= jsonClientID.size(); i++){  
           skeletons1[i-1] = jsonClientID.getJSONObject("skeleton_ID"+i);
        }
      }
      catch (Exception e) {
        println("ABKACK");
      }
      
      
      
      //println("running" + millis());
      nextchange = millis()+20;
    }
    
  }
}
