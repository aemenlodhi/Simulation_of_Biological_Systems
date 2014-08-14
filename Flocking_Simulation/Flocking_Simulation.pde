int width=900;
int height=600;
float nearRadius=375;
float collisionRadius=45;
float visibleRadius=125;
float centringWeight=0.8;
float avoidanceWeight=2.2;
float matchingWeight=0.7;
float mousyAttractionWeight=0.01;
float mousyRepulsionWeight=0.05;
float speedLimit=5.0;
float avoidanceLimit=25.0;
boolean leavePath=false;

boolean centringOff=false;
boolean matchingOff=false;
boolean collisionOff=false;
boolean wanderingOff=false;
boolean stopSimulation=false;
boolean attractionMode=false;
boolean repulsionMode=false;

boid[] activeBoids;
int numBoids=10;
int totalBoids=100;

void setup(){
  
  
  background(0,0,0);
  
  size(width,height);
  smooth();
  ellipseMode(CENTER);
  frameRate(60);
  activeBoids=new boid[totalBoids];
  
  for(int i = 0; i < totalBoids; i++) {
    activeBoids[i] = new boid(random(width),random(height),random(-1,1),random(-1,1));
    activeBoids[i].boidId=i;
   
  }
  
  for(int i=0;i<numBoids;i++){
    activeBoids[i].isAlive=true; 
  }
  
}

void draw(){
  
  if(stopSimulation==false){
    if(!leavePath)
      background(0,0,0);
    //delay(100);
    
    for(int i=0;i<numBoids;i++)
      activeBoids[i].drawBoid();
     
    for(int i=0;i<numBoids;i++)
      activeBoids[i].updateVelocity();
    
    for(int i=0;i<numBoids;i++)
      activeBoids[i].moveBoid();
   }  
   
}

void reduceBoids(){
 
  if(numBoids>1){
   numBoids--;
   activeBoids[numBoids].annihilateBoid();
    
  }
  
}

void createBoids(){
  
  if(numBoids<100){
   activeBoids[numBoids].createBoid();
   activeBoids[numBoids].boidId=numBoids;
   numBoids++; 
  }
    
}

void keyPressed(){
 
    if(key=='S' || key=='s')
      scatterBoids();
      
    if(key=='P' || key=='p'){
     if(leavePath==true)
       leavePath=false;
     else
       leavePath=true;
    }
    
    if(key=='c' || key=='C')
      background(0,0,0);
      
    if(key=='1'){
     if(centringOff==true){
       centringOff=false;
       println("Centring forces have been turned on");
     }
     else{
        centringOff=true; 
        println("Centring forces have been turned off");
      }
    }
    
    if(key=='2'){
      if(matchingOff==true){
       matchingOff=false;
       println("Velocity matching forces have been turned on");
     }
     else{
        matchingOff=true; 
        println("Velocity matching forces have been turned off");
      }
    }
    
    if(key=='3'){
      if(collisionOff==true){
       collisionOff=false;
       println("Collision avoidance forces have been turned on");
     }
     else{
        collisionOff=true; 
        println("Collision avoidance forces have been turned off");
      }
    }
    
    if(key=='4'){
      if(wanderingOff==true){
       wanderingOff=false;
       println("Wandering forces have been turned on");
     }
     else{
        wanderingOff=true; 
        println("Wandering avoidance forces have been turned off");
      }
    }
    
    if(key==' '){
     if(stopSimulation==true)
      stopSimulation=false;
     else
      stopSimulation=true; 
    }
    
    if(key=='a' || key=='A'){
      if(attractionMode==true){
       attractionMode=false;
       println("Attraction mode has been turned off");
     }
     else{
        attractionMode=true;
        repulsionMode=false; 
        println("Attraction mode has been turned on and repulsion mode has been turned off");
      }
    }
    
    if(key=='r' || key=='R'){
      if(repulsionMode==true){
       repulsionMode=false;
       println("Repulsion mode has been turned off");
     }
     else{
        repulsionMode=true;
        attractionMode=false; 
        println("Repulsion mode has been turned on and attraction mode has been turned off");
      }
    }
    
    if(key=='-'){
     reduceBoids(); 
    }
    
    if(key=='=' || key=='+'){
     createBoids(); 
    }
    
   
}

float convertToRadians(float degrees){
  
  return degrees*3.1416/180;
}

