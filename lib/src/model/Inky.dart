part of pacmanModelLib;

/**
 * AI for the Ghost INKY
 * he tries to be at the same horizontal level with Pac-Man
 * during the whole game and tries to get in front of him,
 * he leaves the gate as second last ghost
 */
class Inky extends Ghost {
  Inky(int x, int y, bool collPlayer, bool collGhost, Level l, num eatTime,
      num startTime, num score)
      : super(x, y, collPlayer, collGhost, l, eatTime, startTime, score){

    //Scatter position of Inky
    _scatterX = _level._sizeX - 1;
    _scatterY = _level._sizeY - 1;
  }

  /**
   * Moves Inky one step further
   */
  void move() {
    super.move();
    _chasingTimer = 40;
    _scatteringTimer = 20;
    update = 3;

    //checks if Inky is allowed to move yet
    if (_started) {
      //if Inky is at his origin position his first target is
      // to get out of the Door
      if (_x == _start_x && _y == _start_y) {
        _targetX = _doorX;
        _targetY = _doorY;
        _isScattering = false;
        _isChasing = false;
        _previousDirections = Directions.LEFT;
      }

      //change to scatter mode after chasing time is up
      if(_changeModeTimer > _chasingTimer && !_isScattering && _isChasing) {
        _isScattering = true;
        changeMode();
      }

      //change to chase mode after scatter mode is up
      if(_changeModeTimer > _scatteringTimer && _isScattering && !_isChasing){
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
          && _changeModeTimer != 0
          && (_changeModeTimer % _scatteringTimer) == 0)  {
        _isScattering = false;
        changeMode();
      }

      //updates the target of Inky while in chasing mode three suqares ahead
      //of the current position of Pac-Man every three steps
      if (_isScattering == false && _isChasing == true
          && (_changeModeTimer % update) == 0) {
        switch(_level._pacmanPre){
          case Types.PACMAN_UP:
            _targetX = _level.pacmanX;
            (_targetY - _y > 0) ? _targetY = _level.pacmanY + 1
              : _targetY = _level.pacmanY - 1;
            break;
          case Types.PACMAN_DOWN:
            _targetX = _level.pacmanX;
            (_targetY - _y > 0) ? _targetY = _level.pacmanY + 1
                : _targetY = _level.pacmanY - 1;
            break;
          case Types.PACMAN_LEFT:
            _targetX = _level.pacmanX;
            (_targetY - _y > 0) ? _targetY = _level.pacmanY + 1
                : _targetY = _level.pacmanY - 1;
            break;
          case Types.PACMAN_RIGHT:
            _targetX = _level.pacmanX;
            (_targetY - _y > 0) ? _targetY = _level.pacmanY + 1
                : _targetY = _level.pacmanY - 1;
            break;

          default:
            break;
        }
      }

      //gets the Direction Inky is allowed to head next,
      //registers his next position and updates his previous direction
      switch (getNextMove(_x, _y, _targetX, _targetY, _outOfGate,
          _previousDirections, this)) {
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

      //checks if Inky has reached his target and changes the mode accordingly
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
