part of pacmanLib;

class Inky extends Ghost{

  Inky(int x, int y, bool collPlayer, bool collGhost, Level l) : super(x,y,collPlayer, collGhost, l);

  int _currentX = 16;
  int _currentY = 11;

  int _targetX;
  int _targetY;

  int _doorTargetX = 15;
  int _doorTargetY = 9;

  int _scatterTargetX = 2;
  int _scatterTargetY = 2;

  int _alternativeTargetX = 28;
  int _alternativeTargetY = 17;

  int _directionsChanged = 0;


  void move() {

    switch(_directionsChanged)
    {
      case 0:
        _targetX = _doorTargetX;
        _targetY = _doorTargetY;
        if(_targetX == _doorTargetX && _targetY == _targetY) _directionsChanged++;
        break;

      case 1:
        _targetX = _scatterTargetX;
        _targetY = _scatterTargetY;
        if(_targetX == _scatterTargetX && _targetY == _scatterTargetY) _directionsChanged++;
        break;

      case 2:
        _targetX = _alternativeTargetX;
        _targetY = _alternativeTargetY;
        if(_targetX == _alternativeTargetX && _targetY == _alternativeTargetY) _directionsChanged++;
        break;

      case 3:
        if(_targetX == _doorTargetX && _targetY == _targetY) _directionsChanged++;
        _targetX = _doorTargetX;
        _targetY = _doorTargetY;
        _directionsChanged = 0;
        break;
    }

    switch(getNextMove(_currentX, _currentY, _targetX, _targetY, this))
    {
      case Directions.UP:
        _level.registerElement(_currentX,_currentY,_currentX,_currentY-1,this);
        _currentY -= 1;
        break;

      case Directions.DOWN:
        _level.registerElement(_currentX,_currentY,_currentX,_currentY+1,this);
        _currentY += 1;
        break;

      case Directions.LEFT:
        _level.registerElement(_currentX,_currentY,_currentX-1,_currentY,this);
        _currentX -= 1;
        break;

      case Directions.RIGHT:
        _level.registerElement(_currentX,_currentY,_currentX+1,_currentY,this);
        _currentX += 1;
        break;

      case Directions.NOTHING:
        _level.registerElement(_currentX,_currentY,_currentX,_currentY,this);
        _currentY -= 1;
        break;
    }
  }

  void eatableMode() {
  }
}