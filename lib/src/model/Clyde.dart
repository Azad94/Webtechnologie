part of pacmanLib;

class Clyde extends Ghost {
  Clyde(int x, int y, bool collPlayer, bool collGhost, Level l) : super(x, y, collPlayer, collGhost, l);

  int _doorTargetX = 14;
  int _doorTargetY = 8;
  // 13/4   1/10    13/12   6/1   6/4   13/1    1/1   1/6
  int _firsttargetX = 1;
  int _firsttargetY = 6;

  int _secondTargetX = 20;
  int _secondTargetY = 10;

  int _targetX = 14;
  int _targetY = 8;

  int _thirdX=27;
  int _thirdY=10;

  int _fourthX=27;
  int _fourthY=12;

  int _fifthX=24;
  int _fifthY=12;

  int pacmanPositionX;
  int pacmanPositionY;

  bool outOfDoor = false;
  int _possiblieDirections = 0;

  int _directionsChanged = 0;

  var p = new Random();


  void move() {

    if(outOfDoor == false)
    {
      _targetX = _doorTargetX;
      _targetY = _doorTargetY;
    }


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
      if(outOfDoor == false)outOfDoor = true;
      _directionsChanged++;
    }

  }

  void eatableMode() {
  }

}
/**  * Wenn i.wann mal die Werte für die Map übergeben werden sind folgende
 * Berechnungen für die Scatter Position einmal notwendig 
 * * für die X-Koordinate  *    (x - x) + 2  *
 * für die Y-Koordinate  *    y - 1  **/
