part of pacmanLib;

abstract class Ghost extends GameElement {
  /**
   * start position of ghost
   */
  final _x_start, _y_start;

  /**
   * true if ghost is eatable, else false
   */
  bool _eatable = false;

  /**
   * shows if the ghost is moving
   */
  bool _started = false;

  /**
   * score of the ghost
   */
  int _score;
  bool scatter;
  Directions nextDirection;
  Directions _previousDirection = Directions.LEFT;
  int _ghostsEaten = 0;

  /**
   * the time(frames) who long a ghost is in eatable mode
   */
  int _eatTime;

  /**
   * time(frames) when ghost starts moving
   */
  int _startTime;

  /**
   * counter to count frames
   */
  int timeCounter = 0;

  /**
   *
   */
  int modeSwitchCounter = 0;
  /**
   * reference to the level
   */
  Level _level;

  Ghost(int x, int y, bool collPlayer, bool collGhost, Level l, num eatTime, num startTime,
      num score)
      : super(x, y, collPlayer, collGhost),
        this._level = l,
        this._eatTime = eatTime,
        this._startTime = startTime,
        this._x_start = x,
        this._y_start = y,
        this._score = score;

  /**
   * moves a ghost on step
   */
  void move() {
    if(!_started) {
      timeCounter++;
      if(timeCounter == _startTime) {
        timeCounter = 0;
        _started = true;
      }
    }
    // only if eatable mode is on
    if (_eatable) {
      timeCounter++;
      // check if the eatable mode is over
      if (timeCounter == _eatTime) {
        _eatable = false;
        timeCounter = 0;
      }
    }
    modeSwitchCounter++;
  }

  /**
   * enable the eatable mode
   */
  void eatableMode() {
    _eatable = true;
  }

  /**
   * respawn the ghost to start position
   */
  void respwan() {
    _eatable = false;
    _started = false;
    timeCounter = 0;
    _x = _x_start;
    _y = _y_start;
  }

//returns true if the ghosts are in Scatter Mode
  bool isScatterModeOn() {
    return scatter;
  }

  //abhängig davon wieviele Ghosts schon gefressen wurden
  int getScoreValue() {
    _ghostsEaten++;
    return _ghostsEaten;
  }

  //sets the score of the ghosts to zero
  void setGhostScoreToZero() {
    _ghostsEaten = 0;
  }

  int _possibleDirections;
  int _possibleUp;
  int _possibleDown;
  int _possibleLeft;
  int _possibleRight;

