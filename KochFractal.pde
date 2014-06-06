//import java.util.ArrayList;
int resolutionX = 800;
int resolutionY = 450;
int time =0;
int[][] grid = new int[resolutionX][resolutionY];

ArrayList<PVector> originalShape = new ArrayList<PVector>();
public Shape original;
public float originalAngle;
public float levelUp;
public int maxDepth = 0;

public boolean startRender = false;
public boolean initial = true;

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
    // shifts all the points with the previous level as the origin
    float dx = lines.get(i).x - lines.get(0).x;
    float dy = lines.get(i).y - lines.get(0).y;
    for (int w = 0; w < lines.size(); ++w) {
      lines.get(w).x += dx;
      lines.get(w).y += dy;
    }
  }
  void rotate(int i) {
    // rotates the points around the "pivot" 
    // which is the first point in the new level
    
    // gets the new angle change
    float angle = atan2(original.getDiffY(i), original.getDiffX(i));
    angle = (originalAngle - angle)*-1;
    // the point which the others in lines will use as an origin
    PVector pivot = new PVector(lines.get(0).x, lines.get(0).y);
    float cosTheta = cos(angle);
    float sinTheta = sin(angle);
    // actually rotating all the points
    for (int w=1; w<lines.size(); ++w) {
      PVector rotating = new PVector(lines.get(w).x, lines.get(w).y);
      lines.get(w).x = cosTheta*(rotating.x-pivot.x) - sinTheta*(rotating.y-pivot.y) + pivot.x;
      lines.get(w).y = sinTheta*(rotating.x-pivot.x) + cosTheta*(rotating.y-pivot.y) + pivot.y;
    }
  }
  void dialate(int i) {
    // shrinks the points with a ratio according to the side vs the whole
    // of the old depth fractal
    float currentDist = sqrt(pow(getDiffX(i),2) + pow(getDiffY(i),2));
    float ratio = (levelUp-currentDist)/levelUp;
    // dialates the points with the first point in the shape as the origin
    // (also uses a small formula I came up with to make a new origin)
    for (int w=1; w<lines.size(); ++w) {
      PVector pivot = new PVector(lines.get(0).x, lines.get(0).y);
      PVector shrink = new PVector(lines.get(w).x, lines.get(w).y);
      lines.get(w).x = shrink.x - (shrink.x - pivot.x)*ratio;
      lines.get(w).y = shrink.y - (shrink.y - pivot.y)*ratio;
        // PVector translate(pivotX-);
    }
  }
  //ACCESSORS
  ArrayList<PVector> returnLines() {return lines;}
  float getBaseDX() {return lines.get(0).x - lines.get(lines.size()-1).x;}
  float getBaseDY() {return lines.get(0).y - lines.get(lines.size()-1).y;}
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
      // if (get(int(lines.get(i).x),int(lines.get(i).y)) == color(255,255,255)) {
      //   return;
      // }
      // if (get(int(lines.get(i+1).x),int(lines.get(i+1).y)) == color(255,255,255)) {
      //   return;
      // }
      //with points:
      // point(lines.get(i).x,lines.get(i).y);
      // point(lines.get(i+1).x,lines.get(i+1).y);
      //with lines:
      line(lines.get(i).x,lines.get(i).y, lines.get(i+1).x,lines.get(i+1).y); 
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
}

void mousePressed() {
  if (mouseButton == RIGHT && !startRender) {
    // initial shape creation according to mouse input
    originalShape.add(new PVector(mouseX, mouseY));
    original = new Shape(originalShape);
    originalAngle = atan2(original.getBaseDY(), original.getBaseDX());
    original.render();
    print("("+mouseX+","+mouseY+") ");
  }
  if (originalShape.size()>1 && mouseButton == LEFT) {
    time = millis();
    startRender = true;
    //resets the background at each level
    background(0);
    //increases the level the the fractal renders to
    maxDepth ++;
    //actual recursive fractal program
    fractalize(original, 0);
    println();
    print("level: "+maxDepth+" time(ms): "+(millis()-time));

  }
}
void keyPressed() {
  if (key == ' ') {
    originalShape.clear();
    startRender = false;
    maxDepth = 0;
    println(); println("--new shape--");
    background(0);
  }
}


void fractalize(Shape current, int depth) {
  if (depth == maxDepth) {
    //stops the 'fractalizing' at whatever the max depth is
    current.render();
    return;
  }
  // recursive loop that loops through all the sides and calls itself
  for (int i=0; i<current.size()-1; ++i) {
    levelUp = sqrt(pow(current.getBaseDX(),2)+pow(current.getBaseDY(),2));
    Shape newDepth = new Shape(current);
    newDepth.translate(i);
    newDepth.rotate(i);
    newDepth.dialate(i);
    fractalize(newDepth, depth + 1);
  }
}

void draw() {
  // only used to reset the canvas whenever the space key is hit
  if (!startRender && originalShape.size() > 0) {
    background(0);
    PVector last = originalShape.get(originalShape.size()-1);
    for (int i=0; i<originalShape.size()-1; ++i) {
      PVector a = new PVector(originalShape.get(i).x, originalShape.get(i).y);
      PVector b = new PVector(originalShape.get(i+1).x, originalShape.get(i+1).y);
      line(a.x,a.y, b.x,b.y);
    }
    line(last.x, last.y, mouseX, mouseY);
  }
}