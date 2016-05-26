part of pacmanLib;

/**
 * AI for the Ghost INKY
 * his target is always four squares ahead of Pac-Man
 * he comes out of the gate immediately after Blinky has left the gate
 */
class Pinky extends Ghost {
  Pinky(int x, int y, bool collPlayer, bool collGhost, Level l, num eatTime,
      num startTime, num score)
      : super( x, y, collPlayer, collGhost, l, eatTime, startTime, score);

  int _doorX = 14;
  int _doorY = 8;

  int _scatterX = 1;
  int _scatterY = 1;

  /**
   * X-Coordinate for the next horizontal target of Pinky
   */
  int _targetX;

  /**
   * Y-Coordinate for the next vertical target of Pinky
   */
  int _targetY;

  /**
   * Direction where Blinky came from
   */
  Directions _previousDirection;

  /**
   * period of Time Pinky is chasing the Pac-Man
   */
  int _chasingTime = 50;

  /**
   * period of Time Pinky is chasing the Pac-Man
   */
  int _scatteringTime = 18;

  /**
   * updates the Pac-Man position as target
   * after a certain amount of time
   */
  int _updateTargetTimer = 2;

  /**
   * Moves Pinky one step further
   */
  void move() {
    super.move();

    //checks if Pinky is allowed to move yet
    if (_started) {
      //if Pinky is at his origin position his first target is to get out of the Door
      if (_x == _x_start && _y == _y_start) {
        _targetX = _doorX;
        _targetY = _doorY;
        _isScattering = false;
        _isChasing = false;
        _previousDirection = Directions.RIGHT;
      }

      //change to scatter mode after chasing time is up
      if (_changeModeTimer > _chasingTime && !_isScattering && _isChasing) {
        _isScattering = true;
        changeMode();
      }

      //change to chase mode after scatter mode is up
      if (_changeModeTimer > _scatteringTime && _isScattering && !_isChasing) {
        _isScattering = false;
        changeMode();
      }

      //switches to scatter mode if the requirements are fulfilled
      if (_outOfGate == true && _isScattering == false && _isChasing == true
          && _changeModeTimer != 0 && (_changeModeTimer % _chasingTime) == 0) {
        _isScattering = true;
        changeMode();
      }

      //switches to chasing mode if the requirements are fulfilled
      if (_outOfGate == true && _isScattering == true && _isChasing == false
          && _changeModeTimer != 0 &&
          (_changeModeTimer % _scatteringTime) == 0) {
        _isScattering = false;
        changeMode();
      }

      //updates the target of Pinky while in chasing mode
      //four squares ahead of the current position of Pac-Man
      if (_isScattering == false && _isChasing == true && (_changeModeTimer % _updateTargetTimer) == 0) {
        switch(_level._pacmanPre){
          case Types.PACMAN_UP:
            _targetX = _level.pacmanX;
            _targetY = _level.pacmanY - 4;
            break;
          case Types.PACMAN_DOWN:
            _targetX = _level.pacmanX;
            _targetY = _level.pacmanY + 4;
            break;
          case Types.PACMAN_LEFT:
            _targetX = _level.pacmanX - 4;
            _targetY = _level.pacmanY;
            break;
          case Types.PACMAN_RIGHT:
            _targetX = _level.pacmanX + 4;
            _targetY = _level.pacmanY;
            break;
          default:
            break;
        }
      }

      //gets the Direction Pinky is allowed to head next, registers his next position
      //and updates his previous direction
      switch (getNextMove(_x, _y, _targetX, _targetY, _outOfGate, _previousDirection, this)) {
        case Directions.UP:
          _level.registerElement(_x, _y, _x, --_y, this);
          _previousDirection = Directions.UP;
          break;

        case Directions.DOWN:
        // TODO PROVISORISCH MUSS RAUS
          if (_x == _doorX && _y == _doorY) {
            _level.registerElement(_x, _y, ++_x, _y, this);
            _previousDirection = Directions.LEFT;
            break;
          }
          _level.registerElement(_x, _y, _x, ++_y, this);
          _previousDirection = Directions.DOWN;
          break;

        case Directions.LEFT:
          _level.registerElement(_x, _y, --_x, _y, this);
          _previousDirection = Directions.LEFT;
          break;

        case Directions.RIGHT:
          _level.registerElement(_x, _y, ++_x, _y, this);
          _previousDirection = Directions.RIGHT;
          break;

        case Directions.NOTHING:
          _level.registerElement(_x, _y, _x, _y, this);
          _previousDirection = Directions.NOTHING;
          break;
      }

      //checks if Pinky has reached his target and changes the mode accordingly
      if (_x == _targetX && _y == _targetY) {
        if (_x == _doorX && _y == _doorY) {
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