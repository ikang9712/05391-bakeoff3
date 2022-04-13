# 05391-bakeoff3

## Scaffold Code
[Download TextEntryScaffold.pde from here.](https://github.com/ikang9712/05391-bakeoff3/tree/main/TextEntryScaffold)
### Setup & Run on Android mode

### Scaffold Summary
<p align="center">
  <img align="center" src="./scaffold_img1.png" width="400" height="400">
</p>

#### Requirements
- Target phrase is given.
  - Target phrase only contains alphabets and space. No punctuation, no numbers. 
- User completes the target phrase


#### User Interaction
<ol>
  <li>A user chooses an alphabet by clicking red and green squares. </li>
  <ol>
    <li>Red square: call the previous alphabet. (If the current alphabet is 'b', after you click the square, it becomes 'a')</li>
    <li>Green square: call the next alphabet. (If the current alphabet is 'b', after you click the square, it becomes 'c')</li>
  </ol>
  <li>A user clicks on the gray square to enter the alphabet.</li>
  <li>After entering all alphabets, a user clicks the next button.</li>
  <ol>
    <li>Then, the next target phrase is given. </li>
  </ol>
</ol>

## Preliminary Ideas
<ol>
  <li><p style="background-color: #235c0f; display:inline">Legal)</p> drag horizontally to change a letter, or symbol(spacebar). </li>
  <li><p style="background-color: #235c0f; display:inline">Legal)</p> drag up to enter currently chosen letter. </li>
  <li><p style="background-color: #235c0f; display:inline">Legal)</p> double tap to enter currently chosen letter. </li>
  <li><p style="background-color: #235c0f; display:inline">Legal)</p> drag down to remove the most recently entered letter from the entered text. </li>
  <li><p style="background-color: #6e2212; display:inline">Not Legal)</p> highlight the entered letter with green(matched) or red(unmatched). </li> 
  
  <li><p style="background-color: #235c0f; display:inline">Legal)</p> Have a full qwerty keyboard, but when the user is hovered over a tiny key, an enlarged version of the key will appear. Similar to the photo below. All keys will have this behavior equally. There could also be an audio "clicking" cue similar to iphone's keyboard's sound effect.
  </br>
  <img src="https://files.slack.com/files-pri/T039USHQRPZ-F03BY00C480/278080881_703835167697928_2143444902946391046_n.png?pub_secret=64ec112138" width="150">
  </li>
  <li><p style="background-color: #235c0f; display:inline">Legal)</p> The same hover-to-enlarge idea as above, but a circular keyboard with letters alphabetically listed along the perimeter (similar to the photo below, but without the 3~4 letter grouping). Hover over a letter on the perimeter to enlarge it, swipe towards the center while it's hovered & enlarged to select it. 
  </br>
  <img src="https://files.slack.com/files-pri/T039USHQRPZ-F03ATK489P1/circular_keyboard.png?pub_secret=2047e3f787" style="width:15%;">
  </li>
  <li><p style="background-color: #6e2212; display:inline">Not Legal)</p> If the user has entered n letters, display the (n+1)th letter of the correct phrase on screen, regardless if the entered n letters are correct or not.</li>
  <li><p style="background-color: #235c0f; display:inline">Legal)</p> A circular dial keyboard. "Turn" (ie click and drag) the dial clockwise to move forward in the alphabet, and vice versa. The currently selected letter is displayed at the center of the dial.</li>
</ol>

## Prototype 1 Implementation
- Features
  - circle-keyboard (Idea 7)
  - Android Deployment
- Refinement
  - Alternative implementation of keyboard: qwerty-keyboard (Idea 6)
  - Rendering issues with Android deployment 

## Prototype 2 Implementation
- Features
  - qwerty-keyboard (Idea 6)
  - (continued.) Android Deployment
- Refinement
  - User testing for choosing better UI between Idea 6 and Idea 7.
  - UI suggestion for next button
  - implementation of the new function, removing the most recent letter of the entered phrase.


## Prototype 3 Implementation (Final)
- Features
  - better next button UI
  - remove function 
  - + optional) UI/UX enhancement for qwerty keyboard
- Rationale
  - tbd
