part of pacmanLib;

class Clyde extends Ghost {
  Clyde(int x, int y, bool collPlayer, bool collGhost, Level l, num eatTime,
      num startTime, num score)
      : super(
      x,
      y,
      collPlayer,
      collGhost,
      l,
      eatTime,
      startTime,
      score);

  int _doorX = 14;
  int _doorY = 8;

  int _targetX = 14;
  int _targetY = 8;

  int _scatterX = 1;
  int _scatterY = 16;

  int _switchMode = 40;
  bool _scatterModeOn = false;
  bool _scat = true;
  bool _chase = false;
  bool _outOfDoor = false;
  int _scatTimer = 0;
  bool _te = false;

  void move() {
    super.move();
    if (_started) {
      if (_x == _x_start && _y == _y_start) {
        _targetX = _doorX;
        _targetY = _doorY;
        _scat = false;
        _chase = false;
      }

      if (_outOfDoor == true && _scat == false && _chase == false &&
          _scatTimer == 40) {
        _scatTimer = 0;
        _chase = false;
        _te = false;
        _targetX = _scatterX;
        _targetY = _scatterY;
      }

      if (_outOfDoor == true && _scat == true && _chase == false &&
          _scatTimer == 15) {
        _scat = false;
        _scatTimer = 0;
        _te = true;
      }

      if (_te == true && _scatTimer % 5 == 0) {
        _targetX = _level.pacmanX;
        _targetY = _level.pacmanY;
      }

    //  print("INKY ZIEL         X " + _targetX.toString() + " Y: " +
    //      _targetY.toString());

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

      if (_x == _targetX && _y == _targetY) {
        if (_x == _doorX && _y == _doorY) {
          _outOfDoor = true;
          _scat = true;
          _chase = false;
          changeMode();
        }

        if (_x == _scatterX && _y == _scatterY) {
          _scat = false;
          _chase = true;
          changeMode();
        }

        if (_x == _targetX && _y == _targetY) {
          _scat = false;
          _chase = true;
          changeMode();
        }
      }
      ++_scatTimer;
    }
  }

  void changeMode() {
    if (_scat == true) {
      _targetX = _scatterX;
      _targetY = _scatterY;
      _scatTimer = 0;
    }
    else {
      _targetX = _level.pacmanX;
      _targetY = _level.pacmanY;
      _scatTimer = 0;
    }
  }
}




















/**
  int _doorX = 14;
  int _doorY = 8;

  int _targetX = 14;
  int _targetY = 8;

  int _scatterX = 27;
  int _scatterY = 16;

  int _switchMode = 40;
  bool _scatterModeOn = false;

  void move()
  {
    super.move();
    if(_started) {
      if (_x == _x_start && _y == _y_start) {
        _scatterModeOn = false;
        _targetX = _doorX;
        _targetY = _doorY;
      }

      if ((modeSwitchCounter % 40) == 0) {
    //      print("CHANGE TO SCATTER");
        _scatterModeOn = true;
        _switchMode = 15;
        changeMode();
      }

      if (_switchMode == 0) {
        _scatterModeOn = false;
    //      print("CHANGE TO CHASE");
        changeMode();
      }

      switch (getNextMove(_x, _y, _targetX, _targetY, this)) {
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

      if (_x == _targetX && _y == _targetY) {
        if (_x == _doorX && _y == _doorY && !_scatterModeOn) {
          _scatterModeOn = true;
          _switchMode = 15;
          changeMode();
        }
        if (_x == _scatterX && _y == _scatterY && _scatterModeOn) {
          _scatterModeOn = false;
          _switchMode = 41;
          changeMode();
        }

        if  (_x == _targetX && _y == _targetY && !_scatterModeOn) {
          _scatterModeOn = false;
          _switchMode = 41;
          changeMode();
        }
      }
      --_switchMode;
  }
    //print("ZIEL         X " + _targetX.toString() + " Y: " + _targetY.toString());
    //  print("AKTUELLE POS X " + _x.toString() +  " Y " + _y.toString());
    // print("DOOR     POS X " + _doorX.toString() +  " Y " + _doorY.toString());
  }

  void changeMode()
  {
   // print("---------SWITCH-------------");
    if(_scatterModeOn)
    {
//      print("SCATTER MODE IS ON");
      _targetX = _scatterX;
      _targetY = _scatterY;
    }
    else
    {
//      print("SCATTER MODE IS OFF");
      _targetX = _level.pacmanX;
      _targetY = _level.pacmanY;
    }
  }
}

  **/







  /**

  int _doorTargetX = 14;
  int _doorTargetY = 8;

  int _firsttargetX = 27;
  int _firsttargetY = 1;

  int _secondTargetX = 1;
  int _secondTargetY = 16;

  int _targetX;
  int _targetY;

  bool outOfDoor = true;
  int _targetsReached = 0;

  bool _scatterMode = true;
  int _scatterduration = 0;

  @override
  void move() {
    super.move();

    print("MOVE");
    if(_started) {

      if (outOfDoor == true && _x == _x_start && _y == _y_start) {
        outOfDoor = false;
        //_targetsReached = 0;
        _targetX = _doorTargetX;
        _targetY = _doorTargetY;
      }

      if(modeSwitchCounter % 15 == 0) {
        _scatterMode = true;
        _scatterduration = 5;
        changeMode();
      }

      if(_scatterduration == 0)
      {
        _scatterMode = true;
        _scatterduration = 0;
        changeMode();
      }

      /**  switch (_targetsReached) {
          case 0:
            _targetX = _doorTargetX;
            _targetY = _doorTargetY;
            break;

          case 1:
            _targetX = _level.pacmanX;
            _targetY = _level.pacmanY;
            break;
        /**
            case 2:
            _targetX = _secondTargetX;
            _targetY = _secondTargetY;
            break;
         **/
          default:
            _targetX = _x;
            _targetY = _y;
        }
       **/
        switch (getNextMove(_x, _y, _targetX, _targetY, this)) {

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
            print("GET NEXT MOVE");
            _level.registerElement(_x, _y, _x, _y, this);
            break;
        }

        if (_x == _doorTargetX && _y == _doorTargetY) {
          if (outOfDoor == false)
            outOfDoor = true;
        }

      --_scatterduration;
      }

      print("X " + _targetX.toString() + " Y " + _targetY.toString());
    }

  void changeMode()
  {
    print("CHANGE MODE");
    if(_scatterMode)
    {
      _targetX = 1;
      _targetY = 16;
    }
    else
    {
      _targetX = _level.pacmanX;
      _targetY = _level.pacmanY;
    }
  }
}
      **/