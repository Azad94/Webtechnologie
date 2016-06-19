part of pacmanModelLib;

/**
 * AI for the Ghost BLINKY
 * he pursuits Pac-Man with no mercy and tries to get to him in
 * the chase mode asap, his time of scattering is compared to
 * the other ghosts very short and therefore he is the most
 * persistent ghost of them all, he leaves the gate at first
 */
class Blinky extends Ghost {
  Blinky(int startx, int starty, bool collPlayer, bool collGhost, Level l, num eatTime,
      num startTime, num score)
      : super( startx, starty, collPlayer, collGhost, l, eatTime, startTime, score);

  int _scatterX = 27;
  int _scatterY = 1;




  /**
   * Moves Blinky one step further
   */
  void move() {
    super.move();

    _chasingTimer = 40;
    _scatteringTimer = 15;
    update = 1;

    //checks if Blinky is allowed to move yet
    if (_started) {
      //if Blinky is at his origin position his first target is to get out of the Door
      if (_x == _start_x && _y == _start_y) {
        _targetX = doorX;
        _targetY = doorY;
        _isScattering = false;
        _isChasing = false;
        _previousDirections = Directions.RIGHT;
      }

      //change to scatter mode after chasing time is up
      if (_changeModeTimer > _chasingTimer && !_isScattering && _isChasing) {
        _isScattering = true;
        changeMode();
      }

      //change to chase mode after scatter mode is up
      if (_changeModeTimer > _scatteringTimer && _isScattering && !_isChasing) {
        _isScattering = false;
        changeMode();
      }

      //switches to scatter mode if the requirements are fulfilled
      if (_outOfGate == true && _isScattering == false && _isChasing == true
          && _changeModeTimer != 0 && (_changeModeTimer % _chasingTimer) == 0) {
        _isScattering = true;
        changeMode();
      }

      //switches to chasing mode if the requirements are fulfilled
      if (_outOfGate == true && _isScattering == true && _isChasing == false
          && _changeModeTimer != 0 &&
          (_changeModeTimer % _scatteringTimer) == 0) {
        _isScattering = false;
        changeMode();
      }

      //updates the target of Blinky while in chasing mode to the
      //current position of Pac-Man every step
      if (_isScattering == false && _isChasing == true &&
          (_changeModeTimer % update) == 0) {
        _targetX = _level.pacmanX;
        _targetY = _level.pacmanY;
      }

      //checks if Blinky has reached his target and changes the mode accordingly
      if (_x == _targetX && _y == _targetY) {
        if (_x == doorX && _y == doorY) {
          _outOfGate = true;
          _isScattering = true;
          changeMode();
        }

        if (_x == _scatterX && _y == _scatterY) {
          _isScattering = false;
          changeMode();
        }

        if (_x == _targetX && _y == _targetY) {
          _isScattering = true;
          changeMode();
        }
      }

      //gets the Direction Blinky is allowed to head next, registers his next position
      //and updates his previous direction
      switch (getNextMove(_x, _y, _targetX, _targetY, _outOfGate, _previousDirections, this)) {
        case Directions.UP:
          _level._registerElement(_x, _y, _x, --_y, this);
          _previousDirections = Directions.UP;
          break;

        case Directions.DOWN:
          _level._registerElement(_x, _y, _x, ++_y, this);
          _previousDirections = Directions.DOWN;
          break;

        case Directions.LEFT:
          _level._registerElement(_x, _y, --_x, _y, this);
          _previousDirections = Directions.LEFT;
          break;

        case Directions.RIGHT:
          _level._registerElement(_x, _y, ++_x, _y, this);
          _previousDirections = Directions.RIGHT;
          break;

        case Directions.NOTHING:
          _level._registerElement(_x, _y, _x, _y, this);
          _previousDirections = Directions.NOTHING;
          break;
      }


      ++_changeModeTimer;
    }
  }

  /**
   * changes the mode between scattering and chasing
   * sets the timer back and updates the needed variables
   */
  void changeMode() {
    if (_isScattering == true) {
      _isChasing = false;
      _changeModeTimer = 0;
      _targetX = _scatterX;
      _targetY = _scatterY;
    }
    else {
      _isChasing = true;
      _changeModeTimer = 0;
      _targetX = _level.pacmanX;
      _targetY = _level.pacmanY;
    }
  }
}