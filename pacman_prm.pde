


//Game Area
static int walls = 70;
Vec2 wallPos[] = new Vec2[walls]; //Square top left

//list of square obstacles
static int numSquares = 80;
Vec2 squarePos[] = new Vec2[numSquares]; //Square top left
Vec2 widthHeight[] = new Vec2[numSquares];

Vec2 startPos = new Vec2(75,75);
Vec2 goalPos = new Vec2(975,675);

Vec2 pacmanPos = new Vec2(75,75);
Vec2 pacmanGoal = new Vec2(975,675);

boolean setStart = false;
boolean setGoal = false;

PImage pacman;
PImage ghost;

void keyPressed(){
  if (key == 's'){
    println("Starting at");
    startPos.x = mouseX;
    startPos.y = mouseY;
    pacmanPos.x = mouseX;
    pacmanPos.y = mouseY;
    println(startPos.x + "," + startPos.y + "\n");
    setStart = true;
    buildPRM(squarePos, widthHeight);
    runBFS(closestNode(startPos),closestNode(goalPos));
  }
  if (key == 'g'){
    println("Goal is at");
    goalPos.x = mouseX;
    goalPos.y = mouseY;
    println(goalPos.x + "," + goalPos.y + "\n");
    setGoal = true;
    pacmanGoal = goalPos;
    buildPRM(squarePos, widthHeight);
    runBFS(closestNode(startPos),closestNode(goalPos));
  }
  if (key == 'd'){
    println("Doubling ball speed");
    speed *= 2;
  }
  if (key == 'h'){
    println("Halving ball speed");
    speed /= 2;
  }
  
}


void placeGameArea(){
  for(int i = 0; i < 21; i++){
    wallPos[i] = new Vec2(i*50, 0);
  }
  for(int i = 0; i < 15; i++){
    wallPos[i+21] = new Vec2(0, i*50);
  }
  for(int i = 0; i < 15; i++){
    wallPos[i+35] = new Vec2(1000, i*50);
  }
  for(int i = 0; i < 21; i++){
    wallPos[i+49] = new Vec2(i*50, 700);
  }
}

void placeSquares(){
  for (int i = 0; i < numSquares; i++){
    float x = random(1,19);
    float y = random(2,13);
    squarePos[i] = new Vec2(floor(x)*50,floor(y)*50);
    x = random(0,3);
    if(floor(x) == 0){
      y = random(0,2);
      widthHeight[i] = new Vec2(50,floor(y)*50);
    }
    else widthHeight[i] = new Vec2(floor(x)*50,50);
  }
}

int strokeWidth = 2;

void setup(){
  size(1050,750);
  placeGameArea();
  placeSquares();
  //buildPRM(circlePos, circleRad);
  pacman = loadImage("pacman2.png");
  ghost = loadImage("ghost2.png");
  buildPRM(squarePos, widthHeight);
  //planPath(startPos, goalPos, nodePos, squarePos, widthHeight);
  runBFS(closestNode(startPos),closestNode(goalPos));
  
}

Vec2 vel;
float speed = 64;

static int pathCount = 0;

//for movement
void update(float dt){
  if(setStart && setGoal && (pathCount < path.size()) && (path.size() > 1)){
    //Vec2 dir = pacmanGoal.minus(pacmanPos);
    pacmanGoal = nodePos[path.get(pathCount)];
    Vec2 dir = pacmanGoal.minus(pacmanPos);
    if (speed * dt > dir.length()){
      vel = new Vec2(0,0);
      //pacmanGoal = nodePos[path.get(pathCount)];
      pathCount ++;
    }
    else vel = dir.normalized();
    vel.mul(speed);
    pacmanPos.add(vel.times(dt));
  }
}

