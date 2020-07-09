class Player implements Entity{
  PVector position;
  PVector velocity;
  boolean moveable;
  float health;
  float maxHealth;
  int maxSpeed;
  int pHeight; //  default 25
  int pWidth; // default 20
  
  boolean canMove;
  
  float damageTaken;
  
  // Offensive
  int facing; // 1 up, 2 down, 3 left, 4 right
  int slashes; // Up to 3, refreshes on a timer, faster the less you have.
  boolean slashInUse;
  float slashTimer;
  float lastSlash;
  int slashRadius;
  
  // Boss Specific
  //float bossHealth = 150;
  
  Player(float x_position, float y_position){
    position = new PVector(x_position, y_position);
    velocity = new PVector(0, 0);
    moveable = false;
    maxSpeed = 50; // in pixels per second
    pHeight = 25;
    pWidth = 20;
    health = 100.0f;
    maxHealth = 100.0f;
    facing = 1;
    slashes = 3;
    slashTimer = 0;
    slashInUse = false;
    slashRadius = 30;
    canMove = true;
    damageTaken = -3001;
  }
  
  void startSlash(){ // called on keypress. Will slash if not already slashing.
    if(this.slashInUse == false && slashes > 0){
      this.slashInUse = true;
      this.slashTimer = millis();
      this.slashes--;
      this.lastSlash = millis();
    }
  }
  
  void slash(){
    if(this.slashInUse == true){
      if(!(millis() - slashTimer >  600)){
        noFill();
        stroke(160);
        if(this.facing == 1) //Facing up when slashing
          arc(this.position.x, this.position.y, 2*this.slashRadius, 2*this.slashRadius, PI, TWO_PI);
        if(this.facing == 2) // Facing down when slashing
          arc(this.position.x, this.position.y, 2*this.slashRadius, 2*this.slashRadius, 0, PI);
        if(this.facing == 3) // Facing left when slashing
          arc(this.position.x, this.position.y, 2*this.slashRadius, 2*this.slashRadius, HALF_PI, 3*HALF_PI);
        if(this.facing == 4) // Facing right when slashing
          arc(this.position.x, this.position.y, 2*this.slashRadius, 2*this.slashRadius, 3*HALF_PI, TWO_PI+HALF_PI);
        noStroke();
      }
      else{
        slashInUse = false;
      }
    }
  }
  
  public void takeDamage(float damage){
    this.health -= damage;
    damageTaken = millis();
  }
  
  public void kill(){
    this.health = 0;
  }
  
  public void showHealth(){
     fill(0, 220, 0);
     textFont(CrimeSix, 30);
     textAlign(LEFT);
     text("Health:", 75, height-5);
     rectMode(CORNER);
     stroke(0);
     rect(160, height-30, (this.health/this.maxHealth)*100, 27);
     noStroke();
     textAlign(CENTER);
     rectMode(CENTER);
  }
  
  public void reset(){
    this.position.x = width/2;
    this.position.y = height - avatar.pHeight/2;
    this.canMove = true;
    this.health = avatar.maxHealth;
    this.slashes = 3;
  }
  
}

int gamestate = 1;
final int STARTSCREEN = 1;
final int CREDITS = 2;
final int PLAY = 3;
final int GAMEOVER = 4;

int stage = 1; // returns which level the player is on so that this level can be loaded or reloaded;

// Font
PFont CrimeSix;
PFont Default;
PFont Hindi;
PFont Japanese;

// Event Triggers
boolean textFlash = true;
boolean creditRoll = false;

// Global Variables
int leftWallBound; // The bounds of the main walls in the game outlined by a x coordinate
int rightWallBound;

//int currentLevel = 1; // returns which level the player is on so that this level can be loaded or reloaded;

int creditRollPosition; 

// Entities initialised
Player avatar;

// Global timers
float lastTimeCount = 0;
int moveUpdateTimer = 0;
int piecesUpdateTimer = 0;

// Pieces
  // Enemies
ArrayList<Rat> rat = new ArrayList<Rat>();
  int ratCount = 0;
ArrayList<Knockbax> knock = new ArrayList<Knockbax>();
  int knockCount = 0;
ArrayList<Wizard> wiz = new ArrayList<Wizard>();
  int wizCount = 0;
ArrayList<Spectres> spect = new ArrayList<Spectres>();
  int spectCount = 0;
//ArrayList<TripleWizard> wiz_t2 = new ArrayList<TripleWizard>();
//ArrayList<ReboundWizard> wiz_t3 = new ArrayList<ReboundWizard>();
//ArrayList<BigWizard> wiz_t4 = new ArrayList<BigWizard>();
//ArrayList<WallWizard> wiz_t5 = new ArrayList<WallWizard>();
//ArrayList<FastWizard> wiz_t6 = new ArrayList<FastWizard>();

  // Traps
