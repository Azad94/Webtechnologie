part of pacmanModelLib;

/**
 * AI for the Ghost CLYDE
 * he doesn't pursuit the Pac-Man as the other Ghosts and spends more of his time
 * scatter to his point keep his distance from Pac-Man
 * but if Pac-Man crosses his way to his scatter position he doesn't hold back
 * eating him
 * he leaves the gate at last
 */
class Clyde extends Ghost {
  Clyde(int x, int y, bool collPlayer, bool collGhost, Level l, num eatTime,
      num startTime, num score)
      : super(x, y, collPlayer, collGhost, l, eatTime, startTime, score);

  int _doorX = 14;
  int _doorY = 8;

  int _scatterX = 1;
  int _scatterY = 16;

  /**
   * Moves Clyde one step further
   */
  void move() {
    super.move();

    _chasingTimer = 40;
    _scatteringTimer = 22;
    update = 5;

    //checks if Clyde is allowed to move yet
    if (_started) {
      //if Clyde is at his origin position his first target is to get out of the Door
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
      if (_outOfGate && !_isScattering && _isChasing
          && _changeModeTimer != 0 && (_changeModeTimer % _chasingTimer) == 0) {
        _isScattering = true;
        changeMode();
      }

      //switches to chasing mode if the requirements are fulfilled
      if (_outOfGate == true && _isScattering == true && _isChasing == false
          && _changeModeTimer != 0 && (_changeModeTimer % _scatteringTimer) == 0)  {
        _isScattering = false;
        changeMode();
      }

      //updates the target of Clyde while in chasing mode to the current
      //position of Pac-Man every five steps
      if (_isScattering == false && _isChasing == true && (_changeModeTimer % update) == 0) {
        _targetX = _level.pacmanX;
        _targetY = _level.pacmanY;
      }

      //gets the Direction Clyde is allowed to head next, registers his next position
      //and updates his previous direction
      switch (getNextMove(_x, _y, _targetX, _targetY, _outOfGate, _previousDirections, this)) {
        case Directions.UP:
          _level.registerElement(_x, _y, _x, --_y, this);
          _previousDirections = Directions.UP;
          break;

        case Directions.DOWN:
          _level.registerElement(_x, _y, _x, ++_y, this);
          _previousDirections = Directions.DOWN;
          break;

        case Directions.LEFT:
          _level.registerElement(_x, _y, --_x, _y, this);
          _previousDirections = Directions.LEFT;
          break;

        case Directions.RIGHT:
          _level.registerElement(_x, _y, ++_x, _y, this);
          _previousDirections = Directions.RIGHT;
          break;

        case Directions.NOTHING:
          _level.registerElement(_x, _y, _x, _y, this);
          _previousDirections = Directions.NOTHING;
          break;
      }

      //checks if Clyde has reached his target and changes the mode accordingly
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

    if (_isScattering) {
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