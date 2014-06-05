//import java.util.ArrayList;
int resolutionX = 800;
int resolutionY = 450;
public Shape original;
public float originalAngle;
public int maxDepth = 0;


public class Shape {
  Shape(ArrayList<PVector> originalShape) {
    lines = originalShape;
  }
  void translate(int i) {
    float dx = lines.get(i).x - original.getFirstX();
    float dy = lines.get(i).y - original.getFirstY();
    // println(dx, dy);
    for (int w = 0; w < lines.size(); ++w) {
      lines.get(w).x += dx;
      lines.get(w).y += dy;
      // print(lines.get(w).x,lines.get(w).y," ");
    }
    // println();
  }
  void rotate(int i) {
    float angle = atan2(getDiffY(i), getDiffX(i));
    angle = originalAngle - angle;
    println(angle);

    float pivotX = lines.get(i).x;
    float pivotY = lines.get(i).y;

    for (int w=0; w<lines.size(); ++w) {
      float rotatingX = lines.get(w).x;
      float rotatingY = lines.get(w).y;

      angle = atan2(rotatingY-pivotY, rotatingX-pivotX);
      float cosTheta = cos(angle);
      float sinTheta = sin(angle);

      lines.get(w).x = cosTheta*rotatingX - sinTheta*rotatingY;
      lines.get(w).y = sinTheta*rotatingX - cosTheta*rotatingY;
      print(lines.get(w).x,lines.get(w).y," ");
    }
    println();

  }
  void dialate(float ratio) {

  }
  float getFirstX() {return lines.get(0).x;}
  float getFirstY() {return lines.get(0).y;}
  float getChangeX() {return lines.get(0).x - lines.get(lines.size()-1).x;}
  float getChangeY() {return lines.get(0).y - lines.get(lines.size()-1).y;}
  float getDiffX(int i) {return lines.get(i).x - lines.get(i+1).x;}
  float getDiffY(int i) {return lines.get(i).y - lines.get(i+1).y;}
  int size() {return lines.size();}
  void render() {
    for (int i = 0; i < lines.size()-1; ++i) {
      line(lines.get(i).x,lines.get(i).y, lines.get(i+1).x,lines.get(i+1).y); 
    }
  }
  private ArrayList<PVector> lines;

};

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
  println(originalAngle);
}

void mousePressed() {
  //increases the level the the fractal renders to
  // background(0);
  fractalize(original, 0);
  maxDepth ++;
}

void fractalize(Shape current, int depth) {
  if (depth == maxDepth) {current.render(); return;}
  for (int i=0; i<current.size()-1; ++i) {
    Shape temp = current;
    temp.translate(i);
    temp.rotate(i);
    fractalize(temp, depth + 1);
  }
}

void draw() {
}