void scatterBoids(){
  
  for(int i=0;i<numBoids;i++){
    activeBoids[i].position.x=random(width);
    activeBoids[i].position.y=random(height);
    activeBoids[i].velocity.x=random(-1,1);
    activeBoids[i].velocity.y=random(-1,1);
  }
}

float distance(float x1, float y1, float x2, float y2){
 
 float d;
 d=sqrt(sq(x2-x1)+sq(y2-y1));
 return d; 
  
}

class toroidalWrap{
 
  float distance;
  PVector wrapVector;
  
  toroidalWrap(float d, float x, float y){
   
   wrapVector=new PVector(x,y); 
   distance=d;
  }
  
}


class boid{
  
  PVector position;
  PVector velocity;
  int boidId;
  boolean isAlive;
  PVector prevVelocity;
  toroidalWrap wrapComplication;
  
  boid(float xCoordinate, float yCoordinate, float vxComponent, float vyComponent){
    
    position=new PVector(xCoordinate,yCoordinate);
    velocity=new PVector(vxComponent,vyComponent);
    prevVelocity=new PVector(0,0);
    isAlive=false;
    wrapComplication=new toroidalWrap(0,0,0);
    
  }
  
  void findNewDistance(int i){
    
    float minDistance=10000000;
    float d=0;
    float mx=0;
    float my=0;
    
    for(int j=-width;j<=width;j+=width)
      for(int k=-height;k<=height;k+=height){
        
        d=distance(activeBoids[i].position.x+j,activeBoids[i].position.y+k,this.position.x,this.position.y);
        
        if(d < minDistance) {
          minDistance = d;
          mx = activeBoids[i].position.x + j;
          my = activeBoids[i].position.y + k;
        }
        
        
      }
      
     this.wrapComplication.distance=minDistance;
     this.wrapComplication.wrapVector.x=mx;
     this.wrapComplication.wrapVector.y=my;
         
  }
  
  void annihilateBoid(){
   isAlive=false; 
  }
  
  void createBoid(){
   isAlive=true; 
   position.x=random(width);
   position.y=random(height);
   velocity.x=random(-1,1);
   velocity.y=random(-1,1);
   
  }
  
  void moveBoid(){
    position.x += velocity.x;
    position.y += velocity.y;
    
    int freedom=20;
    if (this.position.x > (width+freedom))
      this.position.x = -freedom;
    if (this.position.y > (height+freedom))
      this.position.y = -freedom;
    if (this.position.x < -freedom)
      this.position.x = width+freedom;
    if (this.position.y < -freedom)
      this.position.y = height+freedom;
    
  }
  
  float findDistance(int i){
  
    float distance=0;
    distance=sqrt(sq(position.x-activeBoids[i].position.x)+sq(position.y-activeBoids[i].position.y));
    
    return distance;  
      
  }
  
  void updatePosition(){
   
    int freedom=20;
    if (this.position.x > (width+freedom))
      this.position.x = -freedom;
    if (this.position.y > (height+freedom))
      this.position.y = -freedom;
    if (this.position.x < -freedom)
      this.position.x = width+freedom;
    if (this.position.y < -freedom)
      this.position.y = height+freedom;
    
  }
  
  void reduceSpeed(){
    if(velocity.mag()>speedLimit){
      velocity.normalize();
      velocity.mult(speedLimit);
    }    
  }
  
  PVector updateCentringVelocity(){
    
    int numNear=0;
    PVector nearNessDensity=new PVector(0,0);

    /*
    for(int i=0;i<numBoids;i++){
     if(i!=boidId && findDistance(i)<=nearRadius){
      nearNessDensity.add(activeBoids[i].position);
      numNear++;     
     } 
    }
    */
    
     for(int i=0;i<numBoids;i++){
       if(i!=boidId){
        findNewDistance(i);
        
        if(wrapComplication.distance<=nearRadius){
          nearNessDensity.add(wrapComplication.wrapVector);
          numNear++;
        }     
       } 
     }
    
    if(numNear>0)
      nearNessDensity.div(numNear);
    
    nearNessDensity.sub(this.position);
    nearNessDensity.div(100);
    
    return nearNessDensity;
    
  }
  
  PVector upateAvoidanceVelocity(){
   
  
   PVector avoidance=new PVector(0,0);
   
   float avoidanceFactor=0;
   
   for(int i=0;i<numBoids;i++){
     if(i!=boidId && findDistance(i)<collisionRadius){
       
       PVector currentCollision=new PVector(this.position.x-activeBoids[i].position.x,this.position.y-activeBoids[i].position.y);
       if(currentCollision.mag()>0){
         avoidanceFactor=avoidanceLimit/currentCollision.mag();
       } 
       currentCollision.normalize();
       currentCollision.mult(avoidanceFactor);
       avoidance.add(currentCollision);
       
     }
     
   }
  
    return avoidance;  

  }
  
