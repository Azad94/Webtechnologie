part of pacmanLib;

class Clyde extends Ghost {
  Clyde(int x, int y, bool collPlayer, bool collGhost, Level l) : super(x, y, collPlayer, collGhost, l);

  int _doorTargetX = 14;
  int _doorTargetY = 8;

  int _firsttargetX = 20;
  int _firsttargetY = 8;

  int _secondTargetX = 20;
  int _secondTargetY = 10;

  int _targetX;
  int _targetY;

  int _thirdX=27;
  int _thirdY=10;

  int _fourthX=27;
  int _fourthY=12;

  int _fifthX=24;
  int _fifthY=12;

  int _directionsChanged = 0;

  void move() {

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
        _targetX = 24;
        _targetY = 15;
        break;

      case 7:
        _targetX = 21;
        _targetY = 16;
        break;

      case 8:
        _targetX = 7;
        _targetY = 15;
        break;

      case 9:
        _targetX = 4;
        _targetY = 15;
        break;

      case 10:
        _targetX = 4;
        _targetY = 12;
        break;

      case 11:
        _targetX = 1;
        _targetY = 10;
        break;

      case 12:
        _targetX = 8;
        _targetY = 10;
        break;

      case 13:
        _targetX = 8;
        _targetY = 8;
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
      print("POSITION ERREICHT");
      if(_directionsChanged == 13){
        _directionsChanged = 0;
      }
      else
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
