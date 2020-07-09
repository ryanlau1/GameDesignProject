public class Wall{
  int x;
  int y;
  int w;
  int h;
  // NOTE! These walls will be reasoned about center.
  ArrayList<Wall> others = new ArrayList<Wall>();
  
  Wall(int wallPositionX, int wallPositionY, int wallWidth, int wallHeight){
    x = wallPositionX;
    y = wallPositionY;
    w = wallWidth;
    h = wallHeight;
  }
  
  boolean playerCollides(Player p){
    if(p.position.x+(p.pWidth/2) > this.x-(this.w/2) && p.position.x-(p.pWidth/2) < this.x+(this.w/2) && p.position.y-(p.pHeight/2) < this.y+(this.h/2) && p.position.y+(p.pWidth/2) > this.y-(this.h/2)){
      return true;
    }
    else return false;
  }
  
  boolean generalCollides(int checkx, int checky, int radius){ // Basically how this will work is if an enemies coordinates ever crosses the line we will reverse it's movement globally using it's current velocity.
    if(checkx+(radius) > this.x-(this.w/2) && checkx-(radius) < this.x+(this.w/2) && checky-(radius) < this.y+(this.h/2) && checky+(radius) > this.y-(this.h/2)){
      return true;
    }
    else return false;
  }
  
  void display(){
    stroke(0, 0, 0);
    rectMode(CENTER);
    fill(30, 65, 95);
    rect(this.x, this.y, this.w, this.h);
  }
}
