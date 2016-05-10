part of pacmanLib;

abstract class Ghost extends GameElement {

  double speed = 0.0;
  bool eatable = false;
  bool invisible = true;
  int start = 0;
  int frightenedModeTimer = 0;
  bool scatter;
  final int chaseMode = 200;
  final int scatterMode = 50;
  int countDownTimer;
  Directions nextDirection;
  Directions _previousDirection = Directions.LEFT;
  Directions _savePreviousDirection;
  int _ghostsEaten = 0;

  //8 X 7 DUMMY MAP
  List<List> _dummyMap =[
                              [00,10,20,30,40,50,60],//00
                              [01,11,21,31,41,51,61],
                              [02,12,22,32,42,52,62],
                              [03,13,23,33,43,53,63],
                              [04,14,24,34,44,54,64],//24
                              [05,15,25,35,45,55,65],
                              [06,16,26,36,46,56,66],
                              [07,17,27,37,74,57,67],
                            ];


  //intializes the default START and SCATTER POSITIONS
  void initDefaultPosition(_positions, _dummyMap)
  {
    //erst Spalte dann Zeile, das sind auf einem 8x6 Feld die passenden Positionen

    //BLINKY Start Position
    _dummyMap[4][4] = Dynamics.BLINKY;
    //PINKY Start Position
    _dummyMap[4][5] = Dynamics.PINKY;
    //INKY Start Position
    _dummyMap[3][5] = Dynamics.INKY;
    //CLYDE Start Position
    _dummyMap[5][5] = Dynamics.CLYDE;
  }

  void initScatterPosition(_dummyMap)
  {
    //BLINKY SCATTER POSITION
    _dummyMap[6][0] = Statics.SBLINKY;
    //PINKY SCATTER POSITION
    _dummyMap[0][0] = Statics.SPINKY;
    //INKY SCATTER POSITION
    _dummyMap[6][7] = Statics.SINKY;
    //CLYDE SCATTER POSITION
    _dummyMap[0][7] = Statics.SCLYDE;
  }

  List<List> findScatterPosition(_dummyMap)
  {
    List<List> _scatterPosition = [6][7];
    return _scatterPosition;
  }

  List<List> getCurrentPosition()
  {
    List<List> _currentPosition = [3][5];
    return _currentPosition;
  }

  void setWalls(_dummyMap)
  {
    _dummyMap[4][5] = Statics.WALL;
    _dummyMap[5][5] = Statics.WALL;
    _dummyMap[4][6] = Statics.WALL;
    _dummyMap[5][6] = Statics.WALL;
  }

  /**
   * if the ghosts are eatable, return value is set to false
   * if the ghosts are not eatable, return value is set to true
   **/
  void setEatable()
  {
    eatable ? eatable = true : eatable = false;
  }

  //return's true if the ghosts are eatable else false
  bool isEatable()
  {
    return eatable;
  }

  /**
  void setDirection(Directions dir)
  {
    _previousDirection = nextDirection;
    nextDirection = dir;
  }
  **/

  //returns true if the ghosts are in Scatter Mode
  bool isScatterModeOn()
  {
    return scatter;
  }

  void startScatterMode()
  {
    //TODO muss noch implementiert werden, Logik fehlt noch, muss ich mir noch überlegen
    scatter = true;
    int _scatterTimer = 7;

    while (_scatterTimer > 0)
    {
      _scatterTimer--;
    }
  }

  void stopScatter()
  {
    //TODO muss noch implementiert werden, Logik fehlt noch, muss ich mir noch überlegen
    scatter = false;

  }

  //as param give the ghost to be respawned
  void respawn(Dynamics ghost){
    //TODO muss noch geklärt werden auf wessen seite das passiert auf meiner oder der von niklas
  }

  //abhängig davon wieviele Ghosts schon gefressen wurden
  int getScoreValue()
  {
    _ghostsEaten++;
    return _ghostsEaten;
  }

  //sets the score of the ghosts to zero
  void setGhostScoreToZero()
  {
   _ghostsEaten = 0;
  }

  int getDoorX()
  {
    int x = 3;
    return x;
  }

  int getDoorY()
  {
    int y = 4;
    return y;
  }

