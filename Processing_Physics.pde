World myWorld = new World();
int ballsToSpawn = 0;
int ballCount = 1;
float spawnRate = 30;

String currentInput = "";
boolean editingBallCount = false;

PhysicsObject mouseInteract = new PhysicsObject(new PVector(0,0), 20, (#ffffff));

void setup() {
  size(1400, 1000);
  frameRate(60);
  myWorld.add(mouseInteract);
}

void draw() {
  //refresh background
  background(#333333);
  //add UI
  drawUI();
  //refresh for our frame rate. TODO: add math so even if framerate changes the math is still consitant
  myWorld.update(1.0 / 60.0);
  
  mouseInteract.currentPosition = new PVector(mouseX, mouseY);
  
  //if there are more balls to spawn
  if (ballsToSpawn > 0 && frameCount % spawnRate == 0) {
    //add ball
    myWorld.add(new PhysicsObject(
      new PVector(501, 200),
      (random(10) + 1) * 10,
      color(round(random(200) + 30), round(random(200) + 30), round(random(200) + 30))
    ));
    ballsToSpawn--;
  }
}

void drawUI() {
  fill(50);
  rect(1150, 100, 200, 40);
  fill(255);
  textSize(16);
  textAlign(LEFT, CENTER);
  text(editingBallCount ? currentInput : "Balls: " + ballCount, 1160, 120);

  fill(0, 200, 0);
  rect(1150, 160, 200, 40);
  fill(255);
  textAlign(CENTER, CENTER);
  text("Spawn Balls", 1250, 180);
}

//All this is for the UI

void mousePressed() {
  if (mouseX > 1150 && mouseX < 1350 && mouseY > 100 && mouseY < 140) {
    editingBallCount = true;
    currentInput = "";
  } else if (mouseX > 1150 && mouseX < 1350 && mouseY > 160 && mouseY < 200) {
    ballsToSpawn += ballCount;
  } else {
    editingBallCount = false;
  }
}

void keyPressed() {
  if (editingBallCount) {
    if (key == BACKSPACE && currentInput.length() > 0) {
      currentInput = currentInput.substring(0, currentInput.length() - 1);
    } else if (key == ENTER) {
      ballCount = max(1, int(parseFloat(currentInput)));
      editingBallCount = false;
    } else if (key >= '0' && key <= '9') {
      currentInput += key;
    }
  }
}
