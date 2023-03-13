static abstract class StaticButton {
  static int press_count = 0;
}

class Button extends StaticButton {
  int x, y = 0;
  float size = 0;
  color colour = color(131, 0, 201);
  color over_color = color(255, 255, 0);
  color press_color = color(220);
  boolean over = false;
  boolean pressed = false;

  Button(int x, int y, int size) {
    this.x = x;
    this.y = y;
    this.size = size;
  }

  boolean is_over() {
    return false;
  }

  void press() {
    if (is_over()) {
      press_count ++;
      pressed = true;
    }
  }

  void release() {
    pressed = false;
  }

  boolean is_pressed() {
    return pressed;
  }

  void draw() {
  }
}