void draw(){
  //println("FrameRate:",frameRate);
  update(1/frameRate);
  strokeWeight(1);
  background(0); //Grey background
  stroke(0,0,0);
  fill(255,255,255);
  
  //draw wall
  strokeWeight(0);
  stroke(0,0,255);
  fill(0,0,255);
  for(int i = 0; i < 70; i++){
    rect(wallPos[i].x, wallPos[i].y, 50, 50);
  }
  
  //draw squares
  strokeWeight(0);
  stroke(0,0,255);
  fill(0,0,255);
  for(int i = 0; i < numSquares; i++){
    rect(squarePos[i].x, squarePos[i].y, widthHeight[i].x, widthHeight[i].y);
  }
  
  //Draw graph
  //after prm is written --------------------------////////////////
 /*
  stroke(100,100,100);
  strokeWeight(1);
  for (int i = 0; i < numNodes; i++){
    for (int j : neighbors[i]){
      line(nodePos[i].x,nodePos[i].y,nodePos[j].x,nodePos[j].y);
    }
  }
  */
  
  
  //Draw Start and Goal
  
  if(setGoal){
    fill(250,30,50);
    //put ghost
    image(ghost,goalPos.x-20,goalPos.y-20,40,40);
  }
  
  if(setStart){
    fill(20,60,250);
    //put pacman
    image(pacman,pacmanPos.x-20,pacmanPos.y-20,40,40);
  }
  
  /*
  if(setStart && setGoal){
    //Draw Nodes
    fill(255);
    for (int i = 0; i < numNodes; i++){
      circle(nodePos[i].x,nodePos[i].y,10);
    }
  }
  */
  
  //drawing planned path
  
  /*
  stroke(20,255,40);
  strokeWeight(5);
  if (path.size() == 0){
    line(startPos.x,startPos.y,goalPos.x,goalPos.y);
    return;
  }
  line(startPos.x,startPos.y,nodePos[path.get(0)].x,nodePos[path.get(0)].y);
  for (int i = 0; i < path.size()-1; i++){
    int curNode = path.get(i);
    int nextNode = path.get(i+1);
    line(nodePos[curNode].x,nodePos[curNode].y,nodePos[nextNode].x,nodePos[nextNode].y);
  }
  line(goalPos.x,goalPos.y,nodePos[path.get(path.size()-1)].x,nodePos[path.get(path.size()-1)].y);
  */
}

/////////////////////////////////
// PRM Library
////////////////////////////////

//static int numNodes = 247 - numSquares;
static int numNodes = 247;

ArrayList<Integer> path = new ArrayList(); 
int startNode, goalNode;

ArrayList<Integer>[] neighbors = new ArrayList[numNodes];
Boolean[] visited = new Boolean[numNodes];
int[] parent = new int[numNodes];

Vec2[] nodePos = new Vec2[numNodes];

void generateRandomNodes(Vec2[] topLefts, Vec2[] lengths){
  for (int i = 0; i < numNodes; i++){
    Vec2 randPos = new Vec2(floor(random(3,39))*25, floor(random(3,27))*25);//x range 75,975     y range75,675
     boolean insideBox = pointInBoxList(topLefts, lengths, randPos);
     while(insideBox){
       randPos = new Vec2(floor(random(1,13))*75, floor(random(1,9))*75);
       insideBox = pointInBoxList(topLefts, lengths, randPos);
     }
     nodePos[i] = randPos;
  }
}

// debugging this function
void generateNodes(Vec2[] topLefts, Vec2[] lengths){
  int nodeId = 0;
  if (nodeId == numNodes) return;
  for (int i = 0; i < 13; i++){
    for (int j = 0; j < 19; j++){
      /*
      Vec2 pos = new Vec2(75+(50*j),75+(50*i));
      boolean insideBox = pointInBoxList(topLefts, lengths, pos);
      if(!insideBox){
        nodePos[nodeId] = pos;
        nodeId++;
      }
      */
      nodePos[nodeId] = new Vec2(j*50+75,i*50+75);
      nodeId += 1;
    }
  }
}

void connectNeighbors(){
  for (int i = 0; i < numNodes; i++){
    neighbors[i] = new ArrayList<Integer>();
    for (int j = 0; j < numNodes; j++){
      if (i == j) continue;
      Vec2 dir = nodePos[j].minus(nodePos[i]).normalized();
      float distBetween = nodePos[i].distanceTo(nodePos[j]);
      if(distBetween < 150){
        hitInfo boxListCheck = rayBoxListIntersect(squarePos, widthHeight, nodePos[i], dir, distBetween);
        if (!boxListCheck.hit){
          neighbors[i].add(j);
        }
      }
    }
  }
}

