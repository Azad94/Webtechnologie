part of pacmanLib;

class Inky extends Ghost{

  Inky(int x, int y, bool collPlayer, bool collGhost, Level l, num eatTime, num score) : super(x,y,collPlayer, collGhost, l, eatTime, score);


  int _doorTargetX = 14;
  int _doorTargetY = 8;

  int _firsttargetX = 1;
  int _firsttargetY = 1;

  int _secondTargetX = 27;
  int _secondTargetY = 16;

  int _targetX;
  int _targetY;

  bool outOfDoor = false;
  int _targetsReached = 8;

  void move() {

    if(outOfDoor == false)
    {
      _targetX = _doorTargetX;
      _targetY = _doorTargetY;
    }


    switch(_targetsReached)
    {
      case 0:
        _targetX = _doorTargetX;
        _targetY = _doorTargetY;
        break;

      case 1:
        _targetX = _firsttargetX;
        _targetY = _firsttargetY;
        break;

      case 2:
        _targetX = _secondTargetX;
        _targetY = _secondTargetY;
        break;

      default:
        _targetX = _x;
        _targetY = _y;
    }

    switch(getNextMove(_x, _y, _targetX, _targetY, this))
    {
      case Directions.UP:
        _level.registerElement(_x, _y, _x, --_y,this);
        break;

      case Directions.DOWN:
      // TODO PROVISORISCH MUSS RAUS
        if(_x == 14 && _y == 8)
        {
          _level.registerElement(_x, _y, ++_x, _y, this);
          break;
        }
        _level.registerElement(_x, _y, _x, ++_y, this);
        break;

      case Directions.LEFT:
        _level.registerElement(_x,_y,--_x,_y,this);
        break;

      case Directions.RIGHT:
        _level.registerElement(_x,_y,++_x,_y,this);
        break;

      case Directions.NOTHING:
        _level.registerElement(_x,_y,_x,_y,this);
        break;
    }


    if(_x == _targetX && _y == _targetY)
    {
      if(outOfDoor == false)outOfDoor = true;
      _targetsReached++;
    }
  }

  void eatableMode() {
  }
}

  /**
  int _doorTargetX = 14;
  int _doorTargetY = 8;

  int _firsttargetX = 12;
  int _firsttargetY = 6;

  int _secondTargetX = 8;
  int _secondTargetY = 6;

  int _targetX;
  int _targetY;

  int _thirdX=7;
  int _thirdY=4;

  int _fourthX=1;
  int _fourthY=4;

  int _fifthX=1;
  int _fifthY=1;

  int _directionsChanged = 0;

  @override
  void move() {
    super.move();
    switch(_directionsChanged)
    {
      case 0:
        _targetX = _doorTargetX;
        _targetY = _doorTargetY;
        break;

      case 1:
        _targetX = _firsttargetX;
        _targetY = _firsttargetY;
        break;

      case 2:
        _targetX = _secondTargetX;
        _targetY = _secondTargetY;
        break;

      case 3:
        _targetX = _thirdX;
        _targetY = _thirdY;
        break;

      case 4:
        _targetX = _fourthX;
        _targetY = _fourthY;
        break;

      case 5:
        _targetX = _fifthX;
        _targetY = _fifthY;
        break;

      case 6:
        _targetX = 13;
        _targetY = 1;
        break;

      case 7:
        _targetX = 13;
        _targetY = 4;
        break;

      case 8:
        _targetX = 22;
        _targetY = 4;
        break;

      case 9:
        _targetX = 22;
        _targetY = 1;
        break;

      case 10:
        _targetX = 27;
        _targetY = 1;
        break;

      case 11:
        _targetX = 27;
        _targetY = 6;
        break;

      case 12:
        _targetX = 22;
        _targetY = 7;
        break;

      case 13:
        _targetX = 21;
        _targetY = 10;
        break;

      case 14:
        _targetX = 20;
        _targetY = 10;
        break;

      case 15:
        _targetX = 20;
        _targetY = 8;
        break;
    }

    switch(getNextMove(_x, _y, _targetX, _targetY, this))
    {
      case Directions.UP:
        _level.registerElement(_x, _y, _x, --_y,this);
        break;

      case Directions.DOWN:
        _level.registerElement(_x,_y,_x,++_y,this);
        break;

      case Directions.LEFT:
        _level.registerElement(_x,_y,--_x,_y,this);
        break;

      case Directions.RIGHT:
        _level.registerElement(_x,_y,++_x,_y,this);
        break;

      case Directions.NOTHING:
        _level.registerElement(_x,_y,_x,_y,this);
        break;
    }


    if(_x == _targetX && _y == _targetY)
    {
    // print("POSITION ERREICHT");
     if(_directionsChanged == 15){
      _directionsChanged = 0;
     }
     else
      _directionsChanged++;
    }

  }
}
      **/