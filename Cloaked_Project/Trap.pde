public abstract class Trap{

  float locationX;
  float locationY;
  boolean isActive;
  int size;
  float timer;
  float cooldownTimer;
  float damage;
  
  public Trap(float LocationX, float LocationY, boolean isActive, int size, float timer) {
    this.locationX = LocationX;
    this.locationY = LocationY;
    this.isActive = isActive;
    this.size = size;
    this.timer = timer;
    this.cooldownTimer = 0; 
  }
  
  public boolean collidesWith(float xCoordinate, float yCoordinate, int radius){ // Checks if a trap is colliding with an object based on the square approximation of the object. Returns boolean if the collision is true.
    if(xCoordinate+radius > this.locationX-this.size/2 && xCoordinate-radius < this.locationX+this.size/2 && yCoordinate+radius > this.locationY-this.size/2 && yCoordinate-radius < this.locationY+this.size/2){
      return true;
    }
    else{
      return false;
    }
  }
  
  public abstract void operate(Player player); // Each trap should have an "operate" method. This self-contained method will run all checks and methods necessary relating to keeping it functioning as expected in the draw loop update by update.
  
  protected void damageIf(Entity character, int millisCheck){ //Takes in the parameter of how many miliseconds cooldown the trap should have.
    if(millis() - this.cooldownTimer > millisCheck){
      damageEntity(character);
      this.cooldownTimer = millis();
    }
  }
  
  protected void damageEntity (Entity character) {
    character.takeDamage(damage);
  }
  

}
