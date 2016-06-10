part of pacmanLib;

abstract class Ghost extends GameElement {
  /**
   * start position of ghost
   */
  final _start_x, _start_y;

  /**
   * true if ghost is eatable, else false
   */
  bool _eatable = false;

  /**
   * true if the ghost is moving, else false
   */
  bool _started = false;

  /**
   * score of the ghost
   */
  int _score;

  /**
   * the Direction where the Ghost is trying or is heading next
   */
  Directions _nextDirection;

  /**
   * period of Time Blinky is chasing the Pac-Man
   */
  int _chasingTimer;

  /**
   * period of Time Blinky is chasing the Pac-Man
   */
  int _scatteringTimer;

  /**
   * Direction where the Ghost came from
   */
  Directions _previousDirections;
  /**
   * amount of Directions on a intersection the Ghost possibly can go
   */
  int _possibleDirections;

  /**
   * the target of the Ghost
   */
  int _targetX, _targetY;
  /**
   * checks if the Direction UP is possible
   */
  bool _possibleUp;

  /**
   * updates the Pac-Man position as target
   * after the given time
   */
  int update;

  /**
   * checks if the Direction Down is possible
   */
  bool _possibleDown;

  /**
   * checks if the Direction Left is possible
   */
  bool _possibleLeft;

  /**
   * checks if the Direction Right is possible
   */
  bool _possibleRight;

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
   * counter to change Mode between scatter and chase
   */
  int _changeModeTimer= 0;

  /**
   * reference to the level
   */
  Level _level;

  /**
   * true if Clyde is scattering, else false
   */
  bool _isScattering;

  /**
   * true if Clyde is chasing the Pac-Man, else false
   */
  bool _isChasing;

  /**
   * true if the Ghost is out of the Gate, else false
   */
  bool _outOfGate = false;

  int doorX;
  int doorY;
  int scatterX, scatterY;
  /**
   * Constructor of class Ghost
   */
  Ghost(int startx, int starty,bool collPlayer, bool collGhost, Level l, num eatTime, num startTime,
      num score)
      : super(startx, starty, collPlayer, collGhost),
        this._level = l,
        this._eatTime = eatTime,
        this._startTime = startTime,
        this._start_x = startx,
        this._start_y = starty,
        this._score = score;
  bool get eatable => _eatable;

  /**
   * moves a ghost one step
   */
  void move() {
    scatterX;
    if(!_started) {
      timeCounter++;

      if(timeCounter == _startTime) {
        _targetX = 0;
        _targetY = 0;
        timeCounter = 0;
        _started = true;
        _isScattering = true;
        _isChasing = false;
        _outOfGate = false;
        _chasingTimer;
        _scatteringTimer;
        _previousDirections;
        update;
        doorX = _level._doorX;
        doorY = _level._doorY;
      }
    }

    if(_started) _changeModeTimer++;

    // only if eatable mode is on
    if (_eatable) {
      timeCounter++;

      // check if the eatable mode is over
      if (timeCounter == _eatTime) {
        _eatable = false;
        timeCounter = 0;
        _level.endEatableMode();
      }
    }

    print("GHOST X" + _targetX.toString());
    print("GHOST Y" + _targetY.toString());
/**
    switch (getNextMove(_x, _y, _targetX, _targetY, _outOfGate, _previousDirections, this)) {
      case Directions.UP:
        _level.registerElement(_x, _y, _x, --_y, this);
        _previousDirections = Directions.UP;
        break;

      case Directions.DOWN:
      // TODO PROVISORISCH MUSS RAUS
        if (_x == doorX && _y == doorY) {
          _level.registerElement(_x, _y, ++_x, _y, this);
          _previousDirections = Directions.LEFT;
          break;
        }
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
**/

  }

  /**
   * enable the eatable mode
   */
  void eatableMode() {
    _eatable = true;
  }

  /**
   * respawn the ghost to his start position
   */
  void respwan() {
    _eatable = false;
    timeCounter = 0;
    _started = false;
    _startTime = 4; // to to wait after respawn
    _level.registerElement(_x, _y, _start_x, _start_y, this);
    _x = _start_x;
    _y = _start_y;
  }

