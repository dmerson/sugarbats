/*
Needs to be changes to allow append of the log file rather than overwrite. 
See http://stackoverflow.com/questions/17010222/how-do-i-append-text-to-a-csv-txt-file-in-processing
for ideas.
*/
import processing.net.*; 
import processing.sound.*;
import java.text.*; // to add leading ")" to min and second
import java.util.Date;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoField;
  
BufferedReader batInputFile;
String baseFileName = "20160814011557Z-7 copy.txt";
String inFileName = baseFileName; // don't have this "../ReadBatBatchTelnetClient/" + baseFileName;

SinOsc sine;

DecimalFormat formatter = new DecimalFormat("00");
//String aFormatted = formatter.format(a);


Client myClient; 
int dataIn; 
String inString;
byte interesting = 10;
String sdateTime;
//int[][] fLocation = { { 250, 125 }, { 375, 250 }, { 325, 375 }, {175, 375 }, { 125, 250 }}; 
int[][] fLocation = { { 50, 250 }, { 183, 400 }, { 317, 400 }, {400, 250 }, { 317, 50 }, {183, 50}}; 
int[] frequnecy = { 100, 300, 500, 1000, 2000, 4000, 6000 };
Boolean[] soundAlreadyOn = { false, false, false, false, false, false, false };
FeedPort[] portshapes; 
//PrintWriter batOutputFile;
String line;
String year, month, day, hour, minute, second, ms;
int iYear, iMonth, iDay, iHour, iMinute, iSecond, ims;
ZonedDateTime recordDate;
int iLastRefreshTime; 
int iRefreshConnectionAfter = 600000; // 600 second = 10 min
ZonedDateTime zsipTime;
int numFeedPorts = 6;
Boolean audiofeedback = true;
Boolean pausePlayback = true;

void setup() {
   String DateTimeStamp; //<>//
  size(500, 500); 
  background(0); 
  sine = new SinOsc(this);

  batInputFile = createReader(inFileName);
  println("Data being read from: " + inFileName);
  //Read the first two header lines.
  try {
    line = batInputFile.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    line = null;
  }
  if (line == null) {
    // Stop reading because of an error or file is empty
    println("Nothing in file to read. Check format.");
    exit();  
  } 
  try {
    line = batInputFile.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    line = null;
  }
  if (line == null) {
    // Stop reading because of an error or file is empty
    println("No second line in file to read. Check format.");
    exit();  
  } else {
    String[] pieces = split(line, TAB); // First peice is datatime, second is milliseconds since program start
    ms = pieces[1];

  //DateTimeFormatter fileNameFormatter = DateTimeFormatter.ofPattern("yyyy-MM-ddTHH:mm:ss");
  DateTimeFormatter formatter = DateTimeFormatter.ISO_OFFSET_DATE_TIME;
  CharSequence cs = pieces[0];
  //parse(CharSequence text, DateTimeFormatter formatter);
  recordDate = ZonedDateTime.parse(cs, formatter);
  println("Date ->" + recordDate);
  
   // Create image ports = the number of ports
  portshapes = new FeedPort[numFeedPorts];
  int index = 0;
  for (int p = 0; p < numFeedPorts; p++, index++) {
    portshapes[index] = new FeedPort(fLocation[index][0],fLocation[index][1], 200, 200);
  }
 
  }
 
  ZonedDateTime recordDate = ZonedDateTime.now(ZoneId.systemDefault());
  DateTimeFormatter formatter = DateTimeFormatter.ISO_OFFSET_DATE_TIME;
  //DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy MM dd");
  String text = recordDate.format(formatter);
  ZonedDateTime parsedDate = ZonedDateTime.parse(text, formatter);
  println("Data being logged to: " + sdateTime + ".txt");
  //sdateTime += parsedDate + "\t" + String.valueOf(millis());
  iLastRefreshTime = millis(); // The connection will start counting down
  println("%%%DateTime\tms since program start");
  println(parsedDate + "\t" + String.valueOf(millis()));
  //batOutputFile.println(sdateTime);
  println("Press 'q' to save the log file and close the program.");
  println("Press 's' to toggle audio feedback on and off.");
  println("%%%DateTime\tms since program start");
  println(parsedDate + "\t" + String.valueOf(millis()));
  //println(sdateTime);
  //flush();
} 
 
