part of pacmanLib;

class Clyde extends Ghost {
  Clyde(int x, int y, bool collPlayer, bool collGhost, Level l) : super(x, y, collPlayer, collGhost, l);

  int _doorTargetX = 14;
  int _doorTargetY = 8;

  int _firsttargetX = 27;
  int _firsttargetY = 1;

  int _secondTargetX = 1;
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