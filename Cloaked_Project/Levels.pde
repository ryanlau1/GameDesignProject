void runLevel1(){
  rat.add(new Rat(width/2-300, 100, 2, rat, true));
    rat.add(new Rat(width/2+300, 100, 2, rat, true));
      rat.add(new Rat(width/2-400, 200, 1, rat, true));
        rat.add(new Rat(width/2+400, 200, 1, rat, true));
  ratCount = 4;
}

void runLevel2(){
  walls.add(new Wall(width/2, 50, (rightWallBound-leftWallBound), 100));
  wallCount = 1;
  rat.add(new Rat(width/2-300, height/2, 1, rat));
  rat.add(new Rat(width/2+400, height/2+75, 2, rat));
  rat.add(new Rat(width/2+400, height/2-75, 2, rat));
  ratCount = 3;
  knock.add(new Knockbax(width/2, height/2, knock, true));
  knockCount = 1;
  
  pits.add(new Pit(width/4, height/4, true, 200));
  pits.add(new Pit(width - (width/4), height/4, true, 200));
  pits.add(new Pit(width/4, height-(height/4), true, 200));
  pits.add(new Pit(width-(width/4), height - (height/4), true, 200));
  pitCount = 4;
}

void runLevel3(){
  int spanUntil = height-300;
  walls.add(new Wall(width/3,spanUntil/2, 40, spanUntil));
  walls.add(new Wall(2*width/3, spanUntil/2, 40, spanUntil));
  wallCount = 2;
  
  int spikesSize = 40;
  int spanSoFar = spikesSize;
  while(spanSoFar < rightWallBound){
    if(spanSoFar < width/3 || spanSoFar > 2*width/3){
      spikes.add(new Spikes(spanSoFar+(spikesSize/2), height-300-(spikesSize/2), true, spikesSize, 1700));
      spikeCount++;
    }
    spanSoFar += spikesSize;
  }
  
  flamespitters.add(new Flamespitter(width/2+240, height/2, true, 100, 2300, 'l', 330));
  spitterCount = 1;
  
  wiz.add(new NormalWizard(width/2, 240, wiz, true));
  wiz.add(new NormalWizard(width/4, 180, wiz, true));
  wiz.add(new NormalWizard(3*width/4, 180, wiz, true));
  wizCount = 3;
}

void runLevel4(){ // Placeholder for fire stream level.
  walls.add(new Wall(leftWallBound+50, height/2+300, 100,100));
  walls.add(new Wall(rightWallBound-50, height/2+100, 100,100));
  walls.add(new Wall(leftWallBound+50, height/2-100, 100,100));
  wallCount = 3;

  flamespitters.add(new Flamespitter(leftWallBound+50, height/2+300, false, 100, 2100, 'r', width-180-leftWallBound));
  flamespitters.add(new Flamespitter(rightWallBound-50, height/2+100, false, 100, 2100, 'l', width-180-leftWallBound));
  flamespitters.add(new Flamespitter(leftWallBound+50, height/2-100, false, 100, 2100, 'r', width-180-leftWallBound));
  spitterCount = 3;
  
  knock.add(new Knockbax(width/2, height/2, knock, 0, width, height/2+100+50, height/2+300-50));
  knock.add(new Knockbax(width/2, height/2, knock, 0, width/2, height/2-100+50, height/2+100-50));
  knock.add(new Knockbax(width/2+200, height/2-50, knock, width/2, width, height/2-100+50, height/2+100-50));
  knock.add(new Knockbax(width/2, height/2-500, knock, 0, width/3, 1, height/2-100-50));
  knock.add(new Knockbax(width/2, height/2-500, knock, width/3, 2*width/3, 1, height/2-100-50));
  knock.add(new Knockbax(width/2, height/2-500, knock, 2*width/3, width, 1, height/2-100-50));
  knockCount = 6;
  
  wiz.add(new NormalWizard(width/2, 240, wiz));
  wiz.add(new NormalWizard(width/4, 180, wiz));
  wizCount = 2;

}

void runLevelBoss(){
  walls.add(new Wall(width/2, 50, (rightWallBound-leftWallBound), 100));
  wallCount = 1;
  wiz.add(new BossWizard(width/2, height/4, wiz));
  wizCount = 1;
}


void runLevel6(){
  spect.add(new Spectres(width/2, 200, spect));
  spect.add(new Spectres(width/2+200, 430, spect));
  spectCount = 2;
  
  //add random walls
  int maxWallSize = 250;
  for(int i = 0; i < 13; i++){
    walls.add(new Wall((int)random(leftWallBound, rightWallBound), (int)random(0, height), (int)(random(0, 1)*maxWallSize), (int)(random(0, 1)*maxWallSize)));
    while(walls.get(i).x-walls.get(i).w < leftWallBound || walls.get(i).x+walls.get(i).w > rightWallBound || walls.get(i).generalCollides((int)avatar.position.x, (int)avatar.position.y, 50)){
      walls.remove(i);
      walls.add(new Wall((int)random(leftWallBound, rightWallBound), (int)random(0, height), (int)(random(0, 1)*maxWallSize), (int)(random(0, 1)*maxWallSize)));
    }
    wallCount = i+1;
  }
}

void runLevel5(){
  runTest();
}

