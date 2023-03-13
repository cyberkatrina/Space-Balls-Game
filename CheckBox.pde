class CheckBox extends Button {

  CheckBox(int x, int y, int size) {
    super(x, y, size);
  }

  void draw() {
    strokeWeight(7);
    stroke(is_over() ? over_color : color(194, 0, 65));
    //fill(pressed ? color(0, 0, 25) : color(0, 0, 80));
    noFill();
    rect(x, y, size * 3, size);
  }

  boolean is_over() {
    if (mouseX >= x && mouseX <= x+ size * 3 &&
      mouseY >= y && mouseY <= y+ size) {
      return true;
    } else {
      return false;
    }
  }
}
