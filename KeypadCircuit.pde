/*
                           KEYPAD CIRCUIT
                           ----------------
   Description
   
*/


// Global Constants
final int BG_COLOR = #34344A;
final int COLUMN_COLOR = #80475E;
final int ROW_COLOR = #CC5A71;
final int CONNECTION_COLOR = #C89B7B; 
final int VOLTAGE_COLOR = #F0F757;
final String[] OPTIONS = {" ", "1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "#"};
final int VOLTAGE_SPEED = 10;
final int TITLE_SIZE = 60;

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


void setup() {
  //frameRate(5);
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
} // End of setup()



void draw() {
  counter++;
  background(BG_COLOR);
  
  //image(img, 0, 0, width*1.3, height*1.3);
  
  drawKeypad();
  
  switch (number_state) {
    case "none":
      //selection = 0;
      if (number_state_counter < 60) {
        number_state_counter++;  
      } else{
        number_state = "select";
        number_state_counter = 0;
      }
      break;
      
    case "select":
      selection = int(random(1,12));
      column = (selection-1) % 3 + 1;
      row = (selection-1) / 3;
      //selection = (selection + 1)%13;
      println("NEW SELECTION " + str(selection));
      v_x = GAP*1.5;
      v_y = GAP*2 + height/5*((selection-1)/3)-45;
      number_state = "wait";
      
      break;
      
    case "wait":
      number_state_counter++;
      int x_threshold = GAP + width/4*(column)-30;
      int x_threshold_2 = x_threshold + 30;
      float y_threshold_2 = height-GAP*1.5;
      float y_threshold = GAP*2 + height/5*(row);
      //float temp_x = (v_x < x_threshold) ? x_threshold : x_threshold_2;
      //float temp_y = (v_y < y_threshold) ? y_threshold : y_threshold_2;

      
      //println(temp_x);
      //println(temp_y);
      if (number_state_counter > 60){
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
      
      println(v_y + " " + y_threshold_2);
      if (v_y >= y_threshold_2) {
        draw_delay++;
        if (draw_delay < 200) {
          textSize(TITLE_SIZE);
          text("R" + str(row+1) + ", " + "C" + str(column) + " = " + OPTIONS[selection], width/2, height-textAscent());
        } else {
          //state = "moving_voltage";
          println("Moving to none");
          number_state = "none";
          selection = 0;
          number_state_counter = 0;
          draw_delay = 0;
          
          //delay(1000);
        }
      }
      
      
      //v_x = (v_x < temp_x && v_y == temp_y) ? v_x+5 : v_x;
      //v_y = (v_x == temp_x && v_y < temp_y) ? v_y + 5 : v_y;
      //println(x_threshold + " " + x_threshold_2);
      //println(y_threshold + " " + y_threshold_2);
      //println("----");
      
      break;
    
  }
  fill(255);
  textAlign(LEFT, CENTER);
  textSize(TITLE_SIZE);
  String s = "Button Pressed: " + OPTIONS[selection];
  text(s, width/2 - textWidth("Button Pressed:  ")/2, GAP/2+10);
  textAlign(CENTER, CENTER);

  
  if (selection != 0){
    drawConnection(GAP+ (width/4)*((selection-1)%3 + 1) - 35, GAP*2+height/5*((selection-1)/3) - 5, CONNECTION_COLOR);
    //delay(1000);
  }
  


} // End of draw()

void drawKeypad() {
  fill(255);
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
 
}

void drawConnectionPiece(float x, float y, float s, int r, int c){
  stroke(r);
  line(x-s, y, x, y);
  line(x-s, y-s, x-s,y);
  line(x-s, y-s, x, y-s);
  stroke(c);
  line(x-s/2, y-s/2, x+s/2, y-s/2);
  line(x-s/2, y+s/2, x+s/2, y+s/2);
  line(x+s/2, y-s/2, x+s/2, y+s/2);
}

void drawConnection(float x, float y, int c) {
  noStroke();
  rectMode(CENTER);
  fill(c, 200);
  rect(x, y, 60, 60);
  //draw square over connection
  
}

void drawVoltage(float x, float y, int c) {
  noStroke();
  fill(c);
  circle(x, y, 30);
  
}
