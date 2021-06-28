import themidibus.*; //Import the library

MidiBus myBus; // The MidiBus

Blob[] blobs = new Blob[130];

boolean legato = false;

float currentHue = 0;

void setup() {

  MidiBus.list(); // List all available Midi devices
  myBus = new MidiBus(this, 0, -1); // set MIDI input, ignore output
  
  for (int i = 0; i < blobs.length; i++) {
    blobs[i] = new Blob(0, height, 0, 0, 0, "off");
  }

  colorMode(HSB, 100);
  
  size(800, 600); // or enable full screen:
  // fullScreen();

  background(0);
  // frameRate(60);
}

void draw() {
  currentHue = currentHue + 0.02;
  if (currentHue > 100) {
    currentHue = 0; 
  }
  background(0);

  for (int i = 0; i < blobs.length; i++) {
    if (blobs[i].s != "off") {   
      blobs[i].update();

      strokeWeight(blobs[i].r / 30);
      stroke(blobs[i].hue, 80, 50, 50);
      fill(blobs[i].hue, 90, 70, 70);

      ellipse(blobs[i].x, blobs[i].y, blobs[i].r/5, blobs[i].r/5);
      
      noStroke();
      fill(blobs[i].hue, 100, 100, 90);
      ellipse(blobs[i].x, blobs[i].y, blobs[i].r/10, blobs[i].r/10);
    }
  }
  // println(frameRate);
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
  blobs[pitch].rFinal = velocity * 5;
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
