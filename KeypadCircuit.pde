/*
                           KEYPAD CIRCUIT
                           ----------------
   Description
   
*/


// Global Constants
final int FR = 60; // (fr/sec)
final int BG_COLOR = #1D1D1D;//#2F2F2F;//#34344A;
final int COLUMN_COLOR = #80475E;
final int ROW_COLOR = #339989;//#CC5A71;
final int CONNECTION_COLOR = #FFFAFB; 
final int VOLTAGE_COLOR = #C589E8;//#7DE2D1;//#F0F757;
final int TITLE_COLOR = #FFFAFB;
final String[] OPTIONS = {" ", "1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "#"};
final int VOLTAGE_SPEED = 10;
final int TITLE_SIZE = 60;
final int OPENING_DELAY = 1; // (sec)
final int CONNECTION_DELAY = 1; //(sec)
final int DRAW_DELAY = 3; //(sec)
final int GAP = 100;

// Global Variables
String state;
float v_x, v_y;
int counter;
int selection;
String number_state;
int number_state_counter;
int draw_delay;
PImage img;
int column, row;
IntList buttons = new IntList(); 


void setup() {
  frameRate(FR);
  size(1080, 1080);
  pixelDensity(displayDensity());
  
  textAlign(CENTER, CENTER);
  
  state = "moving_voltage";
  number_state = "none";
  v_x = GAP*1.5;
  v_y = GAP;
  
  counter = 0;
  selection = 0;
  number_state_counter = 0;
  draw_delay = 0;
  img = loadImage("keypad.jpeg");
  
  for (int i = 1; i < OPTIONS.length; i++) {
    buttons.append(i);
  }
  buttons.shuffle();
} // End of setup()



void draw() {
  counter++;
  background(BG_COLOR);
  
  //image(img, 0, 0, width*1.3, height*1.3);
  
  drawKeypad();
  
  switch (number_state) {
    case "none":
      if (number_state_counter < FR*OPENING_DELAY) {
        number_state_counter++;  
      } else{
        number_state = "select";
        number_state_counter = 0;
      }
      break;
      
    case "select":
      selection = buttons.remove(0);
      column = (selection-1) % 3 + 1;
      row = (selection-1) / 3;
      v_x = GAP*1.5;
      v_y = GAP*2 + height/5*(row)-45;
      number_state = "draw";
      break;
      
    case "draw":
      number_state_counter++;
      int x_threshold = GAP + width/4*(column)-30;
      int x_threshold_2 = x_threshold + 30;
      float y_threshold_2 = height-GAP*1.5;
      float y_threshold = GAP*2 + height/5*(row);

      drawConnection(GAP+ (width/4)*(column) - 35, GAP*2+height/5*(row) - 5, CONNECTION_COLOR);

      if (number_state_counter > CONNECTION_DELAY*FR){
        if (v_x < x_threshold){
          v_x += VOLTAGE_SPEED;
        } else if (v_y < y_threshold) {
          v_y += VOLTAGE_SPEED;
        } else if (v_x < x_threshold_2) {
          v_x += VOLTAGE_SPEED;
        } else if (v_y < y_threshold_2) {
         v_y += VOLTAGE_SPEED; 
        } 
        drawVoltage(v_x, v_y, VOLTAGE_COLOR);
      }
      
      if (v_y >= y_threshold_2) {
        draw_delay++;
        if (draw_delay < DRAW_DELAY*FR) {
          textSize(TITLE_SIZE);
          fill(TITLE_COLOR);
          String footer = "R" + str(row+1) + ", " + "C" + str(column) + " = " + OPTIONS[selection];
          text(footer, width/2, height-textAscent());
        } else {
          number_state = "none";
          selection = 0;
          number_state_counter = 0;
          draw_delay = 0;
        }
      }
      break;
      
    
  }
  
  fill(TITLE_COLOR);
  textAlign(LEFT, CENTER);
  textSize(TITLE_SIZE);
  String s = "Button Pressed: " + OPTIONS[selection];
  text(s, width/2 - textWidth("Button Pressed:  ")/2, GAP/2+10);
  textAlign(CENTER, CENTER);
  
  if (buttons.size() == 0) {
    noLoop();
  }

} // End of draw()

void drawKeypad() {
  fill(TITLE_COLOR);
  textSize(30);
  float size = 30;
  strokeWeight(4);
  //stroke(KEYPAD_COLOR);
  
  for (int i = 1; i < 4; i++){
    int x = GAP + (width)/4*i;
    stroke(COLUMN_COLOR);
    line(x, GAP*2, x, height - GAP*1.5);
    text("C" + i, x, height-GAP*1.5+textAscent()*1.2);
    for (int j = 0; j < 4; j++){
      
      int y = GAP*2 + height/5*j;
      if (i == 1){
        text("R" + (j+1), x - width/4.0, y - 45);
      }
      stroke(ROW_COLOR);
      line(GAP*1.5, y-size*1.5, width-GAP*2, y-size*1.5);
      line(x-size, y-size*1.5, x-size, y-size);
      
      stroke(COLUMN_COLOR);
      line(x - size/2.0, y, x, y);
      text(OPTIONS[j*3 + i], x-90, y-textAscent()/2);
      
      drawConnectionPiece(x-size, y, size, ROW_COLOR, COLUMN_COLOR);
    }
     
  }
 
} // End of drawKeypad()


void drawConnectionPiece(float x, float y, float s, int r, int c){
  stroke(r);
  line(x-s, y, x, y);
  line(x-s, y-s, x-s,y);
  line(x-s, y-s, x, y-s);
  stroke(c);
  line(x-s/2, y-s/2, x+s/2, y-s/2);
  line(x-s/2, y+s/2, x+s/2, y+s/2);
  line(x+s/2, y-s/2, x+s/2, y+s/2);
} // End of drawConnectionPiece()


void drawConnection(float x, float y, int c) {
  noStroke();
  rectMode(CENTER);
  fill(c, 200);
  rect(x, y, 60, 60);
} // End of drawConnection()


void drawVoltage(float x, float y, int c) {
  noStroke();
  fill(c);
  circle(x, y, 30);
} // End of drawVoltage()
