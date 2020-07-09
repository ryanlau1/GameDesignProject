int quadrantOfPoint(float x, float y, Player check){
    int quadrant = 1;
    if(x - check.position.x > 0 && y - check.position.y > 0){
      quadrant = 1;
    }
    if(x - check.position.x <=  0 && y - check.position.y > 0){
      quadrant = 2;
    }
    if(x - check.position.x <= 0 && y - check.position.y <= 0){
      quadrant = 3;
    }
    if(x - check.position.x > 0 && y - check.position.y <= 0){
      quadrant = 4;
    }
    return quadrant;
}

float angleFromPoint(float x, float y, Player check, int quadrant){
    float theta = 0; // Calculate theta based on quadrant.
    PVector difference = new PVector(check.position.x - x, check.position.y - y);  
    if(quadrant == 1) 
      theta = degrees(difference.heading() - PI);
    if(quadrant == 2)
      theta = degrees(2*PI - difference.heading());
    if(quadrant == 3)
      theta = degrees(difference.heading());
    if(quadrant == 4)
      theta = degrees(PI - difference.heading());
      
      return theta;
}

class Rat implements Entity{ // Simple movement / slower / 
  float x;
  float y;
  PVector velocity;
  
  final int RAT = 1;
  final int BAT = 2;
  
  int type;
  
  int attackAvg;
  float health;
  float maxSpeed;
  
  int movementState; // 1: chase player; 2: hit player; 3: hit by player; 4 was killed by player
  float moveTimer = 0;
  boolean justHit = false;
  boolean isHit = false;
  
  ArrayList<Rat> others; // Pass it a pointer to the various Rats existing
  
  boolean firstEncounter;
  
  Rat(int xPos, int yPos, int t, ArrayList<Rat> arr){
    x = xPos;
    y = yPos;
    velocity = new PVector(0, 0);
    if(t == BAT)
      maxSpeed = 60;
    if(t == RAT)
      maxSpeed = 49;
    
    type = t;
    others = arr;  
    attackAvg = 12;  
    health = 30;
    movementState = 1;
    firstEncounter = false;
  }
  
   Rat(int xPos, int yPos, int t, ArrayList<Rat> arr, boolean newEnemy){
    x = xPos;
    y = yPos;
    velocity = new PVector(0, 0);
    if(t == BAT)
      maxSpeed = 60;
    if(t == RAT)
      maxSpeed = 49;
    
    type = t;
    others = arr;  
    attackAvg = 12;  
    health = 30;
    movementState = 1;
    firstEncounter = newEnemy;
  }
  
  
  void detectCollision(Player player){
    int fromCenter = 11;
    if(this.x-fromCenter < leftWallBound){
      this.x = leftWallBound + fromCenter;
    }
    
    if(this.x+fromCenter > rightWallBound){
      this.x = rightWallBound - fromCenter;
    }
    
    if(dist(this.x, this.y,player.position.x, player.position.y) < player.pHeight/2 + 11){
      this.movementState = 2;
      player.takeDamage(10);
      this.justHit = true;
      this.x -= this.velocity.x/3;
      this.y -= this.velocity.y/3;
    }
    
  }
  
  void movement(Player check, float timer){
    if(movementState == 1){
      chasePlayer(check, timer);
      checkDamaged(check);
      if(this.health <= 0)
        this.movementState = 4;
    }
    if(movementState == 2){ // bouceback from hitting the player
      if(justHit == true/*timer - moveTimer > 3500*/){
        justHit = false;
        moveTimer = millis();
        this.velocity.x *= -2;
        this.velocity.y *= -2;
      }
        if(!(millis() - moveTimer > 650)){
          this.x += this.velocity.x * (timer/1000.0f);
          this.y += this.velocity.y * (timer/1000.0f);
        }
        if(millis() - moveTimer > 1300){
          movementState = 1;
        }
    }   
    if(movementState == 3){
      if(justHit == true/*timer - moveTimer > 3500*/){
        justHit = false;
        moveTimer = millis();
        this.velocity.x *= -2; // 2 original, was using -=this.velocity.x, etc. Same for y.
        this.velocity.y *= -2;
      }
        if(!(millis() - moveTimer > 900)){
          this.x += this.velocity.x * (timer/1000.0f);
          this.y += this.velocity.y * (timer/1000.0f);
        }
        if(millis() - moveTimer > 900){
          movementState = 1;
          isHit = false;
        }
    }
    if(movementState == 4){
      //for(int i = 0; i < this.others.)
      this.others.remove(this.others.indexOf(this));
      ratCount--;
    }
    
    // Stop at walls
    boolean stop = false;
    for(int i = 0; i < wallCount; i++){
      if(walls.get(i).generalCollides((int)this.x, (int)this.y, 11)){
        stop = true;
      }
    }
    if(stop == true){
      this.x -= this.velocity.x * (timer/1000.0f);
      this.y -= this.velocity.y * (timer/1000.0f);
    }
    
  }
  