void buildPRM(Vec2[] topLefts, Vec2[] lengths){
  generateNodes(topLefts, lengths);
  connectNeighbors();
}

/////////////////////////////////
// Path Planning
////////////////////////////////
int closestNode(Vec2 point){
  //TODO: Return the closest node the passed in point
  int finalNodeIndex = 0;
  float finalDistance = nodePos[finalNodeIndex].distanceTo(point);
  for (int i = 1; i < numNodes; i++){
      float distBetween = nodePos[i].distanceTo(point);
      if(finalDistance > distBetween){
        finalDistance = distBetween;
        finalNodeIndex = i; 
      }
  }
  return finalNodeIndex;
}

void runBFS(int startID, int goalID){
  startNode = startID;
  goalNode = goalID;
  ArrayList<Integer> fringe = new ArrayList();  //Make a new, empty fringe
  path = new ArrayList(); //Reset path
  for (int i = 0; i < numNodes; i++) { //Clear visit tags and parent pointers
    visited[i] = false;
    parent[i] = -1; //No parent yet
  }

  //println("\nBeginning Search");
  
  visited[startID] = true;
  fringe.add(startID);
  //println("Adding node", startID, "(start) to the fringe.");
  //println(" Current Fring: ", fringe);
  
  while (fringe.size() > 0){
    int currentNode = fringe.get(0);
    fringe.remove(0);
    if (currentNode == goalID){
      //println("Goal found!");
      break;
    }
    for (int i = 0; i < neighbors[currentNode].size(); i++){
      int neighborNode = neighbors[currentNode].get(i);
      if (!visited[neighborNode]){
        visited[neighborNode] = true;
        parent[neighborNode] = currentNode;
        fringe.add(neighborNode);
        //println("Added node", neighborNode, "to the fringe.");
        //println(" Current Fringe: ", fringe);
      }
    } 
  }
  
  //print("\nReverse path: ");
  int prevNode = parent[goalID];
  path.add(0,goalID);
  //print(goalID, " ");
  while (prevNode >= 0){
    //print(prevNode," ");
    path.add(0,prevNode);
    prevNode = parent[prevNode];
  }
  //print("\n");
}

/////////////////////////////////
// Point in Box Library
////////////////////////////////
boolean pointInBoxList(Vec2[] toplefts, Vec2[] lengths, Vec2 pointPos){
  for(int i = 0;  i < numSquares; i++){
    Vec2 topleft = toplefts[i];
    float w = lengths[i].x;
    float h = lengths[i].y;
    if(pointInBox(topleft, w, h, pointPos)){
      return true;
    }
  }
  return false;
}

//Returns true if the point is inside a box
boolean pointInBox(Vec2 boxTopLeft, float boxW, float boxH, Vec2 pointPos){
  //TODO: Return true if the point is actually inside the box
  if ((pointPos.x > boxTopLeft.x-30 && pointPos.x < (boxTopLeft.x + boxW + 30)) && (pointPos.y > boxTopLeft.y-30 && pointPos.y < (boxTopLeft.y + boxH + 30))) {
    return true;
  }

  return false;
}


/////////////////////////////////
// Vec2 Library
////////////////////////////////

public class Vec2 {
  public float x, y;
  
