part of pacmanLib;

abstract class Ghost extends GameElement {

  double speed = 0.0;
  bool eatable = false;
  bool invisible = true;
  int start = 0;
  int frightenedModeTimer = 0;
  bool scatter;

  //8 X 7 DUMMY MAP
  List<List> _dummyMap =[
                              [00,01,02,03,04,05,06],
                              [10,11,12,13,14,15,16],
                              [20,21,22,23,24,25,26],
                              [30,31,32,33,34,35,36],
                              [40,41,42,43,44,45,46],
                              [50,51,52,53,54,55,56],
                              [60,61,62,63,64,65,66],
                              [70,71,72,73,74,75,76],
                            ];

  Ghost(){  }

  void setEatable(bool eatable){  }

  //intializes the default START and SCATTER POSITIONS
  void initDefaultPosition(_positions, _dummyMap){
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

  void initScatterPosition(_dummyMap){
    //BLINKY SCATTER POSITION
    _dummyMap[6][0] = Statics.SBLINKY;
    //PINKY SCATTER POSITION
    _dummyMap[0][0] = Statics.SPINKY;
    //INKY SCATTER POSITION
    _dummyMap[6][7] = Statics.SINKY;
    //CLYDE SCATTER POSITION
    _dummyMap[0][7] = Statics.SCLYDE;
  }

  void startScatter(){
    scatter = true;
    int _scatterTimer = 7;

    while (_scatterTimer > 0){
      _scatterTimer--;
    }
  }

  void stopScatter(){
    scatter = false;
  }

  List<List> findScatterPosition(_dummyMap){
    List<List> _scatterPosition = [6][7];
    return _scatterPosition;
  }

  List<List> getCurrentPosition(){
    List<List> _currentPosition = [3][5];
    return _currentPosition;
  }

  void setWalls(_dummyMap){
    _dummyMap[4][5] = Statics.WALL;
    _dummyMap[5][5] = Statics.WALL;
    _dummyMap[4][6] = Statics.WALL;
    _dummyMap[5][6] = Statics.WALL;
  }

  int currentX(int x){return x = 3;}
  int currentY(int y){return y = 5;}

  int targetX(int x){return x = 6;}
  int targetY(int y){return y = 7;}

  void startGhost(){

  }

  Directions nextDirection;
  Directions _previousDirection = Directions.LEFT;

  void tryMove(currentX, currentY, targetX, targetY){
    //horizontal difference from currentPosition to targetPosition
    int horDifference = currentX-targetX;
    int verDifference = currentY-targetY;

    //prefered direction considering the difference     UP-> LEFT-> DOWN
    Directions prefferedHorDirection = horDifference > 0 ? Directions.LEFT : Directions.RIGHT;
    Directions prefferedVerDirection = verDifference > 0 ? Directions.UP : Directions.DOWN;

    //checks if the vertical difference is greater than the horizontal
    bool verticalMoreImportant = verDifference.abs() > horDifference.abs();

    //sets next preferred direction
    if(verticalMoreImportant) nextDirection = prefferedVerDirection;
    else nextDirection = prefferedHorDirection;

    // MACHT MAN DAS SO BZW SOLLTE MAN ?
    // verticalMoreImportant == true ? nextDirection = prefferedVerDirection : nextDirection = prefferedHorDirection;

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
          nextDirection = prefferedHorDirection;
          if(!isMoveAllowed(nextDirection, currentX, currentY))
          {
            nextDirection = prefferedHorDirection == Directions.LEFT ? Directions.RIGHT : Directions.LEFT;
              if(!isMoveAllowed(nextDirection,currentX,currentY))
                nextDirection = prefferedVerDirection == Directions.UP ? Directions.DOWN : Directions.UP;

          }
        }
      }
      else
      {
        if(_previousDirection == Directions.UP || _previousDirection == Directions.DOWN)
        {
          nextDirection = _previousDirection;
          if(!isMoveAllowed(nextDirection, currentX, currentY))
          {
            nextDirection = nextDirection == Directions.UP ? Directions.DOWN : Directions.UP;
          }
          else
          {
            nextDirection = prefferedVerDirection;
            if(!isMoveAllowed(nextDirection, currentX, currentY))
            {
              nextDirection = prefferedVerDirection == Directions.UP ? Directions.DOWN : Directions.UP;
              if(!isMoveAllowed(nextDirection, currentX, currentY))
                nextDirection = prefferedHorDirection == Directions.LEFT ? Directions.RIGHT : Directions.LEFT;
            }
          }
        }
      }
    }
  }

  //false if move is not allowed
  bool isMoveAllowed(Directions d, int currentX, currentY){

    //Map Measures
    int currentXPos = currentX;
    int currentYPos = currentY;

    if(d == Directions.UP && isCollisionPossible(currentYPos, currentXPos, _dummyMap))return false;
    if(d == Directions.DOWN && isCollisionPossible(currentYPos, currentXPos, _dummyMap))return false;
    if(d == Directions.LEFT && isCollisionPossible(currentYPos, currentXPos, _dummyMap))return false;
    if(d == Directions.RIGHT && isCollisionPossible(currentYPos, currentXPos, _dummyMap))return false;
    return true;
  }

  //true if there is an collision with a WALL
  bool isCollisionPossible(int nextX, int nextY, _dummyMap){
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