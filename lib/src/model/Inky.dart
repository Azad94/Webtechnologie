part of pacmanLib;

class Inky extends Ghost{

  Inky(int x, int y, bool collPlayer, bool collGhost, Level l) : super(x,y,collPlayer, collGhost, l);

  int _targetX;
  int _targetY;

  int _doorTargetX = 14;
  int _doorTargetY = 9;

  int _scatterTargetX = 2;
  int _scatterTargetY = 2;

  int _alternativeTargetX = 28;
  int _alternativeTargetY = 17;

  int _directionsChanged = 0;


  void move() {
    if(_x == _targetX && _y == _targetY) _directionsChanged++;

    switch(_directionsChanged)
    {
      case 0:
        _targetX = _doorTargetX;
        _targetY = _doorTargetY;
        break;

      case 1:
        _targetX = _scatterTargetX;
        _targetY = _scatterTargetY;
        break;

      case 2:
        _targetX = _alternativeTargetX;
        _targetY = _alternativeTargetY;
        break;

      case 3:
        _targetX = _doorTargetX;
        _targetY = _doorTargetY;
        _directionsChanged = 0;
        break;
    }

    switch(getNextMove(_x, _y, _targetX, _targetY, this))
    {
      case Directions.UP:
        _level.registerElement(_x, _y, _x, _y--,this);
        _y--;
        break;

      case Directions.DOWN:
        _level.registerElement(_x,_y,_x,_y++,this);
       _y++;
        break;

      case Directions.LEFT:
        _level.registerElement(_x,_y,_x--,_y,this);
        _x--;
        break;

      case Directions.RIGHT:
        _level.registerElement(_x,_y,_x++,_y,this);
        _x++;
        break;

      case Directions.NOTHING:
        _level.registerElement(_x,_y,_x,_y,this);
        break;
    }
  }

  void eatableMode() {
  }
}