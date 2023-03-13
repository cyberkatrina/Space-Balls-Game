import java.io.FileWriter;
import java.io.*;

import ddf.minim.*;
import ddf.minim.AudioPlayer;
Minim minim;
AudioPlayer song;
AudioPlayer jump;
AudioPlayer hole;
AudioPlayer score;

PImage gray_body;
PImage blue_body;
PImage green_body;
PImage red_body;
PImage orange_body;
PImage colour_body;
PImage colour_arml;
PImage colour_armr;
PImage startscreen;
PFont font;
PImage gray_r;
PImage gray_l;
PImage green_r;
PImage green_l;
PImage blue_r;
PImage blue_l;
PImage red_r;
PImage red_l;
PImage orange_r;
PImage orange_l;

Button start_game;
Button[] radios = new Button[5];

boolean runonce1 = true;
boolean runonce2 = true;
float ti;
float tf;
String time;
String highscore;
String[] highlist;
FileWriter output;

ArrayList<Planet> planets = new ArrayList<Planet>();
Player player;


void setup() {
  size(1000, 700);
  startscreen = loadImage("startscreen.png");
  image(startscreen, 0, 0, 1000, 700);
  font = loadFont("font.vlw");
  textFont(font);
  fill(255, 255, 255);
  
  highlist = loadStrings("highscore.txt");
  highscore = "100000";
  for(String score: highlist){
    if(float(score) < float(highscore)){
      highscore = score;
    }
  }

  try{
    output = new FileWriter("highscore.txt", true);
     }catch(IOException ioe){
       System.out.println("Exception ");
    }

  minim = new Minim(this);
  song = minim.loadFile("theme_song.wav");
  jump = minim.loadFile("jump.wav");
  hole = minim.loadFile("hole.wav");
  score = minim.loadFile("score.mp3");
  song.play();
  song.loop(500);
  start_game = new CheckBox(348, 275, 100);
  radios[0] = new Radio(140, 600, 30);
  radios[1] = new Radio(315, 600, 30);
  radios[2] = new Radio(500, 600, 30);
  radios[3] = new Radio(670, 600, 30);
  radios[4] = new Radio(840, 600, 30);
  ti = millis();
  gray_body = loadImage("gray_body.png");
  blue_body = loadImage("blue_body.png");
  green_body = loadImage("green_body.png");
  red_body = loadImage("red_body.png");
  orange_body = loadImage("orange_body.png");
  
  gray_r = loadImage("gray_r.png");
  gray_l = loadImage("gray_l.png");
  green_r = loadImage("green_r.png");
  green_l = loadImage("green_l.png");
  blue_r = loadImage("blue_r.png");
  blue_l = loadImage("blue_l.png");
  red_r = loadImage("red_r.png");
  red_l = loadImage("red_l.png");
  orange_r = loadImage("orange_r.png");
  orange_l = loadImage("orange_l.png");

  colour_body = gray_body;
  colour_armr = gray_r;
  colour_arml = gray_l;
  player = new Player(100, 600, colour_body, planets, colour_armr, colour_arml);
}


void draw() {
  if (player.stage == 1) {
    textAlign(CENTER);
    textSize(55);
    textSize(75);
    fill(255, 61, 116);
    start_game.draw();
    radios[0].draw();
    radios[1].draw();
    radios[2].draw();
    radios[3].draw();
    radios[4].draw();
    fill(184, 214, 224);
    textSize(25);
    text("choose player", 500, 650);
    text("HI: " + highscore, width/2, 30);
    text("press M to mute sound", width/2, 100);
  }
  if (player.stage >= 2 && player.stage <= 6) {
    if (runonce1) {
      ti = millis();
      runonce1 = false;
    }
    background(0);
    text(nf((millis() - ti)/1000, 0, 2), 50, 20);
    text("HI: " + highscore, width/2, 20);
    for (int i=0; i<player.planets.size(); i++) {
      player.planets.get(i).display();
    }
    player.display();
  }

  if (player.stage == 7) {
    background(0);
    text("Congrats", width/2, height/2);
    text("Time: " + time + " s", width/2, height/2 + 40);
    if (runonce2) {
      tf = millis();
      time = nf((tf - ti)/1000, 0, 2);
      runonce2 = false;
    }
    if (float(time) < float(highscore)) {
      text("New Highscore!", width/2, height/2 + 80);
      try{
        output.write(time);
        output.close();
      }catch(IOException ioe){
        //exit();
        println("this is gonna spam sorry, still working on it");
      }
    }
  }
}

void mousePressed() {
  start_game.press();
  if (start_game.is_pressed() && player.stage == 1) {
    if (radios[0].is_pressed()) {
      colour_body = gray_body;
      colour_armr = gray_r;
      colour_arml = gray_l;
    } else if (radios[1].is_pressed()) {
      colour_body = green_body;
      colour_armr = green_r;
      colour_arml = green_l;
    } else if (radios[2].is_pressed()) {
      colour_body = blue_body;
      colour_armr = blue_r;
      colour_arml = blue_l;
    } else if (radios[3].is_pressed()) {
      colour_body = red_body;
      colour_armr = red_r;
      colour_arml = red_l;
    } else if (radios[4].is_pressed()) {
      colour_body = orange_body;
      colour_armr = orange_r;
      colour_arml = orange_l;
    }
    player = new Player(100, 600, colour_body, planets, colour_armr, colour_arml);
    player.stage = 2;
    //start_game.is();
  }
  if ( ! start_game.is_pressed()) {
    radios[0].press();
    if (radios[0].is_pressed()) {
      radios[1].release();
      radios[2].release();
      radios[3].release();
      radios[4].release();
    }
    radios[1].press();
    if (radios[1].is_pressed()) {
      radios[0].release();
      radios[2].release();
      radios[3].release();
      radios[4].release();
    }
    radios[2].press();
    if (radios[2].is_pressed()) {
      radios[1].release();
      radios[0].release();
      radios[3].release();
      radios[4].release();
    }
    radios[3].press();
    if (radios[3].is_pressed()) {
      radios[1].release();
      radios[2].release();
      radios[0].release();
      radios[4].release();
    }
    radios[4].press();
    if (radios[4].is_pressed()) {
      radios[0].release();
      radios[2].release();
      radios[1].release();
      radios[3].release();
    }
  }
  player.landed = false;
  player.first_run = true;
  player.x = mouseX;
  player.y = mouseY;
}

void keyPressed() {
  player.keyPressed();
  if (key == 'm'){
      if (song.isMuted()){
        song.unmute();
        jump.unmute();
        hole.unmute();
        score.unmute();
      }
      else{
        song.mute();
        jump.mute();
        hole.mute();
        score.mute();
      }
    }
}

void stop(){ // always close Minim audio classes
  song.close();
  jump.close();
  hole.close();
  // always stop Minim before exiting
  minim.stop();
  // The super.stop() makes sure that all the normal cleanup routsines are done
  super.stop();
}
