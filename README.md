## Running the apps

The easiest way to run the apps is to do

  `$ elm reactor`

in the root of this directory, then go to http://localhost:8000
There you will see a list of files.  Click on anything that
ends in "App.elm"

The next easiest way is to use `elm make`. Imitate this example:

  `$ elm make src/crypt/CaesarApp.elm`

This will generate a file `index.html` which contains the app.
Click on it to run the app.  Some browsers don't respond to this.
In that case, open `index.html` from the browser using File > Open File

## Experimenting with code

You can also import code from a module and experiment with it using
`elm repl`.  For example:

   ```
   $ elm repl
   > import CaesarCipher exposing(..)

   > stringToIntList "ABC"
  [0,1,2] : List Int

   > encryptWithCaesar 1 "HELLO"
  "IFMMP" : String
   ```


## Contents of src/

* crypt -- Two apps for playing with encryption
* dice
    - Dice1 -- basic program with randomness -- throw one die
    - Dice2 -- the same as Dice1, but with CSS styling
* People		-- working with records
* Poker	-- working with union types
* basicApp
    - scoreApp1 -- one button, one counter, a record with one field
    - scoreApp2 -- the same as above but with some CSS styling
* svg
    - Svg1  -- draw a circle on a light-colored background
    - Bars -- draw horizontal bars, make a bar graph
    - Bars2  -- same, but use List.map and partial application
    - StatusIndicator -- Stateless components
    - ScoreAppWithIndicator  -- Add status indicators to score app
* RandomNumber  -- simple http request to get random integer
* weatherApp -- all the files for weather App (get weather data for any city)
