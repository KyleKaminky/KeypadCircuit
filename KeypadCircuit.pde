/*
                           KEYPAD CIRCUIT
                           ----------------
   Description
   
*/


// Global Constants
final int BG_COLOR = #34344A;
final int COLUMN_COLOR = #80475E;
final int ROW_COLOR = 255;

final int GAP = 100;

// Global Variables



void setup() {
  size(1080, 1080);
  pixelDensity(displayDensity());
  
  
} // End of setup()



void draw() {
  background(BG_COLOR);
  
  drawKeypad();


} // End of draw()

void drawKeypad() {
  float size = 30;
  strokeWeight(4);
  //stroke(KEYPAD_COLOR);
  
  for (int i = 1; i < 5; i++){
    int x = GAP + width/4*i;
    line(x, GAP*2, x, height - GAP*2);
    for (int j = 0; j < 4; j++){
      int y = GAP*2 + height/5*j;
      stroke(ROW_COLOR);
      line(GAP, y-size*1.5, width-GAP, y-size*1.5);
      
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
