part of pacmanLib;

class Inky extends Ghost {
  Inky(int x, int y, bool collPlayer, bool collGhost, Level l, num eatTime,
      num startTime, num score)
      : super(x, y, collPlayer, collGhost, l, eatTime, startTime, score);

  int _doorX = 14;
  int _doorY = 8;

  int _targetX = 14;
  int _targetY = 8;

  int _scatterX = 27;
  int _scatterY = 16;

  int _switchMode = 40;
  bool _scatterModeOn = false;
  bool _scat = true;
  bool _chase = false;
  bool _outOfDoor = false;
  int _scatTimer = 0;
  bool _te = false;

  void move()
  {
    super.move();
    if(_started)
    {
      if(_x == _x_start && _y == _y_start)
      {
        _targetX = _doorX;
        _targetY = _doorY;
        _scat = false;
        _chase = false;
      }

      if(_outOfDoor == true && _scat == false && _chase == false && _scatTimer == 40)
      {
        _scatTimer = 0;
        _chase = false;
        _te = false;
        _targetX = _scatterX;
        _targetY = _scatterY;
      }

      if(_outOfDoor == true && _scat == true && _chase == false && _scatTimer == 15)
      {
        _scat = false;
        _scatTimer = 0;
        _te = true;
      }

      if(_te == true && _scatTimer % 5 == 0)
      {
        _targetX = _level.pacmanX;
        _targetY = _level.pacmanY;
      }

    //  print("INKY ZIEL         X " + _targetX.toString() + " Y: " + _targetY.toString());

      switch (getNextMove(_x, _y, _targetX, _targetY, _outOfDoor, this)) {

        case Directions.UP:
          _level.registerElement(_x, _y, _x, --_y, this);
          break;

        case Directions.DOWN:
        // TODO PROVISORISCH MUSS RAUS
          if (_x == 14 && _y == 8) {
            _level.registerElement(_x, _y, ++_x, _y, this);
            break;
          }
          _level.registerElement(_x, _y, _x, ++_y, this);
          break;

        case Directions.LEFT:
          _level.registerElement(_x, _y, --_x, _y, this);
          break;

        case Directions.RIGHT:
          _level.registerElement(_x, _y, ++_x, _y, this);
          break;

        case Directions.NOTHING:
          _level.registerElement(_x, _y, _x, _y, this);
          break;
      }

      if(_x == _targetX && _y == _targetY)
      {
        if(_x == _doorX && _y == _doorY)
        {
          _outOfDoor = true;
          _scat = true;
          _chase = false;
          changeMode();
        }

        if(_x == _scatterX && _y == _scatterY)
        {
          _scat = false;
          _chase = true;
          changeMode();
        }

        if(_x == _targetX && _y == _targetY)
        {
          _scat = false;
          _chase = true;
         changeMode();
        }
      }
      ++_scatTimer;
    }
  }

  void changeMode()
  {
    if(_scat == true)
    {
      _targetX = _scatterX;
      _targetY = _scatterY;
      _scatTimer = 0;
    }
    else
    {
      _targetX = _level.pacmanX;
      _targetY = _level.pacmanY;
      _scatTimer = 0;
    }
  }
}