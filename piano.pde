import themidibus.*; //Import the library

MidiBus myBus; // The MidiBus

Blob[] blobs = new Blob[130];

boolean legato = false;

boolean enableStars = true;
boolean enableSparkles = true;
boolean highContrast = false;

float currentHue = 20;

PGraphics starCanvas;
PGraphics sparklerCanvas;

void setup() {

  MidiBus.list(); // List all available Midi devices
  myBus = new MidiBus(this, 0, -1); // set MIDI input, ignore output

  for (int i = 0; i < blobs.length; i++) {
    blobs[i] = new Blob(0, height, 0, 0, 0, "off");
  }

  colorMode(HSB, 100);

  size(1200, 500); // or enable full screen:
  //fullScreen();

  //surface.setResizable(true);

  //frameRate(30); // best at 60 fps

  sparklerCanvas = createGraphics(width, height);
  starCanvas = createGraphics(width, height);

  drawStars(200);

  background(0);
}

void draw() {
  currentHue = currentHue + 0.04;
  if (currentHue > 100) {
    currentHue = 0;
  }

  // fade out blobs using a black rectangle of low opacity
  noStroke();
  fill(0, 0, 0, 7);
  rect(0, 0, width, height);

  // draw stars
  if (enableStars) {
    if (random(0, 100) < 10) {
      fadeGraphics(starCanvas, 2);
      drawStars(0);
    }
    image(starCanvas, 0, 0); // draw stars to screen
  }

  // draw sparkles
  if (enableSparkles) {
    fadeGraphics(sparklerCanvas, 10);
    image(sparklerCanvas, 0, 0); // draw sparkles to screen
  }

  // draw blobs
  for (int i = 0; i < blobs.length; i++) {
    if (blobs[i].s != "off") {
      drawBlob(blobs[i]);
    }
  }
  //println(frameRate);
}

void drawBlob(Blob blob) {
  blob.update();

  if (enableSparkles) {
    drawSparkle(blob);
  }

  float hue1 = highContrast ? (blob.hue + 85) % 100.0 : blob.hue - 5;
  float hue2 = highContrast ? (blob.hue + 70) % 100.0 : blob.hue - 10;

  strokeWeight(blob.r / 30);
  stroke(hue2, 80, 50, 50);
  fill(hue1, 90, 70, 70);

  float squash = pow(blob.vy / 800, 2);
  float squash1 = 0.95 + squash;
  float squash2 = 0.90 + squash;

  ellipse(blob.x, blob.y, blob.r/5, blob.r/5 * squash2);

  noStroke();
  fill(blob.hue, 100, 100, 90);
  ellipse(blob.x, blob.y - blob.vy / 50, blob.r/10, blob.r/10 * squash1);
}

void drawSparkle(Blob blob) {
  if (random(0, 100) < 40) {
    sparklerCanvas.beginDraw();
    sparklerCanvas.colorMode(HSB, 100);
    // random sparkler

    sparklerCanvas.stroke(nearHue(blob.hue), 100, 100);

    int x = int(random(blob.x - 100, blob.x + 100));
    int y = int(random(blob.y - 100, blob.y + 100));

    sparklerCanvas.line(x, y, x + 4, y);
    sparklerCanvas.line(x + 2, y + 2, x + 2, y - 2);
    sparklerCanvas.endDraw();
  }
}

float nearHue(float hue) {
  float newHue = (highContrast ? hue + 50 : hue) + random(0, 10);
  
  return newHue > 100 ? newHue - 100 : newHue;
}

void drawStars(int minimum) {

  starCanvas.beginDraw();
  starCanvas.colorMode(HSB, 100);

  int numStars = minimum + 1;
  for (int i = 0; i < blobs.length; i++) {
    if (blobs[i].s == "on") {
      numStars++;
    }
  }
  for (int i = 0; i < numStars; i++) {
    starCanvas.stroke(currentHue, 100, 100, random(0, 100));
    starCanvas.point(int(random(width)), int(random(height)));
  }

  starCanvas.endDraw();
}

void noteOn(int channel, int pitch, int velocity) {
  //println("ON:  "+pitch);
  if (blobs[pitch].s == "off") { // only update hue when note is not present
    blobs[pitch].hue = currentHue;
  }
  blobs[pitch].s = "on";
  blobs[pitch].x = (pitch - 20) * width / 88;
  blobs[pitch].y = blobs[pitch].y > height ? height - 100 : blobs[pitch].y;
  blobs[pitch].vy = velocity * 7;
  blobs[pitch].rFinal = velocity * 7;
  //x++;
}

void noteOff(int channel, int pitch, int velocity) {
  //println("OFF: "+pitch);
}

// Pedal change:
void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  if (number == 64) {
    if (value == 0) {
      println("Legato OFF");
      legato = false;
    }
    if (legato == false && value > 0) {
      println("Legato ON");
      legato = true;
    }
  }
}

void keyPressed() {
  if (key == '1') {
    println("toggle stars");
    enableStars = !enableStars;
  } else if (key == '2') {
    println("toggle stparkes");
    enableSparkles = !enableSparkles;
  } else if (key == '3') {
    println("toggle high contrast");
    highContrast = !highContrast; 
  }
}

// Thank you to benja for the code:
// https://forum.processing.org/two/discussion/comment/54219/#Comment_54219
void fadeGraphics(PGraphics canvas, int fadeAmount) {
  canvas.beginDraw();
  canvas.loadPixels();

  // iterate over pixels
  for (int i = 0; i < canvas.pixels.length; i++) {

    // get alpha value
    int alpha = (canvas.pixels[i] >> 24) & 0xFF ;

    // reduce alpha value
    alpha = max(0, alpha-fadeAmount);

    // assign color with new alpha-value
    canvas.pixels[i] = alpha<<24 | (canvas.pixels[i]) & 0xFFFFFF ;
  }

  canvas.updatePixels();
  canvas.endDraw();
}
