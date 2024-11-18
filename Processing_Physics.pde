World myWorld = new World();
int frameCount = 0;
float frameMilli = millis();

void setup() {
  size(1400, 1000);
  frameRate(60);
}

void draw() {
  frameCount += 1;
  background(#333333);
  float frameNow = millis();
  float diff = frameNow - frameMilli;
  if (frameCount % 30 == 0)
    myWorld.add(new PhysicsObject(new PVector(501, 200), (random(10)+1)*10, color(round(random(200)+30), round(random(200)+30), round(random(200)+30))));
  myWorld.update(diff/1000);
  frameMilli = millis();
}
