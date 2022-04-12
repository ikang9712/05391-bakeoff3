import java.util.Arrays;
import java.util.Collections;
import java.util.Random;

String[] phrases; //contains all of the phrases
int totalTrialNum = 2; //the total number of phrases to be tested - set this low for testing. Might be ~10 for the real bakeoff!
int currTrialNum = 0; // the current trial number (indexes into trials array above)
float startTime = 0; // time starts when the first letter is entered
float finishTime = 0; // records the time of when the final trial ends
float lastTime = 0; //the timestamp of when the last trial was completed
float lettersEnteredTotal = 0; //a running total of the number of letters the user has entered (need this for final WPM computation)
float lettersExpectedTotal = 0; //a running total of the number of letters expected (correct phrases)
float errorsTotal = 0; //a running total of the number of errors (when hitting next)
String currentPhrase = ""; //the current target phrase
String currentTyped = ""; //what the user has typed so far
final int DPIofYourDeviceScreen = 120; //you will need to look up the DPI or PPI of your device to make sure you get the right scale. Or play around with this value.
final float sizeOfInputArea = DPIofYourDeviceScreen*1; //aka, 1.0 inches square!
PImage watch;
PImage finger;

//Variables for my silly implementation. You can delete this:
char currentLetter = 'a';
boolean letterSelected = false;
int currCenterX = 0;
int currCenterY = 0; 

char[] firstRow = {'q', 'w', 'e', 'r', 't', 'y', 'u', 'i', 'o', 'p'};
char[] secondRow = {'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l'};
char[] thirdRow = {'z', 'x', 'c', 'v', 'b', 'n', 'm'};

// offsets from the left ledge of the input area
int firstOffset = 0;
int secondOffset = 5;
int thirdOffset = 18;
int spaceOffset = 9;

// from the center of the screen
int firstY = -20;
int secondY = 0;
int thirdY = 20;
int spaceY = 40;

int keyWidth = 10;
int keyHeight = 14;
int spaceWidth = 100;
int spaceHeight = keyHeight;

int firstSecondGutter = secondY - firstY - keyHeight;
int secondThirdGutter = thirdY - secondY - keyHeight;
int thirdSpaceGutter = spaceY - thirdY - spaceHeight;
int margin = 2;

// for the enlargement pop up
int popWidth = 30;
int popHeight = 36;
int popYOffset = 28;

//You can modify anything in here. This is just a basic implementation.
void setup()
{
  //noCursor();
  watch = loadImage("watchhand3smaller.png");
  //finger = loadImage("pngeggSmaller.png"); //not using this
  phrases = loadStrings("phrases2.txt"); //load the phrase set into memory
  Collections.shuffle(Arrays.asList(phrases), new Random()); //randomize the order of the phrases with no seed
  //Collections.shuffle(Arrays.asList(phrases), new Random(100)); //randomize the order of the phrases with seed 100; same order every time, useful for testing
 
  orientation(LANDSCAPE); //can also be PORTRAIT - sets orientation on android device
  size(800, 800); //Sets the size of the app. You should modify this to your device's native size. Many phones today are 1080 wide by 1920 tall.
  textFont(createFont("Arial", 20)); //set the font to arial 24. Creating fonts is expensive, so make difference sizes once in setup, not draw
  noStroke(); //my code doesn't use any strokes
}

