//import java.util.ArrayList;
int resolutionX = 800;
int resolutionY = 600;
PVector a, b, c;
//PVector [] points = new PVector[5];
ArrayList<PVector> originalShape = new ArrayList<PVector>();
ArrayList<PVector> points = new ArrayList<PVector>();
ArrayList<PVector> newPoints = new ArrayList<PVector>();
//counter for total points (1+2^n = an)
int n = 0;
//x and y being examined
float currX;
float currY;
float nextX;
float nextY;
float offsetAngle;
float originalAngle;
float originalDistance;
float currentDistance;
float ratio;
//new x,y points
float betweenX;
float betweenY;
//int slope;


void setup() { 
  size(resolutionX, resolutionY);
  stroke(255);
  background(0);
  a = new PVector(500,300);
  b = new PVector(500+50*sqrt(2), 300-(50*(6+sqrt(2))-300));
  c = new PVector(500+ 100*sqrt(2),300);
  originalAngle = atan2(a.y-b.y,a.x-b.x);
  offsetAngle = originalAngle;
  originalDistance = sqrt(pow(a.x-c.x,2)+pow(a.y-c.y,2));
  originalShape.add(a);
  originalShape.add(b);
  originalShape.add(c);
  points = new ArrayList<PVector>(originalShape);
  //noLoop();
}

void draw() {
  //background(0);
  println("#-#-#-#-#-#-#-new draw-#-#-#-#-#-#-#");
  for (int i=0; i<points.size()-1; i++) {
    currX = points.get(i).x;
    currY = points.get(i).y;
    nextX = points.get(i+1).x;
    nextY = points.get(i+1).y;
    currentDistance = sqrt(pow(currX-nextX,2)+pow(currY-nextY,2));
    ratio = currentDistance/originalDistance;
    
    println("inner loop");
    newPoints.add(points.get(i));
    for (int w=1; w<originalShape.size()-1; w++) {
      println("ratio*distance = "+ratio*currentDistance);
      //finds angle of difference from first object
      offsetAngle = atan2(currY-nextY, currX-nextX);
      newPoints.add(polarLine(currX, currY, offsetAngle, currentDistance, ratio));
    }
    line(currX, currY, nextX, nextY);
  }
  newPoints.add(points.get(points.size()-1));
  
  points = new ArrayList<PVector>(newPoints);
  newPoints.clear();
//  for (int i=0; i<newPoints.size()-1; i++) {
//    line(newPoints.get(i).x, newPoints.get(i).y, newPoints.get(i+1).x, newPoints.get(i+1).y);
//  }
  //line(points.get(0), points.get(0), points.get(1), points.get(1));
  //line(points.get(0).x, points.get(0).y, points.get(1).x, points.get(1).y);

  
  noLoop();
}
PVector polarLine(float x, float y, float offsetAngle, float distance, float ratio) {
  //println(' ');
  //println("offset = "+degrees(offsetAngle));
  //println("orginal = "+degrees(originalAngle));
  float nX = (x+ cos(offsetAngle+originalAngle)*(distance*ratio));
  //println("nX = "+degrees(nX));
  float nY = (y+ sin(offsetAngle+originalAngle)*(distance*ratio));
  //println("nY = "+degrees(nY));
  return new PVector(nX, nY);

}
void mousePressed() {
  loop();
}
void keyPressed() {
  if (key == 's') {
    save("koch.tif");
  }
}