ArrayList<Wall> walls = new ArrayList<Wall>();
  int wallCount = 0;
ArrayList<Pit> pits = new ArrayList<Pit>();
  int pitCount = 0;
ArrayList<Spikes> spikes = new ArrayList<Spikes>();
  int spikeCount = 0;
ArrayList<Flamespitter> flamespitters = new ArrayList<Flamespitter>();
  int spitterCount = 0;
  
  //Other pieces
ArrayList<Projectile> projectiles = new ArrayList<Projectile>();
  int projectCount = 0;
// Initialise the game tokens based on the stage.
void initialiseGame(){
  avatar.reset();
    stage = 1;
    runLevel(stage);
}

void runTest(){
  rat.add(new Rat(100, 200, 1, rat));
  rat.add(new Rat(300, 200, 1, rat));
  rat.add(new Rat(500, 200, 2, rat));
  ratCount = 3;
  
  knock.add(new Knockbax(200,320,knock));
  knock.add(new Knockbax(400,320,knock));
  knockCount = 2;
  
  spect.add(new Spectres(width/2, 100, spect, true));
  spectCount = 1;
  
  wiz.add(new NormalWizard(width/2, height/2, wiz));
  wiz.add(new NormalWizard(width/2+170, height/2+30, wiz));
  wiz.add(new NormalWizard(width/2-170, height/2+30, wiz));
  wizCount = 3;
  
  walls.add(new Wall(400, 250, 100, 70));
  walls.add(new Wall(width/2+130, height/2+70, 70, 70));
  wallCount = 2;
  
  pits.add(new Pit(width/2-300, height/2+100, true, 200));
  pitCount = 1;
  
  spikes.add(new Spikes(width/2+200, height/2-20, true, 70, 4000));
  spikes.add(new Spikes(width/2+200+70, height/2-20, false, 70, 4000));
  spikes.add(new Spikes(width/2+200, height/2-20+70, false, 70, 4000));
  spikes.add(new Spikes(width/2+200+70, height/2-20+70, true, 70, 4000));
  spikes.add(new Spikes(width/2+200+70+70, height/2-20, false, 70, 4000));
  spikes.add(new Spikes(width/2+200+70+70, height/2-20+70, true, 70, 4000));
  spikeCount = 6;
  
  flamespitters.add(new Flamespitter(width/2+130, height/2+70, true,
      70, 2100, 'l', 240));
  spitterCount = 1;
}

void runLevel(int level){
  if(level == 1){
    runLevel1();
  }
  else if(level == 2){
    runLevel2();
  }
  else if(level == 3){
    runLevel3();
  }
  else if(level == 4){
    runLevel4();
  }
  else if(level == 5){
    runLevel5();
  }
  else if(level == 6){
    runLevel6();
  }
  else if(level == 7){
    runLevelBoss();
  }
  else{
    // Endgame stuff goes here
    clearBoard();
    avatar.reset();
    gamestate = CREDITS;
  }
}

// Runs all code necessary to update game state. This includes all collision detections and running required methods from enemies.
void update(){
  float difference =  millis() -  piecesUpdateTimer;
  piecesUpdateTimer = millis();
  
  for(int i = 0; i < spikeCount; i++){
    Spikes thisSpike = spikes.get(i);
    thisSpike.operate(avatar);
  }
  
  for(int i = 0; i < pitCount; i++){
    Pit thisPit = pits.get(i);
    thisPit.operate(avatar);
  }
  
  for(int i = 0; i < ratCount; i++){
    Rat thisRat = rat.get(i);
    thisRat.movement(avatar, difference);
    thisRat.detectCollision(avatar);
    thisRat.display();
  }
  
  for(int i = 0; i < knockCount; i++){
    Knockbax thisKnock = knock.get(i);
    thisKnock.movement(avatar, difference);
    thisKnock.detectCollision(avatar, difference);
    thisKnock.display();
  }
  
  for(int i = 0; i < spectCount; i++){
    Spectres thisSpect = spect.get(i);
    thisSpect.movement(avatar, difference);
    thisSpect.detectCollision(avatar);
    thisSpect.display();
  }
  
  for(int i = 0; i < wizCount; i++){
    Wizard thisWiz = wiz.get(i);
    thisWiz.movement(avatar, difference);
    thisWiz.detectCollision(avatar);
    thisWiz.display();
  }
  
  characterUpdate();
  drawWalls(leftWallBound, rightWallBound);
  
  for(int i = 0; i < wallCount; i++){
    Wall thisWall = walls.get(i);
    thisWall.display();
  }
  
  for(int i = 0; i < spitterCount; i++){
    Flamespitter thisSpitter = flamespitters.get(i);
    thisSpitter.operate(avatar);
  }
  
  for(int i = 0; i < projectCount; i++){
    Projectile thisProjectile = projectiles.get(i);
    thisProjectile.update(avatar);
  }
  
  avatar.slash();
  slashTimer();
  
  avatar.showHealth();
  
  runLevelEvents(stage);
  
  // PLACEHOLDER FOR GAME OVER, WILL NOT BE THE FINAL IMPLEMENTATION OF A GAME OVER STATE
  if(avatar.health <= 0){
    gamestate = GAMEOVER;
  }
  
}

