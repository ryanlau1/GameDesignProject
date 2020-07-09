class Knockbax implements Entity{
    float health; // irrelevant, no health related method.
    float x;
    float y;
    PVector velocity;
    float maxSpeed;
    int size;
    
    int movementState; // 1: chase player; 2: hit player; 3: hit by player; 4 was killed by player
    float moveTimer = 0;
    boolean justHit = false;
    boolean isHit = false;
    
    float lastKnockBack;
    float velocityOnKnockbackX;
    float velocityOnKnockbackY;
    
    int movementBoundLX;
    int movementBoundRX;
    int movementBoundUY;
    int movementBoundDY;
    
     ArrayList<Knockbax> others;
     
     boolean firstEncounter;
     
    Knockbax(int xPos, int yPos, ArrayList<Knockbax> arr){
      x = xPos;
      y = yPos;
      velocity = new PVector(0, 0);

      maxSpeed = 52;
    
      others = arr;  
      health = 800;
      movementState = 1;
      
      size = 30;
      
      movementBoundLX = 0;
      movementBoundRX = 0;
      movementBoundUY = 0;
      movementBoundDY = 0;
      
      firstEncounter = false;
  }
  
      Knockbax(int xPos, int yPos, ArrayList<Knockbax> arr, boolean newEnemy){
      x = xPos;
      y = yPos;
      velocity = new PVector(0, 0);

      maxSpeed = 52;
    
      others = arr;  
      health = 800;
      movementState = 1;
      
      size = 30;
      
      movementBoundLX = 0;
      movementBoundRX = 0;
      movementBoundUY = 0;
      movementBoundDY = 0;
      
      firstEncounter = newEnemy;
  }
  
      Knockbax(int xPos, int yPos, ArrayList<Knockbax> arr, int movementx1, int movementx2, int movementx3, int movementx4){
      x = xPos;
      y = yPos;
      velocity = new PVector(0, 0);

      maxSpeed = 52;
    
      others = arr;  
      health = 800;
      movementState = 1;
      
      size = 30;
      
      movementBoundLX = movementx1;
      movementBoundRX = movementx2;
      movementBoundUY = movementx3;
      movementBoundDY = movementx4;
      
      firstEncounter = false;
  }
  
  void detectCollision(Player player, float timer){
    int fromCenter = size/2;
    if(this.x-fromCenter < leftWallBound){
      this.x = leftWallBound + fromCenter;
    }
    
    if(this.x+fromCenter > rightWallBound){
      this.x = rightWallBound - fromCenter;
    }
    
    if(dist(this.x, this.y,player.position.x, player.position.y) < player.pHeight/2 + (size/2)){
      this.movementState = 2;
      this.justHit = true;
      
      // Only used because of special case movementState5, disregard if you chose not to use this AI 
      // This way player will be knocked in the direction expected as it wil reset the speed of
      /*if(movementState == 5){
       chasePlayer(player, timer);
       movementState = 1;
      }*/
       
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
        if(millis() - this.lastKnockBack > 1500){
          check.canMove = false;
          this.lastKnockBack = millis();
          moveUpdateTimer = millis();
          velocityOnKnockbackX = this.velocity.x;
          velocityOnKnockbackY = this.velocity.y;
        }
        if(millis() - this.lastKnockBack < 700){
          float updateTimerForMovement = millis()-moveUpdateTimer;
          check.position.x -= (this.velocityOnKnockbackX*1.5)*((updateTimerForMovement)/1000.0f);
          check.position.y -= (this.velocityOnKnockbackY*1.5)*((updateTimerForMovement)/1000.0f);
          moveUpdateTimer = millis();
          
              boolean stopPlayer = false;
              for(int i = 0; i < wallCount; i++){
                if(walls.get(i).generalCollides((int)check.position.x, (int)check.position.y, 11) /*&& abs(velicityOnKnockbackX) > 0 && abs(velocityOnKnockbackY) > 0*/){
                  stopPlayer = true;
                }
              }
              if(stopPlayer == true){
                check.position.x += (this.velocityOnKnockbackX*1.5)*((updateTimerForMovement)/1000.0f);
                check.position.y += (this.velocityOnKnockbackY*1.5)*((updateTimerForMovement)/1000.0f);
              }
        }
        else{
          check.canMove = true;
        }
    }
    if(movementState == 3){
      if(justHit == true/*timer - moveTimer > 3500*/){
        justHit = false;
        moveTimer = millis();
        this.velocity.x *= -2;
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
      knockCount--;
    }
    // Wandering state if the knockbax hits a wall or bound *** remove and two slashed parts of bound detect to revert to working state
    if(movementState == 5){
      if(millis() - moveTimer > 0 && millis() - moveTimer < 100){
        this.velocity.x = random(-this.maxSpeed, this.maxSpeed);
        this.velocity.y = random(-this.maxSpeed, this.maxSpeed);
        while(this.velocity.mag() > this.maxSpeed){ // While the vector's magnitude exceeds the max speed, keep randomizing.
          this.velocity.x = random(-this.maxSpeed, this.maxSpeed);
          this.velocity.y = random(-this.maxSpeed, this.maxSpeed);
        }
      }
      
      if(millis() - moveTimer > 900 && millis() - moveTimer < 1000){
        this.velocity.x = random(-this.maxSpeed, this.maxSpeed);
        this.velocity.y = random(-this.maxSpeed, this.maxSpeed);
        while(this.velocity.mag() > this.maxSpeed){ // While the vector's magnitude exceeds the max speed, keep randomizing.
          this.velocity.x = random(-this.maxSpeed, this.maxSpeed);
          this.velocity.y = random(-this.maxSpeed, this.maxSpeed);
        }
      }
      
     if(millis() - moveTimer > 1600 && millis() - moveTimer < 1700){
        this.velocity.x = random(-this.maxSpeed, this.maxSpeed);
        this.velocity.y = random(-this.maxSpeed, this.maxSpeed);
        while(this.velocity.mag() > this.maxSpeed){ // While the vector's magnitude exceeds the max speed, keep randomizing.
          this.velocity.x = random(-this.maxSpeed, this.maxSpeed);
          this.velocity.y = random(-this.maxSpeed, this.maxSpeed);
        }
      }
      
      // In case of a double state glitch, regive the player the ability to move
      if(movementState != 2 && millis() - this.lastKnockBack < 1500){
        check.canMove = true;
      }
      if((this.justHit || this.isHit) && this.movementState != 3){
        this.isHit = false;
        this.justHit = false;
      }
      
      checkDamaged(check);
      if(this.health <= 0)
        this.movementState = 4;
      
      PVector checkPlayerDistance = new PVector((int)(this.x-check.position.x), (int)(this.y-check.position.y));
      if(checkPlayerDistance.mag() < 100){
        this.movementState = 1;
      }
      
      this.x += this.velocity.x * (timer/1000.0f);
      this.y += this.velocity.y * (timer/1000.0f);
      
      if(millis() - moveTimer > 2000){
        movementState = 1;
      }
    }
    
    // Stop at walls
    boolean stop = false;
    for(int i = 0; i < wallCount; i++){
      if(walls.get(i).generalCollides((int)this.x, (int)this.y, 11)){
        stop = true;
      }
    }
    // Also stop if bounds set are overstepped.
    if(!(movementBoundLX == 0 && movementBoundRX == 0 && movementBoundUY == 0 && movementBoundDY == 0)){
      if(this.x-size/2 < movementBoundLX || this.x+size/2 > movementBoundRX || this.y - size/2 < this.movementBoundUY || this.y + size/2 > this.movementBoundDY){
        stop = true;
        if(movementState != 3){
          movementState = 5; //
          moveTimer = millis(); //
        }
      }
    }
    
    if(stop == true){
      this.x -= this.velocity.x * (timer/1000.0f);
      this.y -= this.velocity.y * (timer/1000.0f);
            
    }
    
    // Also, if the current position is still exceeding the bound, adjust accordingly.
    adjustPositionBasedOnBounds();
    
    
  }
  
  private void adjustPositionBasedOnBounds(){
    if(!(movementBoundLX == 0 && movementBoundRX == 0 && movementBoundUY == 0 && movementBoundDY == 0)){
      if(this.x-size/2 < movementBoundLX){
        this.x = movementBoundLX+size/2;
      }
      if(this.x+size/2 > movementBoundRX){
        this.x = movementBoundRX-size/2;
      }
      if(this.y-size/2 < movementBoundUY){
        this.y = movementBoundUY+size/2;
      }
      if(this.x+size/2 > movementBoundDY){
        this.y = movementBoundDY-size/2;
      }
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
      text("Knockbax", this.x, this.y-this.size/2-5);
    }
    
    stroke(30, 0, 0);
    rectMode(CENTER);
      fill(0, 30, 200);
      
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
