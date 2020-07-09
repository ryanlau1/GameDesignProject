public class Spikes extends Trap {
// Spikes are a trap that will retract every fixed ammount of time or for a little while as they are stepped on.
  private float trackTime;
  
  public Spikes(float LocationX, float LocationY, boolean isActive, int size, float timer) {
        super(LocationX, LocationY, isActive, size, timer);
        super.damage = 15;
        
      }
      
  public Spikes(float LocationX, float LocationY, boolean isActive, int size) {
      super(LocationX, LocationY, isActive, size, 0);
      super.damage = 15;
      // TODO Auto-generated constructor stub
  }
 
  public void operate(Player player){
    if(super.isActive && millis() - this.cooldownTimer > 2000){
      if(super.collidesWith(player.position.x, player.position.y, player.pWidth/2)){
          this.damageEntity(player);
          this.cooldownTimer = millis();
      }
      
       for(int i = 0; i < ratCount; i++){
          Rat thisRat = rat.get(i);
          if(super.collidesWith(thisRat.x, thisRat.y, 11)){
            damageEntity(thisRat);
            this.cooldownTimer = millis();
          }
        }
        
        for(int i = 0; i < knockCount; i++){
          Knockbax thisKnock = knock.get(i);
          if(super.collidesWith(thisKnock.x, thisKnock.y, thisKnock.size/2)){
            damageEntity(thisKnock);
            this.cooldownTimer = millis();
          }
        }
        
        
    }
    
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
    if(this.isActive){
      fill(120);
    }
    else{
      fill(75);
    }
    stroke(0, 0, 0);
    rectMode(CENTER);
    rect(this.locationX, this.locationY, this.size, this.size);
  } 
}
  
