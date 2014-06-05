//import java.util.ArrayList;
int resolutionX = 800;
int resolutionY = 450;
public Shape original;
public int maxDepth = 1;

public class Shape {
  Shape(ArrayList<PVector> originalShape) {
    lines = originalShape;
  }
  void translate(float x, float y) {
    for (int i = 0; i < lines.size(); ++i) {
      lines.get(i).x += x;
      lines.get(i).y += y;
    }
  }
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
  originalShape.add(new PVector(500,300));
  originalShape.add(new PVector(600,200));
  originalShape.add(new PVector(700,300));
  original = new Shape(originalShape);
}

void mousePressed() {
  //increases the level the the fractal renders to
  maxDepth ++;
  fractalize(original, 0);

}

void fractalize(Shape current, int depth) {
  if (depth == maxDepth) {current.render(); return;}
  fractalize(current, depth + 1);
}

void draw() {
}