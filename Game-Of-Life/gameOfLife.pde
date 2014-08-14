//Game of life

int width = 600;   // screen width
int cellSize=6;
int[][] world;
int[][] futureWorld;
int sx,sy;
int continuousMode=0;
int delayTime=500;

// called just once at the start of program execution
void setup()
{
  size(width,width);     // set size of screen (in pixels)
  smooth();
  sx=width/cellSize;
  sy=width/cellSize;
  world=new int[sx][sy];
  futureWorld=new int[sx][sy];
  
  annihilateLife();    
  
}

// called repeatedly, usually used to draw on screen
void draw()
{
  background (0, 0, 0);  // set background color to white
  //stroke(0,255,0);
  drawWorld();
  delay(delayTime);
  
  if(continuousMode==1)
    updateLife();
    
}

void mousePressed(){
 
 int i=floor(mouseX/cellSize);
 int j=floor(mouseY/cellSize);

 if(world[i][j]==0)
  world[i][j]=1;
 
 else
  world[i][j]=0; 
  
}

void keyPressed(){
 
    if(key=='C' || key=='c')
      annihilateLife();
     
    if(key=='R' || key=='r'){
       annihilateLife();
       delay(200);
       randomizeWorld();  
    }
    
    if(key=='G' || key=='g'){
      
      if(continuousMode==1){
        delayTime=100;    
        continuousMode=0;
      }
      else{
        delayTime=500;
        continuousMode=1;
      }        
    }
     
    if(key==' ')
     updateLife(); 
  
}

void annihilateLife(){
 
  for(int i=0;i<sx;i++)
    for(int j=0;j<sy;j++)
      world[i][j]=0;
}


void updateLife(){
 
  for(int i=0;i<sx;i++)
    for(int j=0;j<sy;j++){
      
      if(world[i][j]==1){  //cell is alive
        
        if(checkIfAlive(i,j)==2 || checkIfAlive(i,j)==3){
           futureWorld[i][j]=1; 
        }
        
        else
          futureWorld[i][j]=0;
        
      }
      
      else{

        if(checkIfAlive(i,j)==3)
          futureWorld[i][j]=1;
          
         else
           futureWorld[i][j]=0;
      }
    
    }
    
    for(int i=0;i<sx;i++)
      for(int j=0;j<sy;j++)
        world[i][j]=futureWorld[i][j];
  
}

int checkIfAlive(int x, int y){
  
  return world[(x + 1) % sx][y] + 
         world[x][(y + 1) % sy] + 
         world[(x + sx - 1) % sx][y] + 
         world[x][(y + sy - 1) % sy] + 
         world[(x + 1) % sx][(y + 1) % sy] + 
         world[(x + sx - 1) % sx][(y + 1) % sy] + 
         world[(x + sx - 1) % sx][(y + sy - 1) % sy] + 
         world[(x + 1) % sx][(y + sy - 1) % sy]; 

}

void randomizeWorld(){
 
    for(int i=0;i<sx;i++)
    for(int j=0;j<sy;j++){
     if(random(100)<50){
       world[i][j]=0;
     }
     else{
        world[i][j]=1;     
     } 
    }
    
}

void drawWorld(){
      
  for(int i=0;i<width;i+=cellSize){
    for(int j=0;j<width;j+=cellSize){
      
      if(world[i/cellSize][j/cellSize]==1)
         fill (255, 255, 255);    // fill with white color
      else
         fill (0, 0, 0);    // fill with white color
      
      rect (i, j, cellSize, cellSize);
    }
  }
}
