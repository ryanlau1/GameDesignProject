// NOTE: there is an error when a player is knocked into a damaged Spectre. This spectre turns red permanently and no longer teleports. It is a very specific error, so we will defer it to later but it should be fixed.
// They also never die in this state.

class Spectres implements Entity{
    float health;
    float atk;
    float x;
    float y;
    PVector velocity;
    float maxSpeed;
    int size;
    
    ArrayList<Spectres> others;
    
        int movementState; // 1: chase player; 2: hit player; 3: hit by player; 4 was killed by player
    float moveTimer = 0;
    boolean justHit = false;
    boolean isHit = false;
    
    //float lastKnockBack;
    //float velocityOnKnockbackX;
    //float velocityOnKnockbackY;
    
    boolean firstEncounter;
    
    Spectres(int xPos, int yPos, ArrayList<Spectres> arr){
      x = xPos;
      y = yPos;
      velocity = new PVector(0, 0);

      maxSpeed = 140;
    
      others = arr;
      health = 75;
      movementState = 1;
      
      size = 50;
      firstEncounter = false;
  }
  
    Spectres(int xPos, int yPos, ArrayList<Spectres> arr, boolean newEnemy){
      x = xPos;
      y = yPos;
      velocity = new PVector(0, 0);

      maxSpeed = 140;
    
      others = arr;
      health = 75;
      movementState = 1;
      
      size = 50;
      
      firstEncounter = newEnemy;
  }  

  void detectCollision(Player player){
    int fromCenter = size/2;
    /*if(this.x-fromCenter < leftWallBound){
      this.x = leftWallBound + fromCenter;
    }
    
    if(this.x+fromCenter > rightWallBound){
      this.x = rightWallBound - fromCenter;
    }*/
    
    if(dist(this.x, this.y,player.position.x, player.position.y) < player.pHeight/2 + (size/2)){
      this.movementState = 2;
      player.takeDamage(20);
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
        this.velocity.x *= -0.5;
        this.velocity.y *= -0.5;
      }
        if(!(millis() - moveTimer > 900)){
          this.x += this.velocity.x * (timer/1000.0f);
          this.y += this.velocity.y * (timer/1000.0f);
        }
        if(millis() - moveTimer > 900){
          movementState = 1;
          isHit = false;
          this.x = round(random(0, width));
          this.y = round(random(0, height));
          while(dist(this.x, this.y, check.position.x, check.position.y) < 100 ){
          this.x = round(random(0, width));
          this.y = round(random(0, height));
          }
        }
    }
    if(movementState == 4){
      //for(int i = 0; i < this.others.)
      this.others.remove(this.others.indexOf(this));
      spectCount--;
    }
  }
  
  boolean isHitBy(Player check){
    int fromCenter = size/2;
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
      text("Spectre", this.x, this.y-this.size/2-5);
    }
    
    stroke(30, 0, 0);
    rectMode(CENTER);
      fill(0, 0, 35);
      
    if(this.isHit){
      fill(230, 0, 0);
    }
    rect(this.x, this.y, this.size, this.size);
  }
    
    
  public void takeDamage(float damage){
    this.health -= damage;
  }
  
  public void kill(){
    this.health = 0;
  }
}
