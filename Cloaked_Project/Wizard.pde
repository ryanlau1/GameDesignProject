abstract class Wizard implements Entity{
    float health;
    float x;
    float y;
    int size;
    // PVector vel; teleport based, they will not use velocity
    //float maxSpeed;
    /*PVector projectileVel;
    float projectileX;
    float projectileY;*/ // Will attempt an object projectile system instead, in which once created they keep track of their own parameters  
    
    ArrayList<Wizard> others;
    
    int movementState; // 1: teleport and shoot; 2: touched player; 3: hit by player; 4 was killed by player
    float moveTimer = 0;
    boolean alreadyShot = false;
    boolean justHit = false;
    boolean isHit = false;
    
    //float lastKnockBack;
    //float velocityOnKnockbackX;
    //float velocityOnKnockbackY;
    
    boolean firstEncounter;
    
    Wizard(int xPos, int yPos, ArrayList<Wizard> arr, boolean newEnemy){
      x = xPos;
      y = yPos;
      //velocity = new PVector(0, 0);

      //maxSpeed = 140;
    
      others = arr;
      health = 5;
      movementState = 1;
      
      size = 50;
      
      firstEncounter = newEnemy;
  }
  
      Wizard(int xPos, int yPos, ArrayList<Wizard> arr, int WizardSize){ // exclusive constructor for use with the boss wizard
      x = xPos;
      y = yPos;
      //velocity = new PVector(0, 0);

      //maxSpeed = 140;
    
      others = arr;
      health = 120;
      movementState = 1;
      
      size = WizardSize;
      
      firstEncounter = false;
  }
  
  void detectCollision(Player player){
    int fromCenter = size/2;
    /*if(this.x-fromCenter < leftWallBound){
      this.x = leftWallBound + fromCenter;
    }
    
    if(this.x+fromCenter > rightWallBound){
      this.x = rightWallBound - fromCenter;
    }*/
    
    // Detecting collision is pointless for wizards and makes the boss unbeatable as the contact can conflict with the sword slashes.
    /*if(dist(this.x, this.y,player.position.x, player.position.y) < player.pHeight/2 + (size/2)){
      this.movementState = 2;
      this.justHit = true;
      
      this.x -= 30;
      this.y -= 30;
    }*/
    
  }
  
   void movement(Player check, float timer){
    if(movementState == 1){
      if(millis() - moveTimer > 4000){
        this.x = getRandomX();
        this.y = getRandomY();
        while(this.checkCoordinates(check)){
          this.x = getRandomX();
          this.y = getRandomY();
        }
        
        moveTimer = millis();
        alreadyShot = false;
      }
      if(millis() - moveTimer > 700 && !this.alreadyShot){
        shootProjectile(check);
        this.alreadyShot = true;
      }
      checkDamaged(check);
      if(this.health <= 0)
        this.movementState = 4;
    }
    if(movementState == 2){ // bouceback from hitting the player
      if(justHit == true/*timer - moveTimer > 3500*/){
        justHit = false;
        //moveTimer = millis();
        this.x = getRandomX();
        this.y = getRandomY();
        movementState = 1;
      }
        /*if(!(millis() - moveTimer > 650)){
          this.x += this.velocity.x * (timer/1000.0f);
          this.y += this.velocity.y * (timer/1000.0f);
        }
        if(millis() - moveTimer > 1300){
          movementState = 1;
        }*/
    }   
    if(movementState == 3){
      if(justHit == true/*timer - moveTimer > 3500*/){
        justHit = false;
        //moveTimer = millis();
        this.x = getRandomX();
        this.y = getRandomX();
        movementState = 1;
        this.isHit = false;
      }
        /*if(!(millis() - moveTimer > 900)){
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
        }*/
    }
    if(movementState == 4){
      //for(int i = 0; i < this.others.)
      this.others.remove(this.others.indexOf(this));
      wizCount--;
      if(this instanceof BossWizard){
        wizCount = 0;
        wiz.clear();
        spectCount = 0;
        spect.clear();
        ratCount = 0;
        rat.clear();
        projectiles.clear();
        projectCount = 0;
      }
    }
  }
  
  boolean isHitBy(Player check){
    int fromCenter = size/2+15;
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
  
  /*void chasePlayer(Player check, float timer){
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
    
  }*/
  
  void display(){
    if(this.firstEncounter){
      fill(255);
      text("Wizard", this.x, this.y-this.size/2-5);
    }
    
    stroke(30, 0, 0);
    rectMode(CENTER);
      fill(192, 35, 214);
      if(this instanceof BossWizard){
        displayHealthBar();
        stroke(30, 0, 0);
        fill(160, 0, 0);
      }
      
    if(this.isHit){
      fill(230, 0, 0);
    }
    rect(this.x, this.y, this.size, this.size);
  }
  
  void displayHealthBar(){
    stroke(220, 0, 0);
    line(this.x-(this.size/2.0f)-10, this.y-this.size/2-10, (this.x-(this.size/2.0f)-10)+((this.x+(this.size/2.0f)+10)-(this.x-(this.size/2.0f)-10)), this.y-this.size/2-10);
    stroke(0, 220, 0);
      line(this.x-(this.size/2.0f)-10, this.y-this.size/2-10, (this.x-(this.size/2.0f)-10)+((health/120.0f)*((this.x+(this.size/2.0f)+10)-(this.x-(this.size/2.0f)-10))), this.y-this.size/2-10);
  }
    
  public abstract void shootProjectile(Player check); // Override for each type of wizard to create the projectile object and send it on it's way.
  
  private float getRandomX(){
    return random(leftWallBound+size, rightWallBound-size);
  } 
  
  private float getRandomY(){
    return random(size, height-size);
  } 
  
  public boolean checkCoordinates(Player player){ // prob
    for(int i = 0; i < wallCount; i++){
      if(walls.get(i).generalCollides((int)this.x, (int)this.y, size/2)){
        return true;
      }
    }
    if(!(this instanceof BossWizard)){
      if(dist(this.x, this.y, player.position.x , player.position.y) < 350){
          return true;
      }
      else{
        return false;
      }
    }
    else{
      return false;
    }
  }
    
  public void takeDamage(float damage){
    this.health -= damage;
  }
  
  public void kill(){
    this.health = 0;
  }
 }
  
  class NormalWizard extends Wizard{
    //ArrayList<NormalWizard> others;
    NormalWizard(int xPos, int yPos, ArrayList<Wizard> arr){
      super(xPos, yPos, arr, false);
    }
    NormalWizard(int xPos, int yPos, ArrayList<Wizard> arr, boolean newEnemy){
      super(xPos, yPos, arr, newEnemy);
    }
    
    public void shootProjectile(Player check){
      int quadrant = quadrantOfPoint(this.x, this.y, check); // may be wrong because of negative y
    
      float theta = angleFromPoint(this.x, this.y, check, quadrant);
      
      float projVelY=sin(radians(theta))*170;
      float projVelX=cos(radians(theta))*170;
      
      // Then, based on quadrant calculate sign of speed.
      if(quadrant == 1 || quadrant == 4){
        projVelX *= -1;
      }
      if(quadrant == 1 || quadrant == 2){
        projVelY *= -1;
      }
     
       projectiles.add(new NormalWizardProjectile(this.x, this.y, projVelX, projVelY, 7));
       projectCount++;
    }
  }
  
  class BossWizard extends Wizard{
    //ArrayList<NormalWizard> others;
    BossWizard(int xPos, int yPos, ArrayList<Wizard> arr){
      super(xPos, yPos, arr, 150);
    }
    
    public void shootProjectile(Player check){
      int quadrant = quadrantOfPoint(this.x, this.y, check); // may be wrong because of negative y
    
      float theta = angleFromPoint(this.x, this.y, check, quadrant);
      
      float projVelY=sin(radians(theta))*170;
      float projVelX=cos(radians(theta))*170;
      
      // Then, based on quadrant calculate sign of speed.
      if(quadrant == 1 || quadrant == 4){
        projVelX *= -1;
      }
      if(quadrant == 1 || quadrant == 2){
        projVelY *= -1;
      }
     
       projectiles.add(new BossWizardProjectile(this.x, this.y, projVelX, projVelY, 10, (int)this.health));
       projectCount++;
    }
    
  }
  
  /*class TripleWizard extends Wizard {
    
    PVector projectileVel2;
    float projectileX2;
    float projectileY2;
    PVector projectileVel3;
    float projectileX3;
    float projectileY3;  
    
    ArrayList<TripleWizard> others;
    
    // Add overide fire projectile funtion for triple Wizard
  }
  
  class ReboundWizard extends Wizard {
    int bounces;
    
  }
  
  class BigWizard extends Wizard {
    
    //Overide Fire projectile for a bigger size
  }
  
  class WallWizard extends Wizard {
    // Make projectile stoppedByWall false
  }
  
  class FastWizard {
  //Constuctor overides vel
  }*/