void draw() { 
String sCode;
String line;
int iNowTime;
String year, month, day, hour, minute, second, ms;
int iYear, iMonth, iDay, iHour, iMinute, iSecond, ims;


 try {
    line = batInputFile.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    line = null;
  }
  if (line == null) {
    // Stop reading because of an error or file is empty
    //batOutputFile.flush(); // Writes the remaining data to the file
    //batOutputFile.close(); // Finishes the file
    exit(); // Stops the program
  } else {
    String[] pieces = split(line, TAB);
    ms = pieces[0];
    ims = Integer.parseInt(ms);
    sCode = pieces[1];
    iNowTime = millis();
    //println("iNowTime=" + iNowTime + " ims =" + ims );
    //delay (1000);
    while (ims > iNowTime ) iNowTime = millis();
    inString = sCode;
    //println( ms + " " + sCode);
    zsipTime = recordDate.plus(ims, ChronoField.MILLI_OF_DAY.getBaseUnit());
    println(zsipTime + " " + pieces[1]); 
    //batOutputFile.println(zsipTime + " " + pieces[1]);
    //int x = int(pieces[0]);
    //int y = int(pieces[1]);
    //point(x, y);
    if (inString == null) println ("Skipping because of empty line from the sensors");
    else {  
      inString = inString.trim();
      String[] ArrayofStrings = inString.split(",", -1);
      for (int i = 0; i < ArrayofStrings.length; ++i) {
        if (!isNumeric(ArrayofStrings[i])) { 
          println("It is not numeric!");
          println("Skipping string " + ArrayofStrings[i]);
        } // remove the nl at the end
        else {
          if (!drawAction2(ArrayofStrings[i])) { // it was not a number... just print it to consol and go on //<>//
            println("???: " + ArrayofStrings[i]);
          }
          // get the time and print the string to the log file.
          ArrayofStrings[i] = millis() + "\t" + ArrayofStrings[i]; 
          //inString += sdateTime;
          println(ArrayofStrings[i]); 
          //batOutputFile.println(ArrayofStrings[i]); 
          iLastRefreshTime = millis();
        }
      }
    }

  } 
} 
/***********************************************/
boolean drawAction2(String stemp) {
  // All Broken are White; All Open are black
  // Use the number to decide the location
  //Parse the string
  int iPortNumber;
  
  try {
    iPortNumber = parseInt(stemp);
  }
  catch (NumberFormatException e) { return(false); }
  //println("found the number: " + iPortNumber);
  placeEllipses(iPortNumber);
  return(true);
  
}
/***********************************************/

boolean placeEllipses(int iSensorNumber) {
  int iIndex;
  int iFill;
  if (iSensorNumber < 0) { // if negative the beam is broken
    //fill(0, 0, 0); //red
    iIndex = -iSensorNumber;
    iFill = 0;
    
    sine.stop();
    soundAlreadyOn[iIndex] = false;
   
    } else {
    iIndex = iSensorNumber;
    //fill(255, 0, 0);
    iFill = 255;
    
    if (audiofeedback == true && soundAlreadyOn[iIndex] == false) { // there are sometimes double on or double offs.
      soundAlreadyOn[iIndex] = true;
      sine.freq(frequnecy[iIndex]);
      sine.play();
    } 
    
  }
  iIndex--;
  portshapes[iIndex].display(iFill); 
  return(true);
}
/***********************************************/
class FeedPort {
  int xOffset;
  int yOffset;
  int xAxis;
  int yAxis;
  // Constructor
  FeedPort(int xOffsetTemp, int yOffsetTemp, int xAxisTemp, int yAxisTemp) {
    xOffset = xOffsetTemp;
    yOffset = yOffsetTemp;
    xAxis = xAxisTemp;
    yAxis = yAxisTemp;
  }
  // Custom Method to display
  void display() {
    ellipse(xOffset, yOffset, xAxis, yAxis);
    //println(xOffset + " " + yOffset);
  }
  void display(int iFill) {
    fill(iFill, 0, 0);
    ellipse(xOffset, yOffset, xAxis, yAxis);
    //println(xOffset + " " + yOffset);
  }
}
  
 
/***********************************************/
void keyPressed() {
  println("Key Pressed " + key);
  if (key == 'q') {
    //batOutputFile.flush(); // Writes the remaining data to the file
    //batOutputFile.close(); // Finishes the file
    exit(); // Stops the program
  }
  if (key == 's') {
    if (audiofeedback == true ) {
      audiofeedback = false; 
      for (int p = 0; p <= numFeedPorts; p++) {
        sine.freq(frequnecy[p]);
        sine.stop();
      }
    } else audiofeedback = true;
    return;
    }
  if (key == 'p') { // pause on/off
    if (pausePlayback == false ) {
      pausePlayback = true; 
      delay (10000);
    } else {
      pausePlayback = false; 
    }
  }
}  

/***********************************************/
public static boolean isNumeric(String inputData) {
  //println("In isNumeric " + inputData);
  return inputData.matches("[-+]?\\d+(\\.\\d+)?");
} //<>// //<>//