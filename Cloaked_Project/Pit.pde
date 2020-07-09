public class Pit extends Trap{

  public Pit(float LocationX, float LocationY, boolean isActive, int size, float timer) {
      super(LocationX, LocationY, isActive, size, timer);
      // TODO Auto-generated constructor stub
  }
  
  public Pit(float LocationX, float LocationY, boolean isActive, int size) {
      super(LocationX, LocationY, isActive, size, 0);
      // TODO Auto-generated constructor stub
  }
  
  public void operate(Player player){
    if(this.isActive){
      if(super.collidesWith(player.position.x, player.position.y, 0)){
          this.damageEntity(player);
      }
      
       for(int i = 0; i < ratCount; i++){
          Rat thisRat = rat.get(i);
          if(super.collidesWith(thisRat.x, thisRat.y, 0)){
            if(thisRat.type != 2){
              damageEntity(thisRat);
            }
          }
        }
        
        for(int i = 0; i < knockCount; i++){
          Knockbax thisKnock = knock.get(i);
          if(super.collidesWith(thisKnock.x, thisKnock.y, 0)){
            damageEntity(thisKnock);
          }
        }
        
        this.display();
    }
  }
  
  public void display(){
    fill(0);
    stroke(0, 0, 0);
    rectMode(CENTER);
    rect(this.locationX, this.locationY, this.size, this.size);
  }
  
  protected void damageEntity (Entity character) {
    character.kill();
  }

}