  boolean isHitBy(Player check){
    int fromCenter = 11;
    if(check.slashInUse){
      if(quadrantOfPoint(this.x, this.y, check) == 1 && (check.facing == 2 || check.facing == 4)){
        if(dist(this.x, this.y, check.position.x, check.position.y) < check.slashRadius + fromCenter){
          return true;
        }
      }
      if(quadrantOfPoint(this.x, this.y, check) == 2 && (check.facing == 2 || check.facing == 3)){
        if(dist(this.x, this.y, check.position.x, check.position.y) < check.slashRadius + fromCenter){
          return true;
        }
      }
      if(quadrantOfPoint(this.x, this.y, check) == 3 && (check.facing == 1 || check.facing == 3)){
        if(dist(this.x, this.y, check.position.x, check.position.y) < check.slashRadius + fromCenter){
          return true;
        }
      }
      if(quadrantOfPoint(this.x, this.y, check) == 4 && (check.facing == 1 || check.facing == 4)){
        if(dist(this.x, this.y, check.position.x, check.position.y) < check.slashRadius + fromCenter){
          return true;
        }
      }
    }
    
    return false;
  }
  
  void checkDamaged(Player check){
    if(isHitBy(check) && !this.isHit){
      this.health -= 8+floor(random(1, 8.99));
      this.movementState = 3;
      this.isHit = true;
      this.justHit = true;
    }
  }
  
  void chasePlayer(Player check, float timer){
    // Calculate quadrant of angle between enemy and player.
    int quadrant = quadrantOfPoint(this.x, this.y, check); // may be wrong because of negative y
    
    float theta = angleFromPoint(this.x, this.y, check, quadrant);
    
    this.velocity.y=sin(radians(theta))*maxSpeed;
    this.velocity.x=cos(radians(theta))*maxSpeed;
    
    // Then, based on quadrant calculate sign of speed.
    if(quadrant == 1 || quadrant == 4){
      this.velocity.x *= -1;
    }
    if(quadrant == 1 || quadrant == 2){
      this.velocity.y *= -1;
    }
    
    this.x += this.velocity.x * (timer/1000.0f);
    this.y += this.velocity.y * (timer/1000.0f);
    
  }
  
  void display(){
    if(this.firstEncounter){
    fill(255);
    if(this.type == 1)
      text("Rat", this.x, this.y-10);
    else
      text("Bat", this.x, this.y-10);
    }
    
    stroke(30, 0, 0);
    rectMode(CENTER);
    if(this.type == BAT){
      fill(20);
    }
    else{
      fill(120);
    }
    if(this.isHit){
      fill(230, 0, 0);
    }
    rect(this.x, this.y, 22, 22);
  }
  
  public void takeDamage(float damage){
    this.health -= damage;
  }
  
  public void kill(){
    this.health = 0;
  }
}

/* class Knockbax {
    float health; // irrelevant, no health related method.
    float x;
    float y;
    PVector speed;
    float maxSpeed;
    
     ArrayList<Knockbax> others;
  }*/
  
  /*class Wizard {
    float health;
    float atk;
    float x;
    float y;
    PVector vel;
    float maxSpeed;
    PVector projectileVel;
    float projectileX;
    float projectileY;  
    
    ArrayList<Wizard> others;
  }*/
  
  /*class Spectres {
    float health;
    float atk;
    float x;
    float y;
    PVector vel;
    float maxSpeed;
    
    ArrayList<Spectres> others;
    
  }*/
  
  /*class TripleWizard {
    float health;
    float atk;
    float x;
    float y;
    PVector vel;
    float maxSpeed;
    PVector projectileVel1;
    float projectileX1;
    float projectileY1;
    PVector projectileVel2;
    float projectileX2;
    float projectileY2;
    PVector projectileVel3;
    float projectileX3;
    float projectileY3;  
    
    ArrayList<TripleWizard> others;
  }
  
  class ReboundWizard {
    float health;
    float atk;
    float x;
    float y;
    PVector vel;
    float maxSpeed;
    PVector projectileVel;
    float projectileX;
    float projectileY;
    int bounces;
    
    ArrayList<ReboundWizard> others;
  }
  
  class BigWizard {
    float health;
    float atk;
    float x;
    float y;
    PVector vel;
    float maxSpeed;
    PVector projectileVel;
    float projectileX;
    float projectileY;
    
    ArrayList<BigWizard> others;
  }
  
  class WallWizard {
    float health;
    float atk;
    float x;
    float y;
    PVector vel;
    float maxSpeed;
    PVector projectileVel;
    float projectileX;
    float projectileY;
    
    ArrayList<WallWizard> others;
  }
  
  class FastWizard {
    float health;
    float atk;
    float x;
    float y;
    PVector vel;
    float maxSpeed;
    PVector projectileVel;
    float projectileX;
    float projectileY;
    
    ArrayList<FastWizard> others;
  }*/
