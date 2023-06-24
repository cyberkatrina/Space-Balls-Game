class Radio extends Button {

  Radio(int x, int y, int size) {
    super(x, y, size);
  }

  void draw() {
    strokeWeight(5);
    stroke(is_over() ? over_color : colour);
    fill(pressed ? color(255) : color(0));
    //noFill();
    circle(x, y, size);
  }

  boolean is_over() {
    float disX = x - mouseX;
    float disY = y - mouseY;
    return (sqrt(sq(disX) + sq(disY)) < size );
  }
}
