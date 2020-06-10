int[] map; //<>// //<>// //<>//

int[] get2DPos(int pos) {
  return new int[] { pos % width, pos / width };
} //<>//

int get1DPos(int x, int y) {
  return x + y * width;
} 


class Square {
  int[] corners;
  int step;
  int origin;
  int iterationNumber;

  Square(int origin, int step, int iterationNumber) {
    corners = new int[4]; 
    //step = step - 1;
    corners[0] = origin;
    corners[1] = origin + step;
    corners[2] = origin + step * (width + 1);
    corners[3] = origin + step * width;
    this.step = step;
    this.origin = origin;
    this.iterationNumber = iterationNumber;
  }

  public void init() {
    // Initialisation des valeurs
    map[corners[0]] = floor(random(256));
    map[corners[1]] = floor(random(256));
    map[corners[2]] = floor(random(256));
    map[corners[3]] = floor(random(256));
  }

  private int computeDiamondColour() {
    int average = 0;
    for(int i = 0; i < corners.length; i++) {
      average += map[corners[i]];
    }
    
    float baseVariation = 255;
    float randomAmp = 1 + iterationNumber * log(pow(iterationNumber, 10));
    average = abs((average / corners.length + floor(map(random(256), 0, 256, -baseVariation / randomAmp, baseVariation / randomAmp)))) % 255;
    
    return average;
  }
  
  private int computeSquareColour(int diamond) {
    return diamond + floor(random(256 / iterationNumber));
  }
  
  public void diamondSquare() {
      
    int newStep = step / 2;  
    boolean isEven = newStep % 2 == 0;
    int shift = 1 - newStep % 2;
    
    // Calcul du centre du diamant + valeur
    int centerPos = get1DPos(get2DPos(corners[0])[0] + newStep, get2DPos(corners[0])[1] + newStep);   
    
    int diamondColour = computeDiamondColour();
    map[centerPos] = diamondColour;

    int[] diamondCenters = { get1DPos(get2DPos(centerPos)[0], get2DPos(corners[0])[1]), 
      get1DPos(get2DPos(corners[1])[0], get2DPos(centerPos)[1]), 
      get1DPos(get2DPos(centerPos)[0], get2DPos(corners[3])[1]), 
      get1DPos(get2DPos(corners[0])[0], get2DPos(centerPos)[1])};

    map[diamondCenters[0]] = computeDiamondColour();
    map[diamondCenters[1]] = computeDiamondColour();
    map[diamondCenters[2]] = computeDiamondColour();
    map[diamondCenters[3]] = computeDiamondColour();
    
    if (step >= 1) {
      // Nouveaux Carrés + Condition d'arrêt
      Square s1 = new Square(corners[0], newStep, iterationNumber++);
      s1.diamondSquare();
      Square s2 = new Square(corners[0] + newStep, newStep, iterationNumber++);
      s2.diamondSquare();
      Square s3 = new Square(diamondCenters[3], newStep, iterationNumber++);
      s3.diamondSquare();
      Square s4 = new Square(centerPos, newStep, iterationNumber++);
      s4.diamondSquare();
    }
  }
}

class Diamond {
}

void setup() {
  size(1025, 1025);
  map = new int[width * height];
  background(255);

  int step = width - 1;
  int origin = 0;
  Square s = new Square(origin, step, 1);
  s.init();
  s.diamondSquare();

  for (int i = 0; i < map.length; i++)  
    set(i % width, i / height, color(map[i]));
}

void draw() {
   //delay(5);
}

void keyPressed() {
  if(key == 's')
    saveFrame("screenshots/" + day() + hour() + year() + minute() + second() + ".png");
}