void runLevelEvents(int tag){
 if(tag == 2){
    if(knockCount == 0){
      walls.clear();
      wallCount = 0;
    }
  }
  
  if(tag == 7){
    if(wizCount == 0){
      walls.clear();
      wallCount = 0;
    }
  }
}

void slashTimer(){
  float percentageComplete = 0;
  if(avatar.slashes == 2){
   if(millis() - avatar.lastSlash > 5000){
      avatar.lastSlash = millis();
      avatar.slashes++;
    }
    
    percentageComplete = (millis()-avatar.lastSlash)/5000;
  }
  if(avatar.slashes == 1){
    if(millis() - avatar.lastSlash > 3500){
      avatar.lastSlash = millis();
      avatar.slashes++;
    }
    percentageComplete = (millis()-avatar.lastSlash)/3500;
  }
  if(avatar.slashes == 0){
    if(millis() - avatar.lastSlash > 2000){
      avatar.lastSlash = millis();
      avatar.slashes++;
    }
    percentageComplete = (millis()-avatar.lastSlash)/2000;
  }
  
  textAlign(CENTER);
  fill(242, 215, 215);
  textFont(CrimeSix, 20);
  textAlign(LEFT);
  text("x"+avatar.slashes, 75, 923);
  if(avatar.slashes < 3){
    stroke(160, 0, 0);
    line(75, 930, 75+percentageComplete*(width-75-75), 930);
    noStroke();
  }
}

void setup(){
  background(160);
  size(1920/2, 1080-100);
  creditRollPosition = height+80;
  avatar = new Player(width/2, height-40);
  Default = createFont("Courier New", 20);
  CrimeSix = createFont("Crimes Times Six", 50);
  Hindi = createFont("Mangal", 20);
  Japanese = createFont("SimHei", 20);
}

void draw(){
   //if(gamestate != PLAY){
     background(100, 100, 120);
     leftWallBound = 80;
     rightWallBound = width-80;
     if(gamestate != PLAY) drawWalls(leftWallBound, rightWallBound);
     avatar.moveable = true;
     if(gamestate != PLAY) characterUpdate();
   //}
   
   
  switch(gamestate){
   case STARTSCREEN:
     textAlign(CENTER, TOP);
     stroke(15);
     fill(50, 50, 130);
     textFont(CrimeSix, 100);
     text("Cloaked", width/2, height/2);
     fill(255);
     textAlign(RIGHT);
     textFont(Default, 12);
     text("Press C for credits", width-120, height-40);
     textFont(Default, 25);
     textAlign(CENTER, BOTTOM);
     if(millis()-lastTimeCount > 780){
       if(textFlash) textFlash = false;
       else if(!textFlash) textFlash = true;
       lastTimeCount = millis();
     }
     if(textFlash){
       text("Press \"SPACEBAR\" to begin", width/2, height/2+350);
     }
   break;
   case CREDITS:
     textAlign(LEFT);
     textFont(Japanese, 25);
     //if(!creditRoll) creditRoll = true;
     text("Maxim MacFarlane - このゲムを作った人", 120 ,creditRollPosition-30);
     textFont(Hindi, 25);
     text("Archin Wadhwa - इस खेल पर काम करने वाला व्यक्ति", 120 ,creditRollPosition);
     textFont(Default, 25);
     text("Ryan Lau - Also a person who worked on this game", 120 ,creditRollPosition+30);
     updateCredits();
    break;
    case PLAY:
      update();
    break;
    case GAMEOVER:
     clearBoard();
     avatar.reset();
     textAlign(CENTER, TOP);
     stroke(15);
     fill(230, 0, 0);
     textFont(CrimeSix, 100);
     text("GAME OVER", width/2, height/2);
    break;
  }
  
}

/*void mouseClicked(){
  avatar.startSlash();
}*/

