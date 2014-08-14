//Epidemiology project

int width = 600;   // screen width
int cellSize=6;
int[][] world;
int[][] timer;
int[][] futureWorld;
int sx,sy;
int continuousMode=0;
int delayTime=1000;
int modelNumber=0;
int infectionTime=5;
int recoveredTime=9;
int increaseConnectivity=0;

// called just once at the start of program execution
void setup()
{
  size(width,width);     // set size of screen (in pixels)
  smooth();
  sx=width/cellSize;
  sy=width/cellSize;
  world=new int[sx][sy];
  timer=new int[sx][sy];
  futureWorld=new int[sx][sy];
  
  annihilateLife();    
  
  for(int i=0;i<sx;i++){
    for(int j=0;j<sy;j++){
      timer[i][j]=0;  
    }
  }
  
}

// called repeatedly, usually used to draw on screen
void draw()
{
  background (0, 0, 0);  // set background color to white
  //stroke(0,255,0);
  drawWorld();
  delay(delayTime);
  
  if(continuousMode==1){
   
     if(modelNumber==0){
      SIR();
     }
     
     if(modelNumber==1){
      SIS();
     }
    
     if(modelNumber==2){
      SIRS();
     } 
      
  }
    
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
  
    if(key=='q')
      modelNumber=0;
  
    if(key=='w')
      modelNumber=1;
      
    if(key=='e')
      modelNumber=2;
    
    if(key=='i')
      increaseConnectivity=1;
    
    if(key=='d')
      increaseConnectivity=0;  
 
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
     
    if(key==' '){
       if(modelNumber==0){
        SIR();
       }
     
       if(modelNumber==1){
        SIS();
       }
    
       if(modelNumber==2){
        SIRS();
       }       
    }

  
}

void annihilateLife(){
 
  for(int i=0;i<sx;i++)
    for(int j=0;j<sy;j++)
      world[i][j]=0;
}

void SIS(){
  
    for(int i=0;i<sx;i++)
    for(int j=0;j<sy;j++){
 
      
      if(world[i][j]==0 || world[i][j]==2){  //node is susceptible
        
        if(random(0,10)/10<checkIfInfected(i,j)){  //node will be infected
          
          futureWorld[i][j]=1;
          timer[i][j]=0;
        }

        else{
          futureWorld[i][j]=0;
        }        
        
      }
      
      if(world[i][j]==1){  //node is infected
        
        timer[i][j]++;
        
        if(timer[i][j]>=infectionTime){
         
          futureWorld[i][j]=0;  //node has become susceptible again
            
        }
        
        else{
         
           futureWorld[i][j]=1;  //node is still infected 
        }
        
      }
      
     }
    
    for(int i=0;i<sx;i++)
      for(int j=0;j<sy;j++)
        world[i][j]=futureWorld[i][j];
  
}

void SIRS(){
  
    for(int i=0;i<sx;i++)
      for(int j=0;j<sy;j++){
   
        
        if(world[i][j]==0){  //node is susceptible
          
          if(random(0,10)/10<checkIfInfected(i,j)){  //node will be infected
            
            futureWorld[i][j]=1;
            timer[i][j]=0;
          }
  
          else{
            futureWorld[i][j]=0;
          }        
          
        }
        
        if(world[i][j]==1){  //node is infected
          
          timer[i][j]++;
          
          if(timer[i][j]>=infectionTime){
           
            futureWorld[i][j]=2;  //node has recovered
            timer[i][j]=0;
              
          }
          
          else{
           
             futureWorld[i][j]=1;  //node is still infected 
          }
          
        }
        
        if(world[i][j]==2){
          
            timer[i][j]++;
                 
          
          if(timer[i][j]>=recoveredTime){
           
            futureWorld[i][j]=0;  //node is susceptible again
            timer[i][j]=0;
              
          }
          
          else{
           
             futureWorld[i][j]=2;  //node is recovered
          }
          
        }
       }
      
      for(int i=0;i<sx;i++)
        for(int j=0;j<sy;j++)
          world[i][j]=futureWorld[i][j];
    
  
  
}

void SIR(){
 
  for(int i=0;i<sx;i++)
    for(int j=0;j<sy;j++){
 
      
      if(world[i][j]==0){  //node is susceptible
        
        if(random(0,10)/10<checkIfInfected(i,j)){  //node will be infected
          
          futureWorld[i][j]=1;
          timer[i][j]=0;
        }

        else{
          futureWorld[i][j]=0;
        }        
        
      }
      
      if(world[i][j]==1){  //node is infected
        
        timer[i][j]++;
        
        if(timer[i][j]>=infectionTime){
         
          futureWorld[i][j]=2;  //node has recovered
            
        }
        
        else{
         
           futureWorld[i][j]=1;  //node is still infected 
        }
        
      }
      
      if(world[i][j]==2){
        
          futureWorld[i][j]=2;  //node is recovered  
      }
     }
    
    for(int i=0;i<sx;i++)
      for(int j=0;j<sy;j++)
        world[i][j]=futureWorld[i][j];
  
}

float checkIfInfected(int x, int y){
  
  float infected=0;
  
  if(world[(x + 1) % sx][y]==1)
    infected++;
  if(world[x][(y + 1) % sy]==1)
    infected++;
  if( world[(x + sx - 1) % sx][y]==1)
    infected++;
  if(world[x][(y + sy - 1) % sy]==1)
    infected++;
  
  if(increaseConnectivity==1){
  if(world[(x + 1) % sx][(y + 1) % sy]==1)
    infected++;
  if(world[(x + sx - 1) % sx][(y + 1) % sy]==1)
    infected++;
  if(world[(x + sx - 1) % sx][(y + sy - 1) % sy]==1)
    infected++;
  if(world[(x + 1) % sx][(y + sy - 1) % sy]==1)
    infected++;
  }
  
   return infected/8;  
    
  
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
     if(random(100)<10){
       world[i][j]=1;
     }
     else{
        world[i][j]=0;     
     } 
    }
    
}

void drawWorld(){
      
  for(int i=0;i<width;i+=cellSize){
    for(int j=0;j<width;j+=cellSize){
      
      if(world[i/cellSize][j/cellSize]==0)
         fill (0, 0, 255);    
      if(world[i/cellSize][j/cellSize]==1)
         fill (255, 0, 0);
      if(world[i/cellSize][j/cellSize]==2)
         fill (0,255, 0);
           
      
      //noStroke();
      rect (i, j, cellSize, cellSize);
    }
  }
}
