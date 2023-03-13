class Planet {
  float radius, posx, posy;
  PVector position;
  PImage pic;
  boolean clockwise;
  float angle =0;
  boolean finalPlanet;
  Planet(float _radius, float _posx, float _posy, PImage _pic, boolean _clockwise, boolean _finalPlanet) {
    radius = _radius;
    posx = _posx;
    posy= _posy;
    pic= _pic;
    clockwise = _clockwise;
    finalPlanet = _finalPlanet;
  }

  void display() {
    noStroke();
    imageMode(CENTER);
    pushMatrix();
    translate(posx, posy);
    rotate(angle);
    if (clockwise) {
      angle+=0.03;
    } else {
      angle -=0.03;
    }
    image(pic, 0, 0, radius * 2, radius * 2);
    popMatrix();
  }

  PVector force(PVector pos) {
    PVector position = new PVector(posx, posy);
    PVector f = position.sub(pos);
    float d = f.mag();
    if (d <= radius+5) {
      return new PVector(0, 0);
    }
    d = constrain(d, 0, 200); //Constrains it so that the player always feels the gravitational force of at least a distance of 250 pixels
    f.normalize();
    float strength = (9000)/(d*d);
    f.mult(strength);

    return f;
  }
}