void keyPressed(){
  if(key == 'd' && avatar.moveable){
    avatar.velocity.x = avatar.maxSpeed;
    avatar.facing = 4;
  }
  else if(key == 'a' && avatar.moveable){
    avatar.velocity.x = -avatar.maxSpeed;
    avatar.facing = 3;
  }
  
  if(key == 'w' && avatar.moveable){
    avatar.velocity.y = -avatar.maxSpeed;
    avatar.facing = 1;
  }
  else if(key == 's' && avatar.moveable){
    avatar.velocity.y = avatar.maxSpeed;
    avatar.facing = 2;
  } 
  
  if(key == 'c' && gamestate == STARTSCREEN){
    gamestate = CREDITS;
  }
  if(key == ' ' & gamestate == PLAY){
    avatar.startSlash();
  }
  
  if(key == ' ' & gamestate == STARTSCREEN){
    //if(keyCode == SPACE && gamestate == STARTSCREEN){
      gamestate = PLAY;
      initialiseGame();
    //}
  }
  if(key == ' ' & gamestate == GAMEOVER){
    //if(keyCode == SPACE && gamestate == STARTSCREEN){
      gamestate = PLAY;
      runLevel(stage);
    //}
  }
  
}

void keyReleased(){
  if(key == 'd' || key == 'a'){
    avatar.velocity.x = 0;
  }
  if(key == 'w' || key == 's'){
    avatar.velocity.y = 0;
  }
}

void updateCredits(){
    creditRollPosition -= 60*((millis()-lastTimeCount)/1000);
    lastTimeCount = millis();
    if(creditRollPosition <= -100){gamestate = STARTSCREEN; creditRollPosition = height+80;}
}

void drawWalls(int bound_x1, int bound_x2){
    stroke(0, 0, 0);
     rectMode(CORNER);
     fill(30, 65, 95);
     rect(-10, 0, bound_x1, height);
     rect(bound_x2, 0, width-(bound_x2)+10, height);
     
}

void characterUpdate(){
  float timeSinceLastUpdate = millis()-moveUpdateTimer;
  //moveUpdateTimer = millis();
  if(avatar.canMove){
      avatar.position.x += avatar.velocity.x*(timeSinceLastUpdate/1000);
      avatar.position.y += avatar.velocity.y*(timeSinceLastUpdate/1000);
      moveUpdateTimer = millis(); //original placement in case problems occur
    
    /*if(avatar.position.x - avatar.pWidth/2 < leftWallBound){
      avatar.position.x = leftWallBound+avatar.pWidth/2;
    }
    if(avatar.position.x + avatar.pWidth/2 > rightWallBound){
      avatar.position.x = rightWallBound-avatar.pWidth/2;    
    }
    if(avatar.position.y+avatar.pHeight/2 > height){
      avatar.position.y = height-avatar.pHeight/2;
    }
    if(avatar.position.y-avatar.pHeight/2 < 0){
      avatar.position.y = height+avatar.pHeight/2; // Yes, it is mean't to warp
    }*/ // Version for original placement of block
  }
    if(avatar.position.x - avatar.pWidth/2 < leftWallBound){
      avatar.position.x = leftWallBound+avatar.pWidth/2;
    }
    if(avatar.position.x + avatar.pWidth/2 > rightWallBound){
      avatar.position.x = rightWallBound-avatar.pWidth/2;    
    }
    if(avatar.position.y+avatar.pHeight/2 > height){
      avatar.position.y = height-avatar.pHeight/2;
    }
    if(avatar.position.y-avatar.pHeight/2 < 0){
      avatar.position.y = height+avatar.pHeight/2; // Yes, it is mean't to warp
      clearBoard();
      if(gamestate == PLAY){
        stage++;
        runLevel(stage);
      }
      avatar.reset();
    }
    
    for(int i = 0; i < wallCount; i++){
      Wall thisWall = walls.get(i);
      if(thisWall.playerCollides(avatar)){
        avatar.position.x -= avatar.velocity.x*(timeSinceLastUpdate/1000);
        avatar.position.y -= avatar.velocity.y*(timeSinceLastUpdate/1000);
      }
    }
    
  drawPlayer(avatar.position.x, avatar.position.y, avatar.pWidth, avatar.pHeight);
}

void drawPlayer(float posx, float posy, int drawWidth, int drawHeight){
  stroke(0, 0, 0);
  if(millis() - avatar.damageTaken < 700){
    fill(230, 0, 0);
  }
  else{
    fill(25);
  }
  //rectMode(CENTER);
  ellipse(posx, posy, drawWidth, drawHeight);
}

void clearBoard(){
  rat.clear();
  ratCount = 0;
  
  knock.clear();
  knockCount = 0;
  
  spect.clear();
  spectCount = 0;
  
  wiz.clear();
  wizCount = 0;
  
  walls.clear();
  wallCount = 0;
  
  pits.clear();
  pitCount = 0;
  
  spikes.clear();
  spikeCount = 0;
  
  flamespitters.clear();
  spitterCount = 0;
  
  projectiles.clear();
  projectCount = 0;
}

