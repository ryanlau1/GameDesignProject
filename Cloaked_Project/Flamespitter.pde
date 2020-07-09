public class Flamespitter extends Trap {
  //Anyone walking through the flame of a flamespitter will be delt damage over time as they are touching it
  int flameLength; // How far does it spit fire
  char direction; // 'u' for up, 'd' for down, 'l' for left, 'r' for right.
  float flameDamageUpdateTimer; // How often does it deal damage
  private float trackTime;
  
  public Flamespitter(float LocationX, float LocationY, boolean isActive,
      int size, float timer, char Direction, int flamelength) {
    super(LocationX, LocationY, isActive, size, timer);
    this.direction = Direction;
    this.flameLength = flamelength;
    this.flameDamageUpdateTimer = millis();
    this.damage = 15; // In damage per second
  }
  
  public void operate(Player player){
    if(this.isActive){
      float damageToDeal = ((millis()-this.flameDamageUpdateTimer)/1000.0f)*this.damage; // Calculate the damage per second that should be dealt out.
      if(this.collidingWithFire(player.position.x, player.position.y, player.pWidth/2)){
          this.damageEntity(player, damageToDeal);
      }
      
       for(int i = 0; i < ratCount; i++){
          Rat thisRat = rat.get(i);
          if(this.collidingWithFire(thisRat.x, thisRat.y, 11)){
            this.damageEntity(thisRat, damageToDeal);
          }
        }
        
        for(int i = 0; i < knockCount; i++){
          Knockbax thisKnock = knock.get(i);
          if(this.collidingWithFire(thisKnock.x, thisKnock.y, thisKnock.size/2)){
            this.damageEntity(thisKnock, damageToDeal);
          }
        }
    }
    
    this.flameDamageUpdateTimer = millis();
    
    if(timer != 0){
      if(millis()-trackTime > timer){
        if(super.isActive) {super.isActive = false;}
        else {super.isActive = true;}
        trackTime = millis();
      }
    }
    
    this.display();
  }
  
  public void display(){
    rectMode(CENTER);
    stroke(0, 0, 0);
    fill(193, 88, 88);
    rect(this.locationX, this.locationY, this.size, this.size);
    noStroke();
    if(this.isActive){
      fill(229, 133, 42);
      float fireXCoordinate = computeFireX();
      float fireYCoordinate = computeFireY();
      float fireWidth = computeFireWidth();
      float fireHeight = computeFireHeight();
      
      rect(fireXCoordinate, fireYCoordinate, fireWidth, fireHeight);
    }
  }
  
  protected void damageEntity (Entity character, float damageDealt) {
    character.takeDamage(damageDealt); // Needs this override to input the calculated damage over time.
  }

  private float computeFireX(){
      // Compute fire's x coordinate
      float fireXCoordinate;
      if(this.direction == 'l'){
        fireXCoordinate = this.locationX-(this.size/2)-flameLength/2;
      }
      else if(this.direction == 'r'){
        fireXCoordinate = this.locationX+(this.size/2)+flameLength/2;
      }
      else{
        fireXCoordinate = this.locationX;
      }
      return fireXCoordinate;
  }
  private float computeFireY(){
    // Compute fire's y coordinate
    float fireYCoordinate;
      if(this.direction == 'u'){
        fireYCoordinate = this.locationY-(this.size/2)-flameLength/2;
      }
      else if(this.direction == 'd'){
        fireYCoordinate = this.locationY+(this.size/2)+flameLength/2;
      }
      else{
        fireYCoordinate = this.locationY;
      }
      return fireYCoordinate;
  }
  private float computeFireWidth(){
      // Compute the width of the fire
      float fireWidth;
      if(this.direction == 'l' || this.direction == 'r'){
        fireWidth = flameLength;
      }
      else{
        fireWidth = this.size-(this.size*0.1);
      }
      return fireWidth;
  }
  
  private float computeFireHeight(){
      // Compute the height of the fire
      float fireHeight;
      if(this.direction == 'u' || this.direction == 'd'){
        fireHeight = flameLength;
      }
      else{
        fireHeight = this.size-(this.size*0.1);
      }
      return fireHeight;
  }
  
  private boolean collidingWithFire(float xCoordinate, float yCoordinate, float radius){
    if(xCoordinate+radius > computeFireX()-computeFireWidth()/2 && xCoordinate-radius < computeFireX()+computeFireWidth()/2 && yCoordinate+radius > computeFireY()-computeFireHeight()/2 && yCoordinate-radius < computeFireY()+computeFireHeight()/2){
      return true;
    }
    else{
      return false;
    }
  }

// Damage over time;
}
