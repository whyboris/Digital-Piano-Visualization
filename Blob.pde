class Blob {
  float x, y, r, vx, vy;
  String s;

  Blob(float xLoc, float yLoc, float radius, float velocityX, float velocityY, String state) { 
    x = xLoc;
    y = yLoc;
    r = radius;
    vx = velocityX;
    vy = velocityY;
    s = state; // status: `down`, `legato`, or `decay`
    // TODO: add color & alpha
  }

  void update() {
     vy = vy - 5;
     y = y - vy / 100;
     //r = r + 0.5;
     if (y > height) {
       s = "off"; 
     }
     if (y < 0) {
       y = 0;
       vy = -10; 
     }
  }
}
