//import java.util.ArrayList;
int resolutionX = 800;
int resolutionY = 450;
public Shape original;
public float originalAngle;
public float levelUp;
public int maxDepth = 0;

public boolean startRender = false;

public class Shape {
  public Shape(ArrayList<PVector> originalShape) {
    lines = originalShape;
  }
  public Shape(Shape old) {
    ArrayList<PVector> originalLines = old.returnLines();
    lines = new ArrayList<PVector>();
    for (int i=0; i<originalLines.size(); ++i) {
      PVector temp = new PVector(originalLines.get(i).x, originalLines.get(i).y);
      lines.add(temp);
      
    }
  }
  //MODIFIERS
  void translate(int i) {
    float dx = lines.get(i).x - lines.get(0).x;
    float dy = lines.get(i).y - lines.get(0).y;
    // println(dx, dy);
    for (int w = 0; w < lines.size(); ++w) {
      lines.get(w).x += dx;
      lines.get(w).y += dy;
      // print(lines.get(w).x,lines.get(w).y," ");
    }
    // println();
  }
  void rotate(int i) {
    float angle = atan2(original.getDiffY(i), original.getDiffX(i));
    angle = originalAngle - angle;
    angle *= -1;
    // print("angle:",angle);

    float pivotX = lines.get(0).x;
    float pivotY = lines.get(0).y;

    float cosTheta = cos(angle);
    float sinTheta = sin(angle);
    // println(" cos:",cosTheta,"sin",sinTheta);

    for (int w=1; w<lines.size(); ++w) {
      float rotatingX = lines.get(w).x;
      float rotatingY = lines.get(w).y;

      lines.get(w).x = cosTheta*(rotatingX-pivotX) - sinTheta*(rotatingY-pivotY) + pivotX;
      lines.get(w).y = sinTheta*(rotatingX-pivotX) + cosTheta*(rotatingY-pivotY) + pivotY;
    }
    // printPoints();
    // println();
  }
  void dialate(int i) {
    float currentDist = sqrt(pow(getDiffX(i),2) + pow(getDiffY(i),2));
    float ratio = (levelUp-currentDist)/levelUp;

    for (int w=1; w<lines.size(); ++w) {
      float pivotX = lines.get(0).x;    
      float pivotY = lines.get(0).y;
      float shrinkX = lines.get(w).x; 
      float shrinkY = lines.get(w).y;
      lines.get(w).x = shrinkX - (shrinkX - pivotX)*ratio;
      lines.get(w).y = shrinkY - (shrinkY - pivotY)*ratio;
        // PVector translate(pivotX-);
    }
    println(ratio);
  }
  //ACCESSORS
  ArrayList<PVector> returnLines() {return lines;}
  float getFirstX() {return lines.get(0).x;}
  float getFirstY() {return lines.get(0).y;}
  float getChangeX() {return lines.get(0).x - lines.get(lines.size()-1).x;}
  float getChangeY() {return lines.get(0).y - lines.get(lines.size()-1).y;}
  float getDiffX(int i) {return lines.get(i).x - lines.get(i+1).x;}
  float getDiffY(int i) {return lines.get(i).y - lines.get(i+1).y;}
  int size() {return lines.size();}

  void printPoints() {
    for (int i=0; i<lines.size(); ++i) {
      print("("+lines.get(i).x+", "+lines.get(i).y+") ");
    }
    println();
  }
  //RENDER
  void render() {
    for (int i = 0; i < lines.size()-1; ++i) {
      point(lines.get(i).x,lines.get(i).y);
      point(lines.get(i+1).x,lines.get(i+1).y);
      // line(lines.get(i).x,lines.get(i).y, lines.get(i+1).x,lines.get(i+1).y); 
    }
  }
  private ArrayList<PVector> lines;
};

/////////////////////////////////////////////////////////////////////////
//////////////////////// End of Shape Class ////////////////////////////
///////////////////////////////////////////////////////////////////////

void setup() {
  size(resolutionX,resolutionY);
  stroke(255);
  background(0);
  ArrayList<PVector> originalShape = new ArrayList<PVector>();
  originalShape.add(new PVector(400,300));
  originalShape.add(new PVector(500,200));
  originalShape.add(new PVector(600,300));
  original = new Shape(originalShape);
  originalAngle = atan2(original.getChangeY(), original.getChangeX());

}

void mousePressed() {
  //increases the level the the fractal renders to
  background(0);
  fractalize(original, 0);
  maxDepth ++;
}


void fractalize(Shape current, int depth) {
  if (depth == maxDepth) {
    current.render(); return;}
  for (int i=0; i<current.size()-1; ++i) {
    levelUp = sqrt(pow(current.getChangeX(),2)+pow(current.getChangeY(),2));
    Shape temp = new Shape(current);
    temp.translate(i);
    temp.rotate(i);
    temp.dialate(i);
    fractalize(temp, depth + 1);
  }
}

void draw() {}