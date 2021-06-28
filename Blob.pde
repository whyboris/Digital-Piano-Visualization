class Blob {
  float x, y, r, rFinal, vx, vy, hue;
  String s;

  Blob(float xLoc, float yLoc, float radius, float velocityX, float velocityY, String state) { 
    x = xLoc;
    y = yLoc;
    r = radius;
    rFinal = radius;
    vx = velocityX;
    vy = velocityY;
    s = state; // status: `down`, `legato`, or `decay`
    hue = 0; // updated later
  }

  void update() {
    vy = vy - 5;
    if (vy < -500) {
      vy = -500; 
    }
    y = y - vy / 100;
    //r = r + 0.5;
    if (y > height) {
      s = "off"; 
    }
    if (y < 0) {
      y = 0;
      vy = -10; 
    }
    if (abs(r - rFinal) > 0.5) {
      r = r + 0.5 * (rFinal - r) / 2;
    }
    if (rFinal < 50) {
      rFinal = 50; 
    } else {
      rFinal = rFinal - 1; 
    }    
  }
}