  //TODO seeehr großer Fehler, der noch behoben werden muss
  bool tryMove(currentX, currentY, targetX, targetY){
    //horizontal difference from currentPosition to targetPosition
    int horDifference = currentX-targetX;
    int verDifference = currentY-targetY;

    //preferred direction considering the difference     UP-> LEFT-> DOWN
    Directions preferredHorDirection = horDifference > 0 ? Directions.LEFT : Directions.RIGHT;
    Directions preferredVerDirection = verDifference > 0 ? Directions.UP : Directions.DOWN;

    //checks if the vertical difference is greater than the horizontal
    bool verticalMoreImportant = verDifference.abs() > horDifference.abs();

    //sets next preferred direction
    verticalMoreImportant ? nextDirection = preferredVerDirection : nextDirection = preferredHorDirection;

    if(!isMoveAllowed(nextDirection, currentX, currentY))
    {
      if(verticalMoreImportant)
      {
        if(_previousDirection == Directions.LEFT || _previousDirection == Directions.RIGHT)
        {
          nextDirection = _previousDirection;
          if (!isMoveAllowed(nextDirection, currentX, currentY))
            nextDirection = nextDirection == Directions.LEFT ? Directions.RIGHT : Directions.LEFT;
        }
        else
        {
          nextDirection = preferredHorDirection;
          if(!isMoveAllowed(nextDirection, currentX, currentY))
          {
            nextDirection = preferredHorDirection == Directions.LEFT ? Directions.RIGHT : Directions.LEFT;
              if(!isMoveAllowed(nextDirection,currentX,currentY))
                nextDirection = preferredVerDirection == Directions.UP ? Directions.DOWN : Directions.UP;
          }
        }
      }
      /// ELSE ZWEIG BEGINN
      else
      { //if the next and previous Direction are same nothing changes
        if(_previousDirection == Directions.LEFT || _previousDirection == Directions.RIGHT) {

          _savePreviousDirection = _previousDirection;

          //if they are different, try going UP first
          nextDirection == _previousDirection ? nextDirection : nextDirection = Directions.UP;
          if (!isMoveAllowed(nextDirection, currentX, currentY)) return true;

          //if UP is not allowed try going LEFT
          //if LEFT is not allowed try going DOWN
          //nextDirection == Directions.UP ? nextDirection = Directions.LEFT : nextDirection = Directions.DOWN;
          if (nextDirection == Directions.UP) {
            if(_savePreviousDirection == Directions.LEFT)
            {
              nextDirection = Directions.DOWN;
              if (!isMoveAllowed(nextDirection, currentX, currentY)) return true;

              if (nextDirection == Directions.DOWN && preferredHorDirection == Directions.RIGHT)
              {
                nextDirection = Directions.RIGHT;
                if (!isMoveAllowed(nextDirection, currentX, currentY)) return true;
                else
                {
                 nextDirection = Directions.LEFT;
                  if(!isMoveAllowed(nextDirection, currentX, currentY)) return true;
                  return false;
                }
              }
              else
              {
                nextDirection = Directions.LEFT;
                if (!isMoveAllowed(nextDirection, currentX, currentY)) return true;
                return false;
              }
            }
            else
            {
              //TODO kann raus nach dem preferredHor = LEFT testfälle durchgeführt wurden
              if (_savePreviousDirection == Directions.LEFT && nextDirection == Directions.DOWN)
                  nextDirection = Directions.RIGHT;

              if(_savePreviousDirection == Directions.LEFT && preferredHorDirection == Directions.LEFT)
              {
                nextDirection = Directions.LEFT;
                if (!isMoveAllowed(nextDirection, currentX, currentY)) return true;

                nextDirection = Directions.DOWN;
                if (!isMoveAllowed(nextDirection, currentX, currentY)) return true;
              }

              if(_savePreviousDirection == Directions.RIGHT && preferredHorDirection == Directions.LEFT)
              {
                nextDirection = Directions.DOWN;
                if (!isMoveAllowed(nextDirection, currentX, currentY)) return true;

                nextDirection = Directions.RIGHT;
                if (!isMoveAllowed(nextDirection, currentX, currentY)) return true;

                return false;
              }

              //TODO kann raus nach dem preferredHor = LEFT testfälle durchgeführt wurden
              if (!isMoveAllowed(nextDirection, currentX, currentY)) return true;

              //TODO is this return still needed, i mean there is no possibility where you can get stucked
              return false;
            }
          }

          //if RIGHT is not allowed try going UP
          if(nextDirection == Directions.RIGHT && _savePreviousDirection == Directions.RIGHT && preferredHorDirection == Directions.RIGHT)
          {
            nextDirection = Directions.UP;
            if(!isMoveAllowed(nextDirection, currentX,currentY)) return true;

            //if UP not allowed try going DOWN
            nextDirection = Directions.DOWN;
            if(!isMoveAllowed(nextDirection, currentX, currentY)) return true;

            //if UP not allowed try going LEFT
            nextDirection = Directions.LEFT;
            if(!isMoveAllowed(nextDirection, currentX, currentY)) return true;

            //no way to go, !trapped!
            //TODO is this return still needed, i mean there is no possibility where you can get stucked
            return false;
          }

          //if going LEFT ist not allowed try going DOWN
          nextDirection == Directions.LEFT ? nextDirection = Directions.DOWN : Directions.UP;
          if(!isMoveAllowed(nextDirection, currentX,currentY)) return true;

          //if(nextDirection == Directions.DOWN && _savePreviousDirection == Directions.)
          //if going DOWN is not allowed try going UP
          if(nextDirection == Directions.DOWN) nextDirection = Directions.UP;
          if(!isMoveAllowed(nextDirection, currentX,currentY)) return true;

          //TODO is this return still needed, i mean there is no possibility where you can get stucked
          return false;
        }
      }
    }
    return false;
  }

  /**
   * checks is there is any collision with a wall
   * returns false if move is not allowed else true
   * */
  bool isMoveAllowed(Directions d, int currentX, currentY)
  {
    //Map Measures
    int currentXPos = currentX;
    int currentYPos = currentY;

    if(d == Directions.UP && isCollisionPossible(currentYPos, currentXPos, _dummyMap))    return false;
    if(d == Directions.DOWN && isCollisionPossible(currentYPos, currentXPos, _dummyMap))  return false;
    if(d == Directions.LEFT && isCollisionPossible(currentYPos, currentXPos, _dummyMap))  return false;
    if(d == Directions.RIGHT && isCollisionPossible(currentYPos, currentXPos, _dummyMap)) return false;
    return true;
  }

  //true if there is an collision with a WALL
  bool isCollisionPossible(int nextX, int nextY, _dummyMap)
  {
    if (_dummyMap[nextY][nextX] == Statics.WALL) return true;
    return false;
  }
}

/**
 * kollisionsabfrage, returnToHome, ScatterMode, Frightened Mode
 * alles in die Ghost kommen und die Geister selben haben nur ihre
 * individuelle Chase/Verfolger Methode und je nach Geist komplex
 *
 * UP -> LEFT -> DOWN
**/