//You can modify anything in here. This is just a basic implementation.
void draw()
{
  background(255); //clear background
  
   //check to see if the user finished. You can't change the score computation.
  if (finishTime!=0)
  {
    fill(0);
    textAlign(CENTER);
    text("Trials complete!",400,200); //output
    text("Total time taken: " + (finishTime - startTime),400,220); //output
    text("Total letters entered: " + lettersEnteredTotal,400,240); //output
    text("Total letters expected: " + lettersExpectedTotal,400,260); //output
    text("Total errors entered: " + errorsTotal,400,280); //output
    float wpm = (lettersEnteredTotal/5.0f)/((finishTime - startTime)/60000f); //FYI - 60K is number of milliseconds in minute
    text("Raw WPM: " + wpm,400,300); //output
    float freebieErrors = lettersExpectedTotal*.05; //no penalty if errors are under 5% of chars
    text("Freebie errors: " + nf(freebieErrors,1,3),400,320); //output
    float penalty = max(errorsTotal-freebieErrors, 0) * .5f;
    text("Penalty: " + penalty,400,340);
    text("WPM w/ penalty: " + (wpm-penalty),400,360); //yes, minus, because higher WPM is better
    return;
  }
  
  drawWatch(); //draw watch background
  fill(100);
  rect(width/2-sizeOfInputArea/2, height/2-sizeOfInputArea/2, sizeOfInputArea, sizeOfInputArea); //input area should be 1" by 1"
  
  // draw qwerty keyboard
  
  pushMatrix();
  translate(width/2+2, height/2);
  int leftLedge = int(-sizeOfInputArea/2);
  textAlign(LEFT, TOP); //https://processing.org/reference/textAlign_.html
  textSize(keyHeight-2);
  // first row
  for(int i = 0; i<firstRow.length; i++) { // qwertyuiop
    fill(255);
    rect(leftLedge + firstOffset + keyWidth*i + margin*i, firstY, keyWidth, keyHeight, 2);
    fill(0);
    text(firstRow[i], leftLedge + firstOffset + keyWidth*i + margin*i+1, firstY-2);
  }
  
  // second row
  for(int i = 0; i<secondRow.length; i++) { // asdfghjkl
    fill(255);
    rect(leftLedge + secondOffset + keyWidth*i + margin*i, secondY, keyWidth, keyHeight, 2);
    fill(0);
    text(secondRow[i], leftLedge + secondOffset + keyWidth*i + margin*i+1, secondY-1);
  }
    
  // third row
  for(int i = 0; i<thirdRow.length; i++) { // zxcvbnm
    fill(255);
    rect(leftLedge + thirdOffset + keyWidth*i + margin*i, thirdY, keyWidth, keyHeight, 2);
    fill(0);
    text(thirdRow[i], leftLedge + thirdOffset + keyWidth*i + margin*i+1, thirdY-1);
  }
  
  // big space bar
  fill(255);
  rect(leftLedge + spaceOffset, spaceY, spaceWidth, spaceHeight, 2);
  fill(0);
  text("space", leftLedge + spaceOffset + 35, spaceY);
  
  
  // draw the enlarged selected character
  if(letterSelected){ 
    
    // draw the pop up box
    fill(50);
    int popX = currCenterX - popWidth/2;
    int popY = currCenterY - popHeight/2 - popYOffset;
    if(popX < leftLedge) { popX = leftLedge; } // move it back in the watch area
    if(popX + popWidth > leftLedge + sizeOfInputArea) { popX = int(leftLedge + sizeOfInputArea - popWidth); }
    rect(popX, popY, popWidth, popHeight, 6);
    
    // little triangle beneath the pop up box
    triangle(popX+5, popY+popHeight, popX+popWidth-5, popY+popHeight, currCenterX, currCenterY);
    
    // draw the enlarged letter
    textSize(30);
    fill(255);
    text(currentLetter, popX+7, popY);
  }
  
  popMatrix();
  textSize(20); // reset text size

  if (startTime==0 & !mousePressed)
  {
    fill(128);
    textAlign(CENTER);
    text("Click to start time!", 280, 150); //display this messsage until the user clicks!
  }

  if (startTime==0 & mousePressed)
  {
    nextTrial(); //start the trials!
  }

  if (startTime!=0)
  {
    //draw very basic next button
    fill(255, 0, 0);
    rect(600, 600, 200, 200); //draw next button
    fill(255);
    text("NEXT > ", 650, 650); //draw next label
    
    //feel free to change the size and position of the target/entered phrases and next button 
    textAlign(LEFT); //align the text left
    fill(128);
    text("Phrase " + (currTrialNum+1) + " of " + totalTrialNum, 70, 50); //draw the trial count
    fill(128);
    text("Target:   " + currentPhrase, 70, 100); //draw the target string
    text("Entered:  " + currentTyped +"|", 70, 140); //draw what the user has entered thus far 
  }
 
 }

