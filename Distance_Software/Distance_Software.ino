/* Name: Stuart Armstrong
 * Date: Jan 17 Sunday
 * Purpose: To create a position time graph base on a distance varible
 */


// Distance Pins
int distancePin = A0;
int disValue = 0;
int disRange = 0;

void setup() {
  
  // Setting pin mode
  pinMode(distancePin, INPUT);
  pinMode(A0, INPUT);

  Serial.begin(9600);
}

void loop() {

  // Mapping and constraining The distance output
  disValue  = analogRead(distancePin);
  disRange = map(disValue, 0, 1023, 70, 350); //255
  disRange = constrain(disValue, 70, 350);   //255

  // Printing to serial for Swift to read
  Serial.print(disRange);
  Serial.print("|");

  delay(25);

}

