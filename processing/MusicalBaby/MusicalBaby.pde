import processing.serial.*;
import processing.sound.*;

Serial port;
float inByte = 200, frequency = 0.5;
int min = 1, max = 45; 

SinOsc[] sineWaves; // Array of sines
float[] sineFreq; // Array of frequencies
int numSines = 5; // Number of oscillators to use

public void setup() {
  printArray(Serial.list());
  String portName = Serial.list()[1];
  port = new Serial(this, portName, 9600);

  size(640, 360);
  background(255);

  sineWaves = new SinOsc[numSines]; // Initialize the oscillators
  sineFreq = new float[numSines]; // Initialize array for Frequencies

  for (int i = 0; i < numSines; i++) {
    // Calculate the amplitude for each oscillator
    float sineVolume = (1.0 / numSines) / (i + 1);
    // Create the oscillators
    sineWaves[i] = new SinOsc(this);
    // Start Oscillators
    sineWaves[i].play();
    // Set the amplitudes for all oscillators
    sineWaves[i].amp(sineVolume);
  }
}

public void draw() {
  float detune = map(mouseX, 0, width, -0.5, 0.5);

  for (int i = 0; i < numSines; i++) { 
    sineFreq[i] = frequency * (i + 1 * detune);
    // Set the frequencies for all oscillators
    sineWaves[i].freq(sineFreq[i]);
  }
}

void serialEvent(Serial myPort) {
  String inString = myPort.readStringUntil('\n');

  if (inString != null) {    
    int intVal = abs(int(trim(inString)));

    if (intVal < min)
      min = intVal;

    if (intVal > max)
      max = intVal;

    //inByte = map(intVal, min, max, 600, 3000);
    inByte = map(intVal, min, max, 0, 1);
    frequency = pow(1000, inByte) + 150;
    println("Mapped: " + intVal + " to: " + inByte);
    println("Range: " + min + " to " + max);
  }
}
