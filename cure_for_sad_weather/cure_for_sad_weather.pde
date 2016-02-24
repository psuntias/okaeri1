import org.firmata.*;
import cc.arduino.*;

import processing.serial.*;


JSONObject json;
Arduino arduino;

int servoPin = 10;
int fanPin = 3;
int pos = 0;
int counter = 0;
int fanPos = 0;
int ledPin = 8;
int ledPin1 = 7;
int ledPin2 = 6;
int ledPin3 = 5;
int ledPos = 0;


String url = "https://www.kimonolabs.com/api/7kjnh48w?apikey=DkcFrlrgrTtZGKAg4om04RjwpgPE2BMw";

void setup() {
  arduino = new Arduino(this, Arduino.list()[2], 57600);
  arduino.pinMode(servoPin, Arduino.SERVO);
  arduino.pinMode(fanPin, Arduino.OUTPUT);
  size(640, 360);
  loadData();
}

void draw() {
//      arduino.analogWrite(fanPin, fanPos);
      arduino.servoWrite(servoPin, pos);

//      println(pos);
//      println("fan: " +fanPos);
}



void loadData() {
  json = loadJSONObject(url);
  print(json);


  String todaysDate = json.getString("thisversionrun");
  String delims = "[ ]+";
  String[] day = todaysDate.split(delims);
  //date of the month
  println("month: " +day[1]);
  println("date:" +day[2]);


  JSONObject results = json.getJSONObject("results");

  JSONArray jsonEvents = results.getJSONArray("collection1");
  for (int i = 0; i < jsonEvents.size (); i++)
  {
    JSONObject collection1 = jsonEvents.getJSONObject(i);
    int index = collection1.getInt("index");

    if (index == 1)
    {
      int feels = collection1.getInt("feels");
      String wind = collection1.getString("wind");
      String[] windSplit = wind.split(" ");
      int windValue = parseInt(windSplit[1]);
      String condition = collection1.getString("condition");
      String precipitation = collection1.getString("precipitation");
      int precipValue = parseInt(precipitation);

      println("feels like: " +feels);
      println("wind value: " +windValue);
      println("rain value: " +precipValue);

      if ((feels <= 60) && (windValue >= 4)) { //&& ((condition == "Cloudy") || 
        //(condition == "Mostly Cloudy")|| (condition == "Showers") || (condition == "AM Showers") ||
       // (condition == "PM Showers")) 
          println("sad weather");
        if (pos !=180) {
          fanPos = 255;
          pos = 180;
          ledPos = 255;
          arduino.analogWrite(fanPin, fanPos);
          arduino.digitalWrite(ledPin, ledPos);
          arduino.digitalWrite(ledPin1, ledPos);
          arduino.digitalWrite(ledPin2, ledPos);
          arduino.digitalWrite(ledPin3, ledPos);
        }
        println("box opened");
        println("fan pos: "+fanPos);
        delay(20000);
        if (pos != 0) {
          pos = 0;
          fanPos = 0;
          ledPos = 0;
          arduino.analogWrite(fanPin, fanPos);
          arduino.digitalWrite(ledPin, ledPos);
          arduino.digitalWrite(ledPin1, ledPos);
          arduino.digitalWrite(ledPin2, ledPos);
          arduino.digitalWrite(ledPin3, ledPos);
          println("box closed");
          println("fan pos now: " +fanPos);
        }
      }
    }
  }
  
}


