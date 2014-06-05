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

    PVector pivot = new PVector(lines.get(0).x, lines.get(0).y);

    float cosTheta = cos(angle);
    float sinTheta = sin(angle);
    // println(" cos:",cosTheta,"sin",sinTheta);

    for (int w=1; w<lines.size(); ++w) {
      PVector rotating = new PVector(lines.get(w).x, lines.get(w).y);

      lines.get(w).x = cosTheta*(rotating.x-pivot.x) - sinTheta*(rotating.y-pivot.y) + pivot.x;
      lines.get(w).y = sinTheta*(rotating.x-pivot.x) + cosTheta*(rotating.y-pivot.y) + pivot.y;
    }
    // printPoints();
    // println();
  }
  void dialate(int i) {
    float currentDist = sqrt(pow(getDiffX(i),2) + pow(getDiffY(i),2));
    float ratio = (levelUp-currentDist)/levelUp;

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
    originalShape.add(new PVector(mouseX, mouseY));
    original = new Shape(originalShape);
    originalAngle = atan2(original.getChangeY(), original.getChangeX());
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
    current.render();
    return;
  }
  for (int i=0; i<current.size()-1; ++i) {
    levelUp = sqrt(pow(current.getChangeX(),2)+pow(current.getChangeY(),2));
    Shape temp = new Shape(current);
    temp.translate(i);
    temp.rotate(i);
    temp.dialate(i);
    fractalize(temp, depth + 1);
  }
}

void draw() {
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