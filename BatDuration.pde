/*
 * Read a time file of the form DateTime Sensorcode
 * For each sensor find the beam broke - beam opened pair 
 * Print the start time and duration and code in 3 columns
 * May require a look ahead
*/
import java.text.*; // to add leading ")" to min and second
import java.util.Date;
import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.time.Instant;
import java.time.format.DateTimeFormatter;
import java.time.temporal.ChronoField;
import java.time.temporal.ChronoUnit;


BufferedReader batInputFile;
String baseFileName = "20160815195742-07.txt";
String inFileName = "../../grants/BatFeeding/data/Bat20160815-16LongTime.csv";
String outFileName = "../../grants/BatFeeding/data/Bat20160815-16Duration.csv";
PrintWriter batOutputFile;

ZonedDateTime zsipTimeStart[] = new ZonedDateTime[7];
Instant StartInstant[] = new Instant[7];
Boolean bStarted[] = { false, false, false, false, false, false, false};
ZonedDateTime zsipTimeTemp;
DateTimeFormatter formatter;
int numSensors = 6;


void setup() {
  String line;
  batInputFile = createReader(inFileName);
  println("Data being read from: " + inFileName);
  batOutputFile = createWriter(outFileName);

  //Read the first header lines.
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
  } else {
    println(line);
    String[] pieces = split(line, TAB); // Header line has 2 parts
    batOutputFile.println("StartTime\tDuration\tSensorNumber");
  }
  formatter = DateTimeFormatter.ISO_OFFSET_DATE_TIME;

}
/************************************************************************/

void draw() {
String sCode;
String line;
int iSensor;
int iLineNumber = 0;
 try {
    line = batInputFile.readLine();
  } catch (IOException e) {
    e.printStackTrace();
    line = null;
  }
  //println(line);
  if (line == null) {
    // Stop reading because of an error or file is empty
    batOutputFile.flush(); // Writes the remaining data to the file
    batOutputFile.close(); // Finishes the file
    exit(); // Stops the program
  } else {
    iLineNumber++;
    String[] pieces = split(line, TAB);
    //println("part 0 "+pieces[0]+" piece 2 "+pieces[1]);
    CharSequence cs = pieces[0];
    zsipTimeTemp = ZonedDateTime.parse(cs, formatter);
    iSensor = Integer.parseInt(pieces[1]);
    sCode = pieces[1];
    if (iSensor > 0) { // This is the beginning of a time interval
      //If there is already a time on the array for this sensor we have an error.
      if (bStarted[iSensor] == true) {
        println("Got two starts w/o an end. Time = "+zsipTimeStart[iSensor]);
      }
      zsipTimeStart[iSensor] = zsipTimeTemp; //<>//
      bStarted[iSensor] = true;
    } 
    else { 
      if (bStarted[-iSensor] == false) { // must be a negative of sensor off
        println("Got an end without a start. Line:"+iLineNumber+" Time = "+zsipTimeTemp);
        // Don't print end time just skip
      }
      else {
        //Print the Start time \t Duration \t Sensor Number (positive)
        //ZonedDateTime zsipTimeStart = ZonedDateTime.from(StartInstant[-iSensor]); 
        long duration = zsipTimeStart[-iSensor].until(zsipTimeTemp, ChronoField.MILLI_OF_DAY.getBaseUnit());
        batOutputFile.println(zsipTimeStart[-iSensor]+"\t"+duration+"\t"+-iSensor);
        println(zsipTimeStart[-iSensor]+"\t"+duration+"\t"+-iSensor);
        bStarted[-iSensor] = false; // clear it since it is done
      }
    }
  } 
} 
/**********************************************************/