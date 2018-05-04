int cellSize= 4; // Tamaño de las celdas (PX)
float interval = 1; // TIMER (1)
int lastRecordedTime = 0; // TIMER (2)
int pause = 0;

color azul = color(51, 121, 180);
color verde = color(0, 200, 0);
color rosa = color(254, 0, 129);
color amarillo = color(243, 197, 13);
color negro = color(0);
color piel = color(237, 160, 122);
color blanco = color(255,255,255);

color colorAnt = rosa; // Color hormiga
color colorPaw = azul; // Color vivos
color colorPaw2 = amarillo; // Color vivos
color colorPaw3 = verde; // Color vivos

color colorDead = negro; // Color muertos/vacio

int[][] cells; // Matriz del juego
int[][] cellsBuffer; // Buffer del juego (Mientras se cambia la matriz principal, se usa esta) 

int dimX; //= width/cellSize;
int dimY; //= height/cellSize;

float numberOfAnts = 10; // Probabilidad de iniciar vivo 
ArrayList<Ant> AntList = new ArrayList<Ant>();
int multicolor = 0;
int numOfColors = 4;


int cellLive = 0;
int cellLiveAt1000 = 0;
int cellLiveSum = 0;
int cellLiveProm = 0;


int iterationCount = 0;

void setup(){
  dimX = 250;
  dimY = 250;
  
  size (1000, 1000);
  surface.setResizable(true);
  
  cells = new int[dimX][dimY]; //Inicia las matrices
  
  // Color de la grilla
  noStroke();
  noSmooth();
  
  //Agrega las hormigas
  for(int a=0; a < numberOfAnts; a++){
    Ant newAnt = new Ant(colorAnt, blanco, (int)random(dimX), (int)random(dimY), (int)random(4)+1);
    AntList.add(newAnt);
  }
  
  //INICIA grilla
  cells = new int[dimX][dimY];
  
  
}

void draw() {

  //Dibuja la grilla
  for (int x=0; x<dimX; x++) {
    for (int y=0; y<dimY; y++) {
      
      if (cells[x][y]==1) {
        fill(colorPaw); // Vivo
      }else if (cells[x][y]==2) {
        fill(colorPaw2); // Vivo
      }else if (cells[x][y]==3) {
        fill(colorPaw3); // Vivo
      }else if (cells[x][y]==4) {
        fill(piel); // Vivo
      }else {
        fill(colorDead); // Muerto
      }
      for (Ant ant : AntList) {
        if(ant.x == x && ant.y == y){
          fill(ant.tcolor);
        }
        if(ant.x == x+1 && ant.y == y && ant.direction == 1){
          fill(ant.acolor);
        }
        if(ant.x == x-1 && ant.y == y && ant.direction == 3){
          fill(ant.acolor);
        }
        if(ant.x == x && ant.y == y+1 && ant.direction == 2){
          fill(ant.acolor);
        }
        if(ant.x == x && ant.y == y-1 && ant.direction == 4){
          fill(ant.acolor);
        }
      }
      //dibujar patrones encontrados
      rect (x*cellSize, y*cellSize, cellSize, cellSize);
    }
  }
  /*if (millis()-lastRecordedTime>interval) {
    if (pause == 0) {*/
      iteration();
      /*lastRecordedTime = millis();
    }
  }*/
}

void iteration() { // iteracion
  if(iterationCount == 1000){
    cellLiveAt1000 = cellLive;
  }
  
  println("____________________________");
  println("Generación: "+iterationCount);
  println("Hormigas existentes: "+numberOfAnts);
  println("Celulas vivas: "+cellLive+"\t Promedio celulas vivas: "+cellLiveProm);
  if(iterationCount >= 1000){
    println("Celulas vivas en la 1000 generación: "+cellLiveAt1000);
  }
  for (Ant ant : AntList) {
    ant.step();
  }
  iterationCount++;
  cellLiveSum += cellLive;
  cellLiveProm = cellLiveSum / iterationCount;
         
}

class Ant{
  color acolor;
  color tcolor;
  int x;
  int y;
  int direction; //1: left, 2: top; 3: right; 4: bottom;
  
  public Ant(color colora, color colort, int xpos,int ypos,int dir){
    acolor = colora;
    tcolor = colort;
    x = xpos;
    y = ypos;
    direction = dir;
  }
  
  public void turnLeft(){
    this.turn(-1);
  }
  
  public void turnRight(){
    this.turn(1);
  }
  
  public void turn(int dir){
    if(this.direction == 1){
      this.direction = (dir == 1)? 2:4;
    }else if(this.direction == 2){
      this.direction = (dir == 1)? 3:1;
    }else if(this.direction == 3){
      this.direction = (dir == 1)? 4:2;
    }else if(this.direction == 4){
      this.direction = (dir == 1)? 1:3;
    }
  }
  
  public void step(){
    if(cells[this.x][this.y] == 0){
      cells[this.x][this.y] = 1;
      cellLive++;
    }else if(cells[this.x][this.y] < 4 && multicolor == 1){
      cells[this.x][this.y]++;
      cellLive++;
    }else{
      cells[this.x][this.y] = 0;
      cellLive--;
    }

    if(this.direction == 1){ //LEFT
      if(this.x == 0){
        this.x = dimX - 1;
      }else{
        this.x = this.x - 1;
      }
    }else if(this.direction == 2){ //TOP
      if(this.y == 0){
        this.y = dimY - 1;
      }else{
        this.y = this.y - 1;
      }
    }else if(this.direction == 3){ //RIGHT
      if(this.x == dimX - 1){
        this.x = 0;
      }else{
        this.x = this.x + 1;
      }
    }else if(this.direction == 4){ //BOTTOM
      if(this.y == dimY - 1){
        this.y = 0;
      }else{
        this.y = this.y + 1;
      }
    }
    
    if(cells[this.x][this.y] == 0){
      this.turnRight();
    }else{
      this.turnLeft();
    }
  }
  

}
