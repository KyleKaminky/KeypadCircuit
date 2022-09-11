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
final String[] OPTIONS = {"", "1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "0", "#"};

final int GAP = 100;

// Global Variables
String state;
float v_x, v_y;
int counter;
int selection;


void setup() {
  //frameRate(5);
  size(1080, 1080);
  pixelDensity(displayDensity());
  
  state = "moving_voltage";
  v_x = GAP*1.5;
  v_y = GAP;
  
  counter = 0;
  selection = 1;
} // End of setup()



void draw() {
  counter++;
  background(BG_COLOR);
  
  drawKeypad();
  println(state);
  switch (state) {
    case "moving_voltage":
      int c = (counter/60) % 4;
      v_y = c*height/5+ 2*GAP - 45;
      if (c+1 == selection % 3) {
        state = "selection";
      }
      break;
      
    case "selection":
      float x_threshold = GAP + width/4*(selection%3) - 30;
      float x_threshold_2 = x_threshold + 30;
      float y_threshold_2 = height-GAP*1.5;
      float y_threshold = GAP*2 + height/5*(selection/3);
      //float temp_x = (v_x < x_threshold) ? x_threshold : x_threshold_2;
      //float temp_y = (v_y < y_threshold) ? y_threshold : y_threshold_2;

      
      //println(temp_x);
      //println(temp_y);
      
      if (v_x < x_threshold){
        v_x += 5;
      } else if (v_y < y_threshold) {
        v_y += 5;
      } else if (v_x < x_threshold_2) {
        v_x += 5;
      } else if (v_y < y_threshold_2) {
       v_y += 5; 
      }
      
      //v_x = (v_x < temp_x && v_y == temp_y) ? v_x+5 : v_x;
      //v_y = (v_x == temp_x && v_y < temp_y) ? v_y + 5 : v_y;
      
      break;
      
    
    
  }
  println(v_x);
  println(v_y);
  println("----");
  drawConnection(GAP+ width/4 - 35, GAP*2+height/5 - 5, CONNECTION_COLOR);
  drawVoltage(v_x, v_y, VOLTAGE_COLOR);


} // End of draw()

void drawKeypad() {
  float size = 30;
  strokeWeight(4);
  //stroke(KEYPAD_COLOR);
  
  for (int i = 1; i < 4; i++){
    int x = GAP + (width)/4*i;
    stroke(COLUMN_COLOR);
    line(x, GAP*2, x, height - GAP*1.5);
    for (int j = 0; j < 4; j++){
      int y = GAP*2 + height/5*j;
      stroke(ROW_COLOR);
      line(GAP*1.5, y-size*1.5, width-GAP*2, y-size*1.5);
      line(x-size, y-size*1.5, x-size, y-size);
      
      stroke(COLUMN_COLOR);
      line(x - size/2, y, x, y);
      
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
  fill(c);
  circle(x, y, 30);
  
}