  public Vec2(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  public String toString(){
    return "(" + x+ "," + y +")";
  }
  
  public float length(){
    return sqrt(x*x+y*y);
  }
  
  public float lengthSqr(){
    return x*x+y*y;
  }
  
  public Vec2 plus(Vec2 rhs){
    return new Vec2(x+rhs.x, y+rhs.y);
  }
  
  public void add(Vec2 rhs){
    x += rhs.x;
    y += rhs.y;
  }
  
  public Vec2 minus(Vec2 rhs){
    return new Vec2(x-rhs.x, y-rhs.y);
  }
  
  public void subtract(Vec2 rhs){
    x -= rhs.x;
    y -= rhs.y;
  }
  
  public Vec2 times(float rhs){
    return new Vec2(x*rhs, y*rhs);
  }
  
  public void mul(float rhs){
    x *= rhs;
    y *= rhs;
  }
  
  public void clampToLength(float maxL){
    float magnitude = sqrt(x*x + y*y);
    if (magnitude > maxL){
      x *= maxL/magnitude;
      y *= maxL/magnitude;
    }
  }
  
  public void setToLength(float newL){
    float magnitude = sqrt(x*x + y*y);
    x *= newL/magnitude;
    y *= newL/magnitude;
  }
  
  public void normalize(){
    float magnitude = sqrt(x*x + y*y);
    x /= magnitude;
    y /= magnitude;
  }
  
  public Vec2 normalized(){
    float magnitude = sqrt(x*x + y*y);
    return new Vec2(x/magnitude, y/magnitude);
  }
  
  public float distanceTo(Vec2 rhs){
    float dx = rhs.x - x;
    float dy = rhs.y - y;
    return sqrt(dx*dx + dy*dy);
  }
}

Vec2 interpolate(Vec2 a, Vec2 b, float t){
  return a.plus((b.minus(a)).times(t));
}

float interpolate(float a, float b, float t){
  return a + ((b-a)*t);
}

float dot(Vec2 a, Vec2 b){
  return a.x*b.x + a.y*b.y;
}

Vec2 projAB(Vec2 a, Vec2 b){
  return b.times(a.x*b.x + a.y*b.y);
}

/////////////////////////////////
// Collision Library
////////////////////////////////

class hitInfo{
  public boolean hit = false;
  public float t = 9999999;
}

hitInfo rayBoxIntersect(Vec2 boxTopLeft, float boxW, float boxH, Vec2 ray_start, Vec2 ray_dir, float max_t){
  hitInfo hit = new hitInfo();
  hit.hit = true;
  
  float t_left_x, t_right_x, t_top_y, t_bot_y;
  t_left_x = (boxTopLeft.x - ray_start.x)/ray_dir.x;
  t_right_x = (boxTopLeft.x + boxW - ray_start.x)/ray_dir.x;
  t_top_y = (boxTopLeft.y - ray_start.y)/ray_dir.y;
  t_bot_y = (boxTopLeft.y + boxH - ray_start.y)/ray_dir.y;
  
  float t_max_x = max(t_left_x,t_right_x);
  float t_max_y = max(t_top_y,t_bot_y);
  float t_max = min(t_max_x,t_max_y); //When the ray exists the box
  
  float t_min_x = min(t_left_x,t_right_x);
  float t_min_y = min(t_top_y,t_bot_y);
  float t_min = max(t_min_x,t_min_y); //When the ray enters the box
  
  
  //The the box is behind the ray (negative t)
  if (t_max < 0){
    hit.hit = false;
    hit.t = t_max;
    return hit;
  }
  
  //The ray never hits the box
  if (t_min > t_max){
    hit.hit = false;
  }
  
  //The ray hits, but further out than max_t
  if (t_min > max_t){
    hit.hit = false;
  }
  
  hit.t = t_min;
  return hit;
}

hitInfo rayBoxListIntersect(Vec2[] topLefts, Vec2[] lengths, Vec2 l_start, Vec2 l_dir, float max_t){
  hitInfo hit = new hitInfo();
  hit.t = max_t;
  for (int i = 0; i < numSquares; i++){
    Vec2 topLeft = topLefts[i];
    float w = lengths[i].x;
    float h = lengths[i].y;
    hitInfo boxHit = rayBoxIntersect(topLeft, w, h, l_start, l_dir, hit.t);
    if (boxHit.t > 0 && boxHit.t < hit.t){
      hit.hit = true;
      hit.t = boxHit.t;
    }
    else if (boxHit.hit && boxHit.t < 0){
      hit.hit = true;
      hit.t = -1;
    }
  }
  return hit;
}
