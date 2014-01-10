//planet_handler

// set to false for Live ENV
private final boolean IS_DEBUG=true;
private final boolean SHOW_LOCAL_SKEL=true;

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

  if (keyPressed) {
    if (key == 'w' || key == 'W') {
      solarsystem.moveKey(1);
    } 
    else if (key == 's' || key == 'S') {
      solarsystem.moveKey(2);
    } 
    else if (key == 'd' || key == 'D') {
      solarsystem.moveKey(3);
    } 
    else if (key == 'a' || key == 'A') { 
      solarsystem.moveKey(4);
    } 
    else if (key == 'q' || key == 'Q') { 
      angle--;
      solarsystem.rotateKey(angle);
    } 
    else if (key == 'e' || key == 'E') { 
      angle++;
      solarsystem.rotateKey(angle);
    }
  }
  else {
    solarsystem.moveKey(5);
  }

  background(200);

  solarsystem.updatePlanets(true);
  solarsystem.updatePlanets(false);
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
int localClientID = 1;
int remoteClientID = 2;

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
        json = loadJSONObject("http://9ifvp.w4yserver.at/uni/sharedSpace/getCircularSkeletons.php");
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
        println("No key or JSONObject found!");
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
        println("No key or JSONObject found!");
      }      

      nextchange = millis()+100;
      
      // ASCII ART
      s.getLine();
    }
  }
}

