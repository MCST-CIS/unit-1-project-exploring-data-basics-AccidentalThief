class PhysicsObject {
  PVector oldPosition, currentPosition, acceleration;
  float diameter, radius;
  color c;
  PhysicsObject(PVector position, float d, color rgb) {
    currentPosition = position;
    oldPosition = position;
    acceleration = new PVector(0, 0);
    diameter = d;
    radius = d/2;
    c = rgb;
  }
  
  void updatePosition(float dt) {
    PVector displacement = new PVector(currentPosition.x - oldPosition.x, currentPosition.y - oldPosition.y);
    oldPosition = currentPosition;
    currentPosition = new PVector(currentPosition.x + displacement.x + (acceleration.x * dt * dt), currentPosition.y + displacement.y + (acceleration.y * dt * dt));
    acceleration = new PVector(0, 0);
    fill(c);
    circle(currentPosition.x, currentPosition.y, diameter);
  }
  
  void accelerate(PVector a) {
    acceleration.x += a.x;
    acceleration.y += a.y;
  }

  void setVelocity(PVector v, float dt) {
    oldPosition.x = currentPosition.x - (v.x * dt);
    oldPosition.y = currentPosition.y - (v.y * dt);
  }

  void addVelocity(PVector v, float dt) {
    oldPosition.x -= v.x * dt;
    oldPosition.y -= v.y * dt;
  }

}

class World {
  float time = 0;
  int subSteps = 8;
  ArrayList<PhysicsObject> objects = new ArrayList<PhysicsObject>();
  PVector gravity = new PVector(0, 1000);
  
  void update(float dt) {
    /*
    for(int i = 0; i < subSteps; i++) {
      time += dt/subSteps;
      applyGravity();
      applyContraints();
      solveCollision();
      updatePositions(dt/subSteps);
    }
    */
    time += 1.0/60.0;
    applyGravity();
    applyContraints();
    solveCollision();
    updatePositions(1.0/60.0);
  }
  
  void add(PhysicsObject object) {
    objects.add(object);
  }
  
  void updatePositions(float dt) {
    for(PhysicsObject i : objects) {
      i.updatePosition(dt);
    }
  }
  
  void applyGravity() {
    for(PhysicsObject i : objects) {
      i.accelerate(gravity);
    }
  }
  
  void applyContraints() {
    PVector position = new PVector(500, 500);
    float diameter = 970.0;
    fill(#ffffff);
    circle(position.x, position.y, diameter);
    for(int i = 0; i < objects.size(); i++) {
      PVector to_object = new PVector(objects.get(i).currentPosition.x - position.x, objects.get(i).currentPosition.y - position.y);
      float dist = sqrt((to_object.x * to_object.x) + (to_object.y * to_object.y));
      if(dist > diameter/2 - objects.get(i).radius) {
        PVector n = new PVector((to_object.x / dist), (to_object.y / dist));
        objects.get(i).currentPosition = new PVector(objects.get(i).currentPosition.x + n.x * (diameter/2 - objects.get(i).radius - dist), objects.get(i).currentPosition.y + n.y * (diameter/2 - objects.get(i).radius - dist));
      }
    }
  }
  
  void solveCollision() {
    for(int i = 0; i < objects.size(); i++) {
      for(int j = i+1; j < objects.size(); j++) {
        PVector collisionAxis = new PVector(objects.get(i).currentPosition.x - objects.get(j).currentPosition.x, objects.get(i).currentPosition.y - objects.get(j).currentPosition.y);
        float dist = sqrt((collisionAxis.x * collisionAxis.x) + (collisionAxis.y * collisionAxis.y));
        // Check if overlapping
        if (dist < objects.get(i).radius + objects.get(j).radius) {
          PVector n = new PVector(collisionAxis.x / dist, collisionAxis.y / dist);
          float massRatio1 = objects.get(i).radius / (objects.get(i).radius + objects.get(j).radius);
          float massRatio2 = objects.get(j).radius / (objects.get(i).radius + objects.get(j).radius);
          //update positions
          objects.get(i).currentPosition = new PVector(
            objects.get(i).currentPosition.x + n.x * massRatio2 * (objects.get(i).radius + objects.get(j).radius - dist),
            objects.get(i).currentPosition.y + n.y * massRatio2 * (objects.get(i).radius + objects.get(j).radius - dist)
          );

          objects.get(j).currentPosition = new PVector(
            objects.get(j).currentPosition.x - n.x * massRatio1 * (objects.get(i).radius + objects.get(j).radius - dist),
            objects.get(j).currentPosition.y - n.y * massRatio1 * (objects.get(i).radius + objects.get(j).radius - dist)
          );
        }
      }
    }
  }
}