  PVector updateMatchingVelocity(){
    
    PVector velocityMatch=new PVector(0,0);
    int numMatching=0;
    
    for(int i=0;i<numBoids;i++){
     if(i!=boidId && findDistance(i)<=visibleRadius){
       velocityMatch.add(activeBoids[i].velocity);
       numMatching++;    
     }
        
    }
    
    if(numMatching>0)
      velocityMatch.div(numMatching);
    velocityMatch.sub(this.velocity);
    velocityMatch.div(8);
    
    return velocityMatch;
  }
  
  
  PVector updateWanderingVelocity(){
   
    PVector wandering=new PVector(random(-1.5,1.5),random(-1.5,1.5));
    return wandering;
    
  }
  
  PVector catchTheMouse(){
   
    PVector mousy=new PVector(0,0);
    
    mousy.x=-this.position.x+mouseX;
    mousy.y=-this.position.y+mouseY;
       
    return mousy;   
  }
  
  
  PVector mouseThePredator(){
   
   PVector mousy=new PVector(0,0);
   float distance=0;
   
   distance=sqrt(sq(mouseX-this.position.x)+sq(mouseY-this.position.y));
   
   if(distance>150)
     return mousy;
     
   else{
    mousy.x=this.position.x-mouseX;
    mousy.y=this.position.y-mouseY;
    
    if(distance>100)
      return mousy;
    
    else if(distance>50){
      mousy.mult(2);
      return mousy;
      
    }
      
    else{
       mousy.mult(3);
       return mousy;   
    }
    
     
   }
    
  }
  
  void updateVelocity(){
    
    PVector centring=new PVector(0,0);
    PVector avoidance=new PVector(0,0);
    PVector matching=new PVector(0,0);
    PVector wandering=new PVector(0,0);
    PVector mousy=new PVector(0,0);
    
    if(centringOff==false){
      centring=updateCentringVelocity();
      centring.mult(centringWeight);
    }
    
    if(collisionOff==false){    
      avoidance=upateAvoidanceVelocity();
      avoidance.mult(avoidanceWeight);
    } 
    
    if(matchingOff==false){ 
      matching=updateMatchingVelocity();
      matching.mult(matchingWeight);
    }
    
    if(wanderingOff==false){
      wandering=updateWanderingVelocity();
    }
    
    if(mousePressed==true && (attractionMode==true || repulsionMode==true)){
      if(attractionMode==true){
        mousy=catchTheMouse();
        mousy.mult(mousyAttractionWeight);
      }
      if(repulsionMode==true){
        mousy=mouseThePredator();
        mousy.mult(mousyRepulsionWeight);      
      }  
    }
    
  
    prevVelocity=velocity;
    //velocity.mult(0);
    
    velocity.add(centring);
    velocity.add(avoidance);
    velocity.add(matching);
    velocity.add(wandering);
    velocity.add(mousy);
    
    //velocity.mult(0.2);
    //prevVelocity.mult(0.8);
    
    //velocity.add(prevVelocity);
    
    this.reduceSpeed();
    
    
  }
  
  void drawBoid()
  {
    /*
    PVector unit = new PVector(0,0);
    unit=this.velocity;
    unit.normalize();
    unit.mult(20);
    stroke(220);
    line(this.position.x,this.position.y,this.position.x+unit.x/1.6,this.position.y+unit.y/1.6);
    
    stroke(100);
    fill(255,0,0);
    float radius = 13.0 - 5.0 * ((float)numBoids/300);
    ellipse(this.position.x,this.position.y,radius,radius);
    */
   
   PVector pointTo = this.velocity;
    pointTo.normalize();
    pointTo.x*=15.0;
    pointTo.y*=15.0;
    stroke(220);
    line(this.position.x,this.position.y,this.position.x+pointTo.x,this.position.y+pointTo.y);
    stroke(100);
   
   if(this.boidId%3==0){
    fill(255,0,0);
   }
   
   else if(this.boidId%3==1){
    fill(0,255,0); 
   }
   
   else{
    fill(0,0,255); 
   }
   
    float radius = 15.0;
    ellipse(this.position.x,this.position.y,radius,radius);
    
  }
  
}