  /**
   * checks in which Direction the Ghost is allowed to move next
   * with CollisionDetection and the Direction priority of
   * UP --> LEFT --> DOWN --> RIGHT
   * return   the Direction where the Ghost is allowed to move next
   *          (UP, DOWN, LEFT, RIGHT, NOTHING)
   */
  Directions getNextMove(int currentX, int currentY, int targetX, int targetY, bool _outOfDoor, Directions _prev, GameElement g) {

    _possibleDirections = 0;
    _possibleDirections = 0 ;
    _possibleUp = false;
    _possibleDown = false;
    _possibleLeft = false;
    _possibleRight = false;

    Directions preferredHorDirection;
    Directions preferredVerDirection;

    //calculates the vertical and horizontal distance between the current and target Position
    int _currentDistanceX = (targetX - currentX).abs();
    int _currentDistanceY = (targetY - currentY).abs();

    // variables to check for collision without changing current Position Coordinates
    int _checkX = currentX;
    int _checkY = currentY;

    if(currentX == targetX && currentY == targetY) return Directions.NOTHING;

    //calculates the preffered horizontal Direction the Ghost should move
    (targetX - --_checkX).abs() < _currentDistanceX ?
      preferredHorDirection = Directions.LEFT
        : preferredHorDirection = Directions.RIGHT;

    _checkX = currentX;

    //calculates the preferred vertical Direction the Ghost should move
    (targetY - --_checkY).abs() < _currentDistanceY ?
      preferredVerDirection = Directions.UP
        : preferredVerDirection = Directions.DOWN;

    _checkY = currentY;

    //checks if the vertical difference is greater than the horizontal
    bool verticalMoreImportant = _currentDistanceY > _currentDistanceX;

    //sets the next Direction according to the calculation above
    verticalMoreImportant ?
      _nextDirection = preferredVerDirection
        : _nextDirection = preferredHorDirection;


    /**
     * Checks if there is an intersection and how many possible
     * Directions are allowes
     */
    if (!_level.checkCollision(_checkX, --_checkY, this)){
      if (_prev != Directions.DOWN){
        _possibleDirections++;
        _possibleUp = true;
      }
    }
    _checkY = currentY;


    if (!_level.checkCollision(_checkX, ++_checkY, this)){
      if (_prev != Directions.UP){
        _possibleDirections++;
        _possibleDown = true;
      }
    }
    _checkY = currentY;


    if (!_level.checkCollision(--_checkX, _checkY, this)){
      if (_prev != Directions.RIGHT){
        _possibleDirections++;
        _possibleLeft = true;
      }
    }
    _checkX = currentX;


    if (!_level.checkCollision(++_checkX, _checkY, this)){
      if (_prev != Directions.LEFT){
        _possibleDirections++;
        _possibleRight = true;
      }
    }
    _checkX = currentX;


    /**
     * if there is an intersection move in the Direction where the
     * distance between the Ghost and target declines
     */
    if (_possibleDirections > 1){
      if (_prev != Directions.DOWN && _possibleUp){
        if (!_level.checkCollision(_checkX, --_checkY, this)){
          _checkY = currentY;
          if ((targetY - --_checkY).abs() < _currentDistanceY) return Directions.UP;
        }
        _checkY = currentY;

        if (!_level.checkCollision(--_checkX, _checkY, this)){
          _checkX = currentX;
          if ((targetX - --_checkX).abs() < _currentDistanceX) return Directions.LEFT;

        }
        _checkX = currentX;

        if (!_level.checkCollision(++_checkX, _checkY, this)){
          _checkX = currentX;
          if ((targetX - ++_checkX).abs() < _currentDistanceX) return Directions.RIGHT;
        }
        _checkX = currentX;
      }

      if (_prev != Directions.UP && _possibleDown){
        if (!_level.checkCollision(_checkX, ++_checkY, this)){
          _checkY = currentY;
          if ((targetY - ++_checkY).abs() < _currentDistanceY){
            if (_currentDistanceY > _currentDistanceX) return Directions.DOWN;
          }
        }
        _checkY = currentY;

        if (!_level.checkCollision(--_checkX, _checkY, this)){
          _checkX = currentX;
          if ((targetX - --_checkX).abs() < _currentDistanceX) return Directions.LEFT;
        }
        _checkX = currentX;

        if (!_level.checkCollision(++_checkX, _checkY, this)){
          _checkX = currentX;
          if ((targetX - ++_checkX).abs() < _currentDistanceX) return Directions.RIGHT;
        }
        _checkX = currentX;

        if (!_level.checkCollision(_checkX, ++_checkY, this)){
          _checkY = currentY;
          if ((targetY - ++_checkY).abs() < _currentDistanceY) return Directions.DOWN;
        }
        _checkY = currentY;
      }

      if (_prev != Directions.RIGHT && _possibleLeft) {
        if ((targetX - --_checkX).abs() < _currentDistanceX) {
          if (!_level.checkCollision(--_checkX, _checkY, this)) {
            _checkX = currentX;
            if ((targetX - --_checkX).abs() < _currentDistanceX) return Directions.LEFT;
          }
          _checkX = currentX;

          if (!_level.checkCollision(_checkX, ++_checkY, this)) {
            _checkY = currentY;
            if (_prev != Directions.UP && (targetY - ++_checkY).abs() < _currentDistanceY)
              return Directions.DOWN;
          }
          _checkY = currentY;

          if (!_level.checkCollision(_checkX, --_checkY, this)) {
            _checkY = currentY;
            if ((targetY - --_checkY).abs() < _currentDistanceY) return Directions.UP;

          }
          _checkY = currentY;
        }
      }
        if (_prev != Directions.LEFT && _possibleRight){
          if (!_level.checkCollision(++_checkX, _checkY, this)){
            _checkX = currentX;
            if ((targetX - ++_checkX) < _currentDistanceX) return Directions.RIGHT;

          }
          _checkX = currentX;

          if (!_level.checkCollision(_checkX, --_checkY, this)){
            _checkY = currentY;
            if ((targetY - --_checkY).abs() < _currentDistanceY) return Directions.UP;

          }
          _checkY = currentY;

          if (!_level.checkCollision(_checkX, ++_checkY, this)){
            _checkY = currentY;
            if ((targetY - ++_checkY).abs() < _currentDistanceY) return Directions.DOWN;
          }
          _checkY = currentY;
        }
    }

    /**
     * Checks for next Direction with priority of moving vertically first
     */
    if (verticalMoreImportant) {
      if (_prev == Directions.UP) {
        if (!_level.checkCollision(--_checkX, _checkY, this)) {
          _checkX = currentX;
          return Directions.LEFT;
        }
        _checkX = currentX;

        if (!_level.checkCollision(_checkX, --_checkY, this)) {
          _checkY = currentY;
          return Directions.UP;
        }
        _checkY = currentY;

        if (!_level.checkCollision(++_checkX, _checkY, this))  return Directions.RIGHT;
        _checkX = currentX;

        return Directions.NOTHING;
      }

      if (_prev == Directions.DOWN) {
        if (!_level.checkCollision(_checkX, ++_checkY, this)) {
          _checkY = currentY;
          return Directions.DOWN;
        }
        _checkY = currentY;

        if (!_level.checkCollision(--_checkX, _checkY, this)) {
          _checkX = currentX;
          return Directions.LEFT;
        }
        _checkX = currentX;

        if (!_level.checkCollision(++_checkX, _checkY, this)) return Directions.RIGHT;

        _checkX = currentX;
        return Directions.NOTHING;
      }

      if (_prev == Directions.LEFT) {
        if (!_level.checkCollision(_checkX, --_checkY, this)) {
          _checkY = currentY;
          return Directions.UP;
        }
        _checkY = currentY;

        if (!_level.checkCollision(_checkX, ++_checkY, this)) {
          _checkY = currentY;
          return Directions.DOWN;
        }
        _checkY = currentY;

        if (!_level.checkCollision(--_checkX, _checkY, this)) return Directions.LEFT;

        _checkX = currentX;
        return Directions.NOTHING;
      }

      if (_prev == Directions.RIGHT) {
        if (!_level.checkCollision(_checkX, --_checkY, this)) {
          _checkY = currentY;
          return Directions.UP;
        }
        _checkY = currentY;

        if (!_level.checkCollision(_checkX, ++_checkY, this)) {
          _checkY = currentY;
          return Directions.DOWN;
        }
        _checkY = currentY;

        if (!_level.checkCollision(++_checkX, _checkY, this)) return Directions.RIGHT;
        _checkX = currentX;

        return Directions.NOTHING;
      }
    }
    /**
     * Checks for next Direction with priority of moving horizontally first
     */
    else {
      if (_prev == Directions.LEFT) {
        if (!_level.checkCollision(--_checkX, _checkY, this)) {
          _checkX = currentX;
          return Directions.LEFT;
        }
        _checkX = currentX;

        if (!_level.checkCollision(_checkX, --_checkY, this)) {
          _checkY = currentY;
          return Directions.UP;
        }
        _checkY = currentY;

        if (!_level.checkCollision(_checkX, ++_checkY, this)) return Directions.DOWN;
        _checkY = currentY;

        return Directions.NOTHING;
      }

      if (_prev == Directions.RIGHT) {
        if (!_level.checkCollision(++_checkX, _checkY, this)) {
          _checkX = currentX;
          return Directions.RIGHT;
        }
        _checkX = currentX;

        if (!_level.checkCollision(_checkX, --_checkY, this)) {
          _checkY = currentY;
          return Directions.UP;
        }
        _checkX = currentX;

        if (!_level.checkCollision(_checkX, ++_checkY, this)) return Directions.DOWN;
        _checkY = currentY;

        return Directions.NOTHING;
      }

      if (_prev == Directions.UP) {
        if (!_level.checkCollision(--_checkX, _checkY, this)) {
          _checkX = currentX;
          return Directions.LEFT;
        }
        _checkX = currentX;

        if (!_level.checkCollision(++_checkX, _checkY, this)) {
          _checkX = currentX;
          return Directions.RIGHT;
        }
        _checkX = currentX;

        if (!_level.checkCollision(_checkX, --_checkY, this)) return Directions.UP;
        _checkY = currentY;

        return Directions.NOTHING;
      }

      if (_prev == Directions.DOWN) {
        if (!_level.checkCollision(--_checkX, _checkY, this)) {
          _checkX = currentX;
          return Directions.LEFT;
        }
        _checkX = currentX;

        if (!_level.checkCollision(++_checkX, _checkY, this)) {
          _checkX = currentX;
          return Directions.RIGHT;
        }
        _checkX = currentX;

        if (!_level.checkCollision(_checkX, ++_checkY, this)) return Directions.DOWN;
        _checkY = currentY;

        return Directions.NOTHING;
      }
    }
    return Directions.NOTHING;
  }
}