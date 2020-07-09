public abstract class Projectile{
  float x;
  float y;
  PVector velocity;
  float damage;
  float radius;
  float projectileUpdateTimer;
  
  public Projectile(float xCoordinate, float yCoordinate, float velocityX, float velocityY, float r, float dmg){
    x = xCoordinate;
    y = yCoordinate;
    velocity = new PVector(velocityX, velocityY);
    damage = dmg;
    radius = r;
    this.projectileUpdateTimer = millis();
  }
  
  public void checkHit(Player player){
    if(dist(player.position.x, player.position.y, this.x, this.y) < player.pWidth/2+this.radius){ // hits
      player.takeDamage(this.damage);
      projectiles.remove(projectiles.indexOf(this));
      projectCount--;
    }
  }
  
  public void update(Player player){
    checkHit(player);
    this.x += ((millis()-this.projectileUpdateTimer)/1000)*this.velocity.x;
    this.y += ((millis()-this.projectileUpdateTimer)/1000)*this.velocity.y;
    this.projectileUpdateTimer = millis();
    
    if(this instanceof BossWizardProjectile){
      ((BossWizardProjectile)this).bossExclusiveUpdate();
    }
    
    this.display();
    
    if(this.x > 2000 && this.y > 2000){
      projectiles.remove(projectiles.indexOf(this));
      projectCount--;
    }
  }
  
  public abstract void display();
}

public class NormalWizardProjectile extends Projectile{
  public NormalWizardProjectile(float xCoordinate, float yCoordinate, float velocityX, float velocityY, float dmg){
    super(xCoordinate, yCoordinate, velocityX, velocityY, 7, dmg);
  }
  public  void display(){
    fill(0, 140, 30);
      ellipse(this.x, this.y, super.radius*2, super.radius*2);
    noFill();
    stroke(192, 35, 214);
      ellipse(this.x, this.y, (super.radius*2)+2, (super.radius*2)+2);
    noStroke();
  }
}

public class BossWizardProjectile extends Projectile{
  int bossHealth;
  
  public BossWizardProjectile(float xCoordinate, float yCoordinate, float velocityX, float velocityY, float dmg, int hp){
    super(xCoordinate, yCoordinate, velocityX, velocityY, 8, dmg);
    bossHealth = hp;
  }
  
  public void bossExclusiveUpdate(){
      int randomize = (int)random(1, 2000);
      if(randomize <= 3){
        if(randomize <= 1 && bossHealth < 70 && bossHealth > 10){ 
                    rat.add(new Rat((int)this.x, (int)this.y, 2, rat)); ratCount++;
        }
       else if(randomize <= 1 && bossHealth <= 10 && spectCount < 1){
                     spect.add(new Spectres((int)this.x, (int)this.y, spect)); spectCount++; 
       } 
        else if(wizCount < 9) { wiz.add(new NormalWizard((int)this.x, (int)this.y, wiz)); wizCount++; }
      }
  }
  
  public  void display(){
    fill(0, 140, 30);
      ellipse(this.x, this.y, super.radius*2, super.radius*2);
    noFill();
    stroke(120, 0, 0);
      ellipse(this.x, this.y, (super.radius*2)+2, (super.radius*2)+2);
    noStroke();
  }
}