  Directions getNextMove(
      int currentX, int currentY, int targetX, int targetY, bool _outOfDoor, GameElement g)
  {
    if (currentX == targetX && currentY == targetY)    {if(g is Blinky)print("ICH 128"); return Directions.NOTHING;}

    int _currentDistanceX = (targetX - currentX).abs();
    int _currentDistanceY = (targetY - currentY).abs();
    int _checkX = currentX;
    int _checkY = currentY;

    _possibleDirections = 0;
    _possibleDirections = 0 ;
    _possibleUp = 0;
    _possibleDown = 0;
    _possibleLeft = 0;
    _possibleRight = 0;

    //if(g is Blinky && currentX == _x_start) _previousDirection = Directions.RIGHT;
   // if(g is Pinky && _outOfDoor == true) _previousDirection = Directions.RIGHT;
  //  if(g is Clyde && _outOfDoor == true) _previousDirection = Directions.RIGHT;

    //preferred direction considering the difference
    Directions
    preferredHorDirection; //= horDifference > 0 ? Directions.LEFT : Directions.RIGHT;
    if ((targetX - --_checkX).abs() < _currentDistanceX) {
      preferredHorDirection = Directions.LEFT;
    } else
      preferredHorDirection = Directions.RIGHT;
    _checkX = currentX;
    Directions
    preferredVerDirection; // = verDifference > 0 ? Directions.UP : Directions.DOWN;
    if ((targetY - --_checkY).abs() < _currentDistanceY) {
      preferredVerDirection = Directions.UP;
    } else
      preferredVerDirection = Directions.DOWN;
    _checkY = currentY;
    //checks if the vertical difference is greater than the horizontal
    bool verticalMoreImportant = _currentDistanceY > _currentDistanceX;

    //sets next preferred direction
    verticalMoreImportant
        ? nextDirection = preferredVerDirection
        : nextDirection = preferredHorDirection;

    //                             UP

    if (!_level.checkCollision(_checkX, --_checkY, this)) {
      if (_previousDirection != Directions.DOWN) {
        _possibleDirections++;
        _possibleUp++;
      }
    }
    _checkY = currentY;

    //                             DOWN
    if (!_level.checkCollision(_checkX, ++_checkY, this)) {
      if (_previousDirection != Directions.UP) {
        _possibleDirections++;
        _possibleDown++;
      }
    }
    _checkY = currentY;

    //                             LEFT
    if (!_level.checkCollision(--_checkX, _checkY, this)) {
      if (_previousDirection != Directions.RIGHT) {
        _possibleDirections++;
        _possibleLeft++;
      }
    }
    _checkX = currentX;

    //                             RIGHT
    if (!_level.checkCollision(++_checkX, _checkY, this)) {
      if (_previousDirection != Directions.LEFT) {
        _possibleDirections++;
        _possibleRight++;
      }
    }
    _checkX = currentX;

    if (_possibleDirections > 1) {
      // go up
      if (_previousDirection != Directions.DOWN && _possibleUp == 1) {
        if (!_level.checkCollision(_checkX, --_checkY, this)) {
          _checkY = currentY;
          if ((targetY - --_checkY).abs() < _currentDistanceY) {
            _previousDirection = Directions.UP;
            return Directions.UP;
          }
        }
        _checkY = currentY;

        if (!_level.checkCollision(--_checkX, _checkY, this)) {
          _checkX = currentX;
          if ((targetX - --_checkX).abs() < _currentDistanceX) {
            _previousDirection = Directions.LEFT;

            return Directions.LEFT;
          }
        }
        _checkX = currentX;

        if (!_level.checkCollision(++_checkX, _checkY, this)) {
          _checkX = currentX;
          if ((targetX - ++_checkX).abs() < _currentDistanceX) {
            _previousDirection = Directions.RIGHT;
             return Directions.RIGHT;
          }
        }
        _checkX = currentX;
      }

      // go down
      if (_previousDirection != Directions.UP && _possibleDown == 1) {
        if (!_level.checkCollision(_checkX, ++_checkY, this)) {
          _checkY = currentY;
          if ((targetY - ++_checkY).abs() < _currentDistanceY) {
            if (_currentDistanceY > _currentDistanceX) {
              _previousDirection = Directions.DOWN;
              return Directions.DOWN;
            }
          }
        }
        _checkY = currentY;

        if (!_level.checkCollision(--_checkX, _checkY, this)) {
          _checkX = currentX;
          if ((targetX - --_checkX).abs() < _currentDistanceX) {
            _previousDirection = Directions.LEFT;
            return Directions.LEFT;
          }
        }
        _checkX = currentX;

        if (!_level.checkCollision(++_checkX, _checkY, this)) {
          _checkX = currentX;
          if ((targetX - ++_checkX).abs() < _currentDistanceX) {
            _previousDirection = Directions.RIGHT;
            return Directions.RIGHT;
          }
        }
        _checkX = currentX;

        if (!_level.checkCollision(_checkX, ++_checkY, this)) {
          _checkY = currentY;
          //if ((targetY - ++_checkY).abs() < _currentDistanceY) {
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
          //}
        }
        _checkY = currentY;
      }

      // go left
      if (_previousDirection != Directions.RIGHT && _possibleLeft == 1) {
        if ((targetX - --_checkX).abs() < _currentDistanceX) {
          if (!_level.checkCollision(--_checkX, _checkY, this)) {
            _checkX = currentX;
            if ((targetX - --_checkX).abs() < _currentDistanceX) {
              //preferredHorDirection = Directions.LEFT;
              _previousDirection = Directions.LEFT;
              return Directions.LEFT;
            }
          }
          _checkX = currentX;

          if (!_level.checkCollision(_checkX, ++_checkY, this)) {
            _checkY = currentY;
            if (_previousDirection != Directions.UP &&
                (targetY - ++_checkY).abs() < _currentDistanceY) {
              _previousDirection = Directions.DOWN;
              return Directions.DOWN;
            }
          }
          _checkY = currentY;

          if (!_level.checkCollision(_checkX, --_checkY, this)) {
            _checkY = currentY;
            if ((targetY - --_checkY).abs() < _currentDistanceY) {
              _previousDirection = Directions.UP;
              return Directions.UP;
            }
          }
          _checkY = currentY;
        }

        // go right
        if (_previousDirection != Directions.LEFT && _possibleRight == 1) {
          if (!_level.checkCollision(++_checkX, _checkY, this)) {
            _checkX = currentX;
            if ((targetX - ++_checkX) < _currentDistanceX) {
              _previousDirection = Directions.RIGHT;
              return Directions.RIGHT;
            }
          }
          _checkX = currentX;

          if (!_level.checkCollision(_checkX, --_checkY, this)) {
            _checkY = currentY;
            if ((targetY - --_checkY).abs() < _currentDistanceY) {
              _previousDirection = Directions.UP;
              return Directions.UP;
            }
          }
          _checkY = currentY;

          if (!_level.checkCollision(_checkX, ++_checkY, this)) {
            _checkY = currentY;
            if ((targetY - ++_checkY).abs() < _currentDistanceY) {
              _previousDirection = Directions.DOWN;
              return Directions.DOWN;
            }
          }
          _checkY = currentY;
        }
      }
    }

    if (verticalMoreImportant) {
      if (_previousDirection == Directions.UP) {
        //LEFT
        if (!_level.checkCollision(--_checkX, _checkY, this)) {
          _checkX = currentX;
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }
        _checkX = currentX;

        //UP
        if (!_level.checkCollision(_checkX, --_checkY, this)) {
          _checkY = currentY;
          _previousDirection = Directions.UP;
          return Directions.UP;
        }
        _checkY = currentY;

        //RIGHT
        if (!_level.checkCollision(++_checkX, _checkY, this)) {
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }

        _checkX = currentX;    print("ICH 369");
        return Directions.NOTHING;
      }

      if (_previousDirection == Directions.DOWN) {
        //DOWN
        if (!_level.checkCollision(_checkX, ++_checkY, this)) {
          _checkY = currentY;
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }
        _checkY = currentY;

        //LEFT
        if (!_level.checkCollision(--_checkX, _checkY, this)) {
          _checkX = currentX;
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }
        _checkX = currentX;

        //RIGHT
        if (!_level.checkCollision(++_checkX, _checkY, this)) {
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }
        _checkX = currentX;    print("ICH 397");
        return Directions.NOTHING;
      }

      // TODO LEFT LINKS
      if (_previousDirection == Directions.LEFT) {
        //UP
        if (!_level.checkCollision(_checkX, --_checkY, this)) {
          _checkY = currentY;
          _previousDirection = Directions.UP;
          return Directions.UP;
        }
        _checkY = currentY;

        //DOWN
        if (!_level.checkCollision(_checkX, ++_checkY, this)) {
          _checkY = currentY;
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }
        _checkY = currentY;

        //LEFT
        if (!_level.checkCollision(--_checkX, _checkY, this)) {
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }
        _checkX = currentX;    print("ICH 427");

        return Directions.NOTHING;
      }

      // TODO RIGHT RECHTS
      if (_previousDirection == Directions.RIGHT) {
        //UP
        if (!_level.checkCollision(_checkX, --_checkY, this)) {
          _checkY = currentY;
          _previousDirection = Directions.UP;
          return Directions.UP;

        }
        _checkY = currentY;

        //DOWN
        if (!_level.checkCollision(_checkX, ++_checkY, this)) {
          _checkY = currentY;
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }
        _checkY = currentY;

        //RIGHT
        if (!_level.checkCollision(++_checkX, _checkY, this)) {
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }
        _checkX = currentX; print("ICH 459");
        return Directions.NOTHING;
      }
    }
    else {

      // TODO LEFT LINKS
      if (_previousDirection == Directions.LEFT) {
        //LEFT
        if (!_level.checkCollision(--_checkX, _checkY, this)) {
          _checkX = currentX;
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }
        _checkX = currentX;

        //UP
        if (!_level.checkCollision(_checkX, --_checkY, this)) {
          _checkY = currentY;
          _previousDirection = Directions.UP;
          return Directions.UP;
        }
        _checkY = currentY;

        //DOWN
        if (!_level.checkCollision(_checkX, ++_checkY, this)) {
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }
        _checkY = currentY;
        print("ICH 488");
        return Directions.NOTHING;
      }

      // TODO RIGHT RECHTS
      if (_previousDirection == Directions.RIGHT) {
        //RIGHT
        if (!_level.checkCollision(++_checkX, _checkY, this)) {
          _checkX = currentX;
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }
        _checkX = currentX;

        //UP
        if (!_level.checkCollision(_checkX, --_checkY, this)) {
          _checkY = currentY;
          _previousDirection = Directions.UP;
          return Directions.UP;
        }
        _checkX = currentX;

        //DOWN
        if (!_level.checkCollision(_checkX, ++_checkY, this)) {
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }
        _checkY = currentY; print("ICH 515");
        return Directions.NOTHING;
      }

      // TODO UP OBEN
      if (_previousDirection == Directions.UP) {
        //LEFT
        if (!_level.checkCollision(--_checkX, _checkY, this)) {
          _checkX = currentX;
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }
        _checkX = currentX;

        //RIGHT
        if (!_level.checkCollision(++_checkX, _checkY, this)) {
          _checkX = currentX;
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }
        _checkX = currentX;

        // UP
        if (!_level.checkCollision(_checkX, --_checkY, this)) {
          _previousDirection = Directions.UP;
          return Directions.UP;
        }
        _checkY = currentY; print("ICH 546");
        return Directions.NOTHING;
      }

      // TODO DOWN UNTEN
      if (_previousDirection == Directions.DOWN) {
        //LEFT
        if (!_level.checkCollision(--_checkX, _checkY, this)) {
          _checkX = currentX;
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }
        _checkX = currentX;

        //RIGHT
        if (!_level.checkCollision(++_checkX, _checkY, this)) {
          _checkX = currentX;
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }
        _checkX = currentX;

        //DOWN
        if (!_level.checkCollision(_checkX, ++_checkY, this)) {
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }
        _checkY = currentY;
        return Directions.NOTHING;
      }
    }
    return Directions.NOTHING;
  }
}