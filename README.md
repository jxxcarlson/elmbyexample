## Elm by Example

*Elm by Example* is a book project -- still in a very preliminary
and rough stage.  I hope to have a complete draft by July 1, 2018.
The draft, such as it is, can be found at

    http://www.knode.io/#@public/480

The code files below are examples from the book.
I do appreciate comments, corrections, and suggestions:

    jxxcarlson at gmail

-- Jim

## Contents of src/

Lower case names are folders, upper case names are modules.

* basicApp
    - scoreApp1App -- one button, one counter, a record with one field
    - scoreApp2App -- the same as above but with some CSS styling
* billiards -- a simulation of billiard balls bouncing around in
  rectangular container.
* crypt -- Two apps for playing with encryption
    - CaesarApp
    - VigenereApp
* dataVisualization -- grab data from server and visualize
    it using Elm.  See Readme
* dice
    - Dice1App -- basic program with randomness -- throw one die
    - Dice2App -- the same as Dice1, but with CSS styling
* modules -- for learning Elm, the language
    - People -- working with records
    - MaybePeople -- segue into the Maybe Type
    - Poker	-- working with union types
* physics101 -- this has moved to https://github.com/jxxcarlson/particle
* random: RandomNumberApp  -- simple http request to get random integer
* svg
    - Svg1App  -- draw a circle on a light-colored background
    - BarsApp -- draw horizontal bars, make a bar graph
    - Bars2App  -- same, but use List.map and partial application
    - StatusIndicatorApp -- Stateless components
    - ScoreAppWithIndicatorApp  -- Add status indicators to score app
* weatherApp -- all the files for weather App (get weather data for any city)


## Running the apps

The easiest way to run the apps is to do

  `$ elm reactor`

in the root of this directory, then go to http://localhost:8000
There you will see a list of files.  Click on anything that
is an app.  If the file name ends in "App.elm," it is definitely
an app.  But files may define apps without being named this way.

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
