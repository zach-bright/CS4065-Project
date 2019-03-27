# CS4065-Project
Joystick-controlled H4-Writer and "soft keyboard" using Processing.

## Usage
Open the CS4065Project folder in the Processing IDE and run the program.
Alternatively, run the CS4065Project file with the Processing command line tool.

To use different test phrases, edit the phrases.txt file in the config/ folder.

Test data is tab-separated, and are written directly into the CS4065Project folder with
names like ```User-{userId}_cond-{keyboardCondition}-{inputCondition}_{timestamp}.txt```. Labels for each column are provided as well.

To modify the number of practice and test rounds, change the phrase-count.txt file in the config/ folder. **Make sure that there are enough phrases in phrases.txt to fit your changes.**