//my terrible implementation you can entirely replace
boolean didMouseClick(float x, float y, float w, float h) //simple function to do hit testing
{
  return (mouseX > x && mouseX<x+w && mouseY>y && mouseY<y+h); //check to see if it is in button bounds
}

boolean didMouseHoverMatrix(float x, float y, float w, float h) //simple function to do hit testing
{
  x += width/2+2;
  y += height/2+2;
  return (mouseX > x && mouseX<x+w && mouseY>y && mouseY<y+h); //check to see if it is in button bounds
}

void mouseMoved() {
  pushMatrix();
  translate(width/2+2, height/2);
  
  int leftLedge = int(-sizeOfInputArea/2);

  // check if the mouse clicked on something in the first row
  for(int i = 0; i<firstRow.length; i++) { // qwertyuiop
    if(didMouseHoverMatrix(leftLedge + firstOffset + keyWidth*i + margin*i - margin/2, 
                     firstY-firstSecondGutter/2, 
                     keyWidth+margin, 
                     keyHeight+firstSecondGutter)) {
      currentLetter = firstRow[i];
      letterSelected = true;
      currCenterX = leftLedge + firstOffset + keyWidth*i + margin*i + keyWidth/2;
      currCenterY = firstY + keyHeight/2;
      print(currentLetter);
      popMatrix();
      return;
    }
  }
  
  // check if the mouse clicked on something in the second row
  for(int i = 0; i<secondRow.length; i++) { // asdfghjkl
    if(didMouseHoverMatrix(leftLedge + secondOffset + keyWidth*i + margin*i - margin/2, 
                     secondY-secondThirdGutter/2, 
                     keyWidth+margin, 
                     keyHeight+secondThirdGutter)) {
      currentLetter = secondRow[i];
      letterSelected = true;
      currCenterX = leftLedge + secondOffset + keyWidth*i + margin*i + keyWidth/2;
      currCenterY = secondY + keyHeight/2;
      print(currentLetter);
      popMatrix();
      return;
    }
  }
  
  // check if the mouse clicked on something in the third row
  for(int i = 0; i<thirdRow.length; i++) { // zxcvbnm
    if(didMouseHoverMatrix(leftLedge + thirdOffset + keyWidth*i + margin*i - margin/2, 
                     thirdY-thirdSpaceGutter/2, 
                     keyWidth+margin, 
                     keyHeight+thirdSpaceGutter)) {
      currentLetter = thirdRow[i];
      letterSelected = true;
      currCenterX = leftLedge + thirdOffset + keyWidth*i + margin*i + keyWidth/2;
      currCenterY = thirdY + keyHeight/2;
      print(currentLetter);
      popMatrix();
      return;
    }
  }
  // big space bar
  if(didMouseHoverMatrix(leftLedge, spaceY, sizeOfInputArea, spaceHeight)) {
    currentLetter = ' ';
    letterSelected = true;
    currCenterX = 0;
    currCenterY = spaceY + spaceHeight/2;
    print("[space]");
    popMatrix();
    return;
  }
  
  // didn't recognize any keys being hit
  letterSelected = false;
  popMatrix();
}

//my terrible implementation you can entirely replace
void mousePressed()
{
  if(letterSelected){
    currentTyped+=currentLetter;
  }

  //You are allowed to have a next button outside the 1" area
  if (didMouseClick(600, 600, 200, 200)) //check if click is in next button
  {
    nextTrial(); //if so, advance to next trial
  }
}


