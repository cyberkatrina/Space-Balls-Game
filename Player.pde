class Player {
  float x, y, currAngle;
  float dx = 0;
  float dy = 0;
  float ddx = 0;
  float ddy =0;
  float wiggle =0;
  int closest_planet = 0;
  boolean first_run = true;
  boolean landed = false;
  PVector angle;
  PVector planetPos;
  PVector pos;
  int stage;
  int prev;
  PImage pic;
  PImage left;
  PImage right;
  PImage red_planet;
  PImage green_planet;
  PImage brown_planet;
  PImage teal_planet;
  PImage white_planet;
  PImage black_hole;
  PImage[] colors = new PImage[6];
  String[] leveltxt;
  int currentline = 0;
  float theta = 0;
  float theta_mod = 0.05;


  ArrayList<Planet> planets;
  float origx, origy;
  Player(float _x, float _y, PImage _pic, ArrayList<Planet> _planets, PImage _right, PImage _left) {
    x = _x;
    y = _y;
    pic = _pic;
    planets = _planets;
    right = _right;
    left = _left;
    origx = _x;
    origy = _y;
    stage = 1;
    prev =1;
    red_planet = loadImage("red.png");
    green_planet = loadImage("green.png");
    brown_planet = loadImage("brown.png");
    teal_planet = loadImage("teal.png");
    white_planet = loadImage("white.png");
    black_hole = loadImage("black_hole.png");
    colors[0] = red_planet;
    colors[1] = brown_planet;
    colors[2] = teal_planet;
    colors[3] = white_planet;
    colors[4] = green_planet;
    colors[5] = black_hole;
    leveltxt = loadStrings("level.txt");
    while (!(leveltxt[currentline].isEmpty())) {
      String[] planetinfo = split(leveltxt[currentline], ',');
      if (int(planetinfo[0]) == 0) {
        planets.add(new Planet(float(planetinfo[1]), float(planetinfo[2]), float(planetinfo[3]), colors[int(planetinfo[4])], boolean(planetinfo[5]), boolean(planetinfo[6])));
      } else if (int(planetinfo[0]) == 1) {
        planets.add(new BlackHole(float(planetinfo[1]), float(planetinfo[2]), colors[5]));
      } else if (int(planetinfo[0]) == 2) {
        planets.add(new LinearBlackHole(float(planetinfo[1]), float(planetinfo[2]), float(planetinfo[3]), float(planetinfo[4]), colors[5]));
      } else if (int(planetinfo[0]) == 3) {
        x = float(planetinfo[1]);
        y = float(planetinfo[2]);
      }

      currentline += 1;
    }
    currentline += 1;
  }



  void display() {
    if (x <= -300 || x >= 1400 || y <= -400 || y >= 1400 || prev != stage) {
      landed = false;
      first_run = true;
      x= origx;
      y = origy;
      dx = 0;
      dy = 0;
      prev = stage;
    }
    // Create a min max arms swing motion
    if (theta > 0.9 || theta < -0.8) {
      theta_mod *= -1;
    }
    if (landed) {
      if (first_run) {
        pos = new PVector(x, y);
        planetPos = new PVector(planets.get(closest_planet).posx, planets.get(closest_planet).posy);
        angle = pos.sub(planetPos);
        angle.normalize();
        currAngle = atan(angle.y/angle.x);
        if (planets.get(closest_planet).finalPlanet) {
          score.rewind();
          score.play();
          stage += 1;
          closest_planet = 0;
          x = origx;
          y = origy;
          dx = 0;
          dy = 0;
          nextLevel();
        }
        first_run = false;
      } else {
        if (planets.get(closest_planet).finalPlanet) {
        } else if (planets.get(closest_planet).clockwise) {
          currAngle += 0.1;
        } else {
          currAngle -= 0.1;
        }
      }
      if (angle.x < 0) {
        x = planetPos.x - planets.get(closest_planet).radius * cos(currAngle);
        y = planetPos.y - planets.get(closest_planet).radius * sin(currAngle);
      } else {
        x = planetPos.x + planets.get(closest_planet).radius * cos(currAngle);
        y = planetPos.y  + planets.get(closest_planet).radius * sin(currAngle);
      }

      pushMatrix();
      translate(x, y);
      if (angle.x <0) {
        rotate(currAngle-PI/2);
      } else {
        rotate(currAngle + PI/2);
      }
      pushMatrix();
      translate(-3, 0);
      rotate(-theta*0.8);
      image(right, 0, 0, 60, 45);
      pushMatrix();
      popMatrix();
      translate(5, 0);
      rotate(1.1*theta);
      image(left, 0, 0, 60, 45);
      popMatrix();
      image(pic, 0, 0, 45, 45);
      popMatrix();


      theta += theta_mod;
    } else {
      pushMatrix();
      translate(x, y);
      if (cos(currAngle) <0) {
        rotate(currAngle-PI/2);
      } else {
        rotate(currAngle + PI/2);
      }
      pushMatrix();
      translate(-3, 0);
      rotate(-theta*.8);
      image(right, 0, 0, 60, 45);
      pushMatrix();
      popMatrix();
      translate(5, 0);
      rotate(1.1*theta);
      image(left, 0, 0, 60, 45);
      popMatrix();
      image(pic, 0, 0, 45, 45);
      popMatrix();
      theta += theta_mod;
      int dist = Integer.MAX_VALUE;
      for (int i = 0; i < planets.size(); i++) {
        if (sq(planets.get(i).posx - x) + sq(planets.get(i).posy - y) < dist) {
          closest_planet = i;
          dist = int(sq(planets.get(i).posx - x) + sq(planets.get(i).posy - y));
        }
      }
      PVector pos = new PVector(x, y);
      ddx = (planets.get(closest_planet).force(pos).x);
      ddy = (planets.get(closest_planet).force(pos).y);
      if (ddx ==0 && ddy ==0) {  // this is to make the player stick on the planet
        landed = true;
        dx =0;
        dy =0;
      } else if (ddx == -1 && ddy == -1) {
        hole.rewind();
        hole.play();
        x= origx;
        y = origy;
        dx =0;
        dy =0;
      } else {
        dx += ddx;
        dy += ddy;
      }
      x += dx;
      y += dy;
    }
  }

  void keyPressed() {
    if (key == ' ' && landed) {
      jump.rewind();
      jump.play();
      pos = new PVector(x, y);
      angle = pos.sub(planetPos);
      angle.normalize();
      if (planets.get(closest_planet).finalPlanet) {
        return;
      }
      if (planets.get(closest_planet).radius < 50) {
        angle.mult(17);
      } else if (planets.get(closest_planet).radius < 100) {
        angle.mult(14.5);
      } else {
        angle.mult(10);
      }
      dx = angle.x;
      dy = angle.y;
      x+=dx;
      y += dy;
      landed = false;
      first_run = true;
    }
  }
  void nextLevel() {
    planets.clear();
    while (currentline != leveltxt.length && !(leveltxt[currentline].isEmpty())) {
      String[] planetinfo = split(leveltxt[currentline], ',');
      if (int(planetinfo[0]) == 0) {
        planets.add(new Planet(float(planetinfo[1]), float(planetinfo[2]), float(planetinfo[3]), colors[int(planetinfo[4])], boolean(planetinfo[5]), boolean(planetinfo[6])));
      } else if (int(planetinfo[0]) == 1) {
        planets.add(new BlackHole(float(planetinfo[1]), float(planetinfo[2]), colors[5]));
      } else if (int(planetinfo[0]) == 2) {
        planets.add(new LinearBlackHole(float(planetinfo[1]), float(planetinfo[2]), float(planetinfo[3]), float(planetinfo[4]), colors[5]));
      } else if (int(planetinfo[0]) == 3) {
        origx = float(planetinfo[1]);
        origy = float(planetinfo[2]);
      }
      currentline += 1;
    }
    if (currentline == leveltxt.length) {
      planets.add(new Planet(0, -1000000, 0, colors[0], false, false));
    }
    currentline += 1;
  }
}
