//planet_handler

// set to false for Live ENV
private final boolean IS_DEBUG=true;
private final boolean SHOW_LOCAL_SKEL=true;


/* Uncomment, if your name is Michael
int localClientID=1;
int remoteClientID=2;
*/

/* Uncomment, if your name is Lukas */
int localClientID=2;
int remoteClientID=1;



//canvas size
private final int CANVAS_X=600, CANVAS_Y=600;

private int angle = 0;
private SolarSystem solarsystem = new SolarSystem(CANVAS_X, CANVAS_Y);


void setup() {
  size(CANVAS_X, CANVAS_Y);
  ellipseMode(CENTER);
  thread("serverCall");
}

void draw() {
  
  if(localClientID==0) {
    background(25);
     fill(150);
     textSize(22);
     text("Please enter your client ID [1, 2]",100,100); 
     if (keyPressed) {
      if (key == '1') {
        localClientID=1;
        remoteClientID=2;
      }
      if (key == '2') {
        localClientID=2;
        remoteClientID=1;
      }
     }
     
  } else {
  

  solarsystem.moveKey(5);
  background(200);
  
  solarsystem.updatePlanets(true);
  solarsystem.updatePlanets(false);
  
  textSize(15);
  fill(0);
  text("Client ID "+localClientID, 400, 20); 
  
  }
}

public boolean isDebug() {
  return IS_DEBUG;
}

public boolean showLocal() {
  return SHOW_LOCAL_SKEL;
}



// JSON / Server handling

JSONObject json;
int nextchange = 0;
boolean threadrun=true;

static JSONObject[] localSkeletons = new JSONObject[6];
static JSONObject[] remoteSkeletons = new JSONObject[6];
static int localJSONsize = 0;
static int remoteJSONsize = 0;


public static JSONObject[] getLocalSkeletons() {
  return localSkeletons;
}

public static JSONObject[] getRemoteSkeletons() {
  return remoteSkeletons;
}

public static int getLocalJSONsize() {
  return localJSONsize;
}

public static int getRemoteJSONsize() {
  return remoteJSONsize;
}

// Server Thread
void serverCall() {
  StatusLine s = new StatusLine();
  
  while (threadrun) {
    if (millis()>nextchange) {

      if (IS_DEBUG) {
        //json = loadJSONObject("http://9ifvp.w4yserver.at/uni/sharedSpace/getCircularSkeletons.php");
        json = loadJSONObject("http://9ifvp.w4yserver.at/uni/sharedSpace/getSkeletons.php");
      }
      else {
        json = loadJSONObject("http://9ifvp.w4yserver.at/uni/sharedSpace/getSkeletons.php");
      }

      //Save Skeletons from Webserver to datastructure
      try {

        // local
        JSONObject jsonClientID = json.getJSONObject("client_ID"+localClientID);
        localJSONsize = jsonClientID.size();
        for (int i = 1; i <= jsonClientID.size(); i++) {  
          localSkeletons[i-1] = jsonClientID.getJSONObject("skeleton_ID"+i);
        }
      }
      catch (Exception e) {
        //println("No key or JSONObject found!");
      }

      try {

        // remote
        JSONObject jsonClientID = json.getJSONObject("client_ID"+remoteClientID);
        remoteJSONsize = jsonClientID.size();
        for (int i = 1; i <= jsonClientID.size(); i++) {  
          remoteSkeletons[i-1] = jsonClientID.getJSONObject("skeleton_ID"+i);
        }
      }
      catch (Exception e) {
        //println("No key or JSONObject found!");
      }      

      nextchange = millis()+20;
      
      // ASCII ART
      //s.getLine();
    }
  }
}

