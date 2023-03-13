class LinearBlackHole extends Planet {
  float x, x2, y, y2, x1, y1;
  PImage black_hole = loadImage("black_hole.png");
  LinearBlackHole(float _x1, float _y1, float _x2, float _y2, PImage _pic) {
    super(10.0, _x1, _y1, _pic, true, false);
    if (_x1 > _x2) {
      x = _x2;
      y = _y2;
      x1 = _x2;
      x2 = _x1;
      y1 = _y2;
      y2 = _y1;
    } else {
      x = _x1;
      y =_y1;
      x1 = _x1;
      x2 = _x2;
      y1 = _y1;
      y2 = _y2;
    }
  }

  void display() {
    super.posx = lerp(super.posx, x, 0.02);
    super.posy = lerp(super.posy, y, 0.02);
    image(black_hole, super.posx, super.posy);
    if (int(super.posx)  >= x2-1) {
      x = x1;
      y = y1;
    } else if (int(super.posx) <= x1+1) {
      x=x2;
      y= y2;
    }
  }
  PVector force(PVector pos) {
    PVector position = new PVector(posx, posy);
    PVector f = position.sub(pos);
    float d = f.mag();
    if (d <= radius+5) {
      return new PVector(-1, -1);
    }
    d = constrain(d, 0, 300); //Constrains it so that the player always feels the gravitational force of at least a distance of 250 pixels
    f.normalize();
    float strength = (15000)/(d*d);
    f.mult(strength);

    return f;
  }
}