void nextTrial()
{
  if (currTrialNum >= totalTrialNum) //check to see if experiment is done
    return; //if so, just return

  if (startTime!=0 && finishTime==0) //in the middle of trials
  {
    System.out.println("==================");
    System.out.println("Phrase " + (currTrialNum+1) + " of " + totalTrialNum); //output
    System.out.println("Target phrase: " + currentPhrase); //output
    System.out.println("Phrase length: " + currentPhrase.length()); //output
    System.out.println("User typed: " + currentTyped); //output
    System.out.println("User typed length: " + currentTyped.length()); //output
    System.out.println("Number of errors: " + computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim())); //trim whitespace and compute errors
    System.out.println("Time taken on this trial: " + (millis()-lastTime)); //output
    System.out.println("Time taken since beginning: " + (millis()-startTime)); //output
    System.out.println("==================");
    lettersExpectedTotal+=currentPhrase.trim().length();
    lettersEnteredTotal+=currentTyped.trim().length();
    errorsTotal+=computeLevenshteinDistance(currentTyped.trim(), currentPhrase.trim());
  }

  //probably shouldn't need to modify any of this output / penalty code.
  if (currTrialNum == totalTrialNum-1) //check to see if experiment just finished
  {
    finishTime = millis();
    System.out.println("==================");
    System.out.println("Trials complete!"); //output
    System.out.println("Total time taken: " + (finishTime - startTime)); //output
    System.out.println("Total letters entered: " + lettersEnteredTotal); //output
    System.out.println("Total letters expected: " + lettersExpectedTotal); //output
    System.out.println("Total errors entered: " + errorsTotal); //output

    float wpm = (lettersEnteredTotal/5.0f)/((finishTime - startTime)/60000f); //FYI - 60K is number of milliseconds in minute
    float freebieErrors = lettersExpectedTotal*.05; //no penalty if errors are under 5% of chars
    float penalty = max(errorsTotal-freebieErrors, 0) * .5f;
    
    System.out.println("Raw WPM: " + wpm); //output
    System.out.println("Freebie errors: " + freebieErrors); //output
    System.out.println("Penalty: " + penalty);
    System.out.println("WPM w/ penalty: " + (wpm-penalty)); //yes, minus, becuase higher WPM is better
    System.out.println("==================");

    currTrialNum++; //increment by one so this mesage only appears once when all trials are done
    return;
  }

  if (startTime==0) //first trial starting now
  {
    System.out.println("Trials beginning! Starting timer..."); //output we're done
    startTime = millis(); //start the timer!
  } 
  else
    currTrialNum++; //increment trial number

  lastTime = millis(); //record the time of when this trial ended
  currentTyped = ""; //clear what is currently typed preparing for next trial
  currentPhrase = phrases[currTrialNum]; // load the next phrase!
  //currentPhrase = "abc"; // uncomment this to override the test phrase (useful for debugging)
}

//probably shouldn't touch this - should be same for all teams.
void drawWatch()
{
  float watchscale = DPIofYourDeviceScreen/138.0; //normalizes the image size
  pushMatrix();
  translate(width/2, height/2);
  scale(watchscale);
  imageMode(CENTER);
  image(watch, 0, 0);
  popMatrix();
}

//probably shouldn't touch this - should be same for all teams.
void drawFinger()
{
  float fingerscale = DPIofYourDeviceScreen/150f; //normalizes the image size
  pushMatrix();
  translate(mouseX, mouseY);
  scale(fingerscale);
  imageMode(CENTER);
  image(finger,52,341);
  if (mousePressed)
     fill(0);
  else
     fill(255);
  ellipse(0,0,5,5);

  popMatrix();
  }
  

//=========SHOULD NOT NEED TO TOUCH THIS METHOD AT ALL!==============
int computeLevenshteinDistance(String phrase1, String phrase2) //this computers error between two strings
{
  int[][] distance = new int[phrase1.length() + 1][phrase2.length() + 1];

  for (int i = 0; i <= phrase1.length(); i++)
    distance[i][0] = i;
  for (int j = 1; j <= phrase2.length(); j++)
    distance[0][j] = j;

  for (int i = 1; i <= phrase1.length(); i++)
    for (int j = 1; j <= phrase2.length(); j++)
      distance[i][j] = min(min(distance[i - 1][j] + 1, distance[i][j - 1] + 1), distance[i - 1][j - 1] + ((phrase1.charAt(i - 1) == phrase2.charAt(j - 1)) ? 0 : 1));

  return distance[phrase1.length()][phrase2.length()];
}
