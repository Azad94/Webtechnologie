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

  /**
   * the Direction where the Ghost is trying or is heading next
   */
  Directions nextDirection;

  /**
   * the Direction where the Ghost came from
   */
  //Directions _previousDirection;

  /**
   * amount of Directions on a intersection the Ghost possibly can go
   */
  int _possibleDirections;

  /**
   * checks if the Direction UP is possible
   */
  bool _possibleUp;

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
   * reference to the level
   */
  Level _level;

  /**
   * Constructor of class Ghost
   */
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
   * moves a ghost one step
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
    _started = false;
    timeCounter = 0;
    _x = _x_start;
    _y = _y_start;
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
      nextDirection = preferredVerDirection
        : nextDirection = preferredHorDirection;


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
          if ((targetY - --_checkY).abs() < _currentDistanceY){
           // _prev = Directions.UP;
            return Directions.UP;
          }
        }
        _checkY = currentY;

        if (!_level.checkCollision(--_checkX, _checkY, this)){
          _checkX = currentX;
          if ((targetX - --_checkX).abs() < _currentDistanceX){
          //  _prev = Directions.LEFT;
            return Directions.LEFT;
          }
        }
        _checkX = currentX;

        if (!_level.checkCollision(++_checkX, _checkY, this)){
          _checkX = currentX;
          if ((targetX - ++_checkX).abs() < _currentDistanceX){
          //  _prev = Directions.RIGHT;
             return Directions.RIGHT;
          }
        }
        _checkX = currentX;
      }

      if (_prev != Directions.UP && _possibleDown){
        if (!_level.checkCollision(_checkX, ++_checkY, this)){
          _checkY = currentY;
          if ((targetY - ++_checkY).abs() < _currentDistanceY){
            if (_currentDistanceY > _currentDistanceX){
          //    _prev = Directions.DOWN;
              return Directions.DOWN;
            }
          }
        }
        _checkY = currentY;

        if (!_level.checkCollision(--_checkX, _checkY, this)){
          _checkX = currentX;
          if ((targetX - --_checkX).abs() < _currentDistanceX){
         //   _prev = Directions.LEFT;
            return Directions.LEFT;
          }
        }
        _checkX = currentX;

        if (!_level.checkCollision(++_checkX, _checkY, this)){
          _checkX = currentX;
          if ((targetX - ++_checkX).abs() < _currentDistanceX){
         //   _prev = Directions.RIGHT;
            return Directions.RIGHT;
          }
        }
        _checkX = currentX;

        if (!_level.checkCollision(_checkX, ++_checkY, this)){
          _checkY = currentY;
          if ((targetY - ++_checkY).abs() < _currentDistanceY) {
        //  _prev = Directions.DOWN;
          return Directions.DOWN;
          }
        }
        _checkY = currentY;
      }

      if (_prev != Directions.RIGHT && _possibleLeft) {
        if ((targetX - --_checkX).abs() < _currentDistanceX) {
          if (!_level.checkCollision(--_checkX, _checkY, this)) {
            _checkX = currentX;
            if ((targetX - --_checkX).abs() < _currentDistanceX) {
          //    _prev= Directions.LEFT;
              return Directions.LEFT;
            }
          }
          _checkX = currentX;

          if (!_level.checkCollision(_checkX, ++_checkY, this)) {
            _checkY = currentY;
            if (_prev != Directions.UP &&
                (targetY - ++_checkY).abs() < _currentDistanceY) {
           //   _prev = Directions.DOWN;
              return Directions.DOWN;
            }
          }
          _checkY = currentY;

          if (!_level.checkCollision(_checkX, --_checkY, this)) {
            _checkY = currentY;
            if ((targetY - --_checkY).abs() < _currentDistanceY) {
           //   _prev = Directions.UP;
              return Directions.UP;
            }
          }
          _checkY = currentY;
        }
      }
        if (_prev != Directions.LEFT && _possibleRight){
          if (!_level.checkCollision(++_checkX, _checkY, this)){
            _checkX = currentX;
            if ((targetX - ++_checkX) < _currentDistanceX){
          //    _prev = Directions.RIGHT;
              return Directions.RIGHT;
            }
          }
          _checkX = currentX;

          if (!_level.checkCollision(_checkX, --_checkY, this)){
            _checkY = currentY;
            if ((targetY - --_checkY).abs() < _currentDistanceY){
          //    _prev = Directions.UP;
              return Directions.UP;
            }
          }
          _checkY = currentY;

          if (!_level.checkCollision(_checkX, ++_checkY, this)){
            _checkY = currentY;
            if ((targetY - ++_checkY).abs() < _currentDistanceY){
          //    _prev = Directions.DOWN;
              return Directions.DOWN;
            }
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
       //   _prev = Directions.LEFT;
          return Directions.LEFT;
        }
        _checkX = currentX;

        if (!_level.checkCollision(_checkX, --_checkY, this)) {
          _checkY = currentY;
        //  _prev = Directions.UP;
          return Directions.UP;
        }
        _checkY = currentY;

        if (!_level.checkCollision(++_checkX, _checkY, this)) {
       //   _prev = Directions.RIGHT;
          return Directions.RIGHT;
        }
        _checkX = currentX;
        return Directions.NOTHING;
      }

      if (_prev == Directions.DOWN) {
        if (!_level.checkCollision(_checkX, ++_checkY, this)) {
          _checkY = currentY;
      //    _prev = Directions.DOWN;
          return Directions.DOWN;
        }
        _checkY = currentY;

        if (!_level.checkCollision(--_checkX, _checkY, this)) {
          _checkX = currentX;
       //   _prev = Directions.LEFT;
          return Directions.LEFT;
        }
        _checkX = currentX;

        if (!_level.checkCollision(++_checkX, _checkY, this)) {
       //   _prev = Directions.RIGHT;
          return Directions.RIGHT;
        }
        _checkX = currentX;
        return Directions.NOTHING;
      }

      if (_prev == Directions.LEFT) {
        if (!_level.checkCollision(_checkX, --_checkY, this)) {
          _checkY = currentY;
      //    _prev = Directions.UP;
          return Directions.UP;
        }
        _checkY = currentY;

        if (!_level.checkCollision(_checkX, ++_checkY, this)) {
          _checkY = currentY;
     //     _prev = Directions.DOWN;
          return Directions.DOWN;
        }
        _checkY = currentY;

        if (!_level.checkCollision(--_checkX, _checkY, this)) {
      //    _prev = Directions.LEFT;
          return Directions.LEFT;
        }
        _checkX = currentX;
        return Directions.NOTHING;
      }

      if (_prev == Directions.RIGHT) {
        if (!_level.checkCollision(_checkX, --_checkY, this)) {
          _checkY = currentY;
     //     _prev = Directions.UP;
          return Directions.UP;
        }
        _checkY = currentY;

        if (!_level.checkCollision(_checkX, ++_checkY, this)) {
          _checkY = currentY;
     //     _prev = Directions.DOWN;
          return Directions.DOWN;
        }
        _checkY = currentY;

        if (!_level.checkCollision(++_checkX, _checkY, this)) {
      //    _prev = Directions.RIGHT;
          return Directions.RIGHT;
        }
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
      //    _prev = Directions.LEFT;
          return Directions.LEFT;
        }
        _checkX = currentX;

        if (!_level.checkCollision(_checkX, --_checkY, this)) {
          _checkY = currentY;
      //    _prev = Directions.UP;
          return Directions.UP;
        }
        _checkY = currentY;

        if (!_level.checkCollision(_checkX, ++_checkY, this)) {
      //    _prev = Directions.DOWN;
          return Directions.DOWN;
        }
        _checkY = currentY;
        return Directions.NOTHING;
      }

      if (_prev == Directions.RIGHT) {
        if (!_level.checkCollision(++_checkX, _checkY, this)) {
          _checkX = currentX;
      //    _prev = Directions.RIGHT;
          return Directions.RIGHT;
        }
        _checkX = currentX;

        if (!_level.checkCollision(_checkX, --_checkY, this)) {
          _checkY = currentY;
       //   _prev = Directions.UP;
          return Directions.UP;
        }
        _checkX = currentX;

        if (!_level.checkCollision(_checkX, ++_checkY, this)) {
      //    _prev = Directions.DOWN;
          return Directions.DOWN;
        }
        _checkY = currentY;
        return Directions.NOTHING;
      }

      if (_prev == Directions.UP) {
        if (!_level.checkCollision(--_checkX, _checkY, this)) {
          _checkX = currentX;
        //  _prev = Directions.LEFT;
          return Directions.LEFT;
        }
        _checkX = currentX;

        if (!_level.checkCollision(++_checkX, _checkY, this)) {
          _checkX = currentX;
        //  _prev = Directions.RIGHT;
          return Directions.RIGHT;
        }
        _checkX = currentX;

        if (!_level.checkCollision(_checkX, --_checkY, this)) {
       //   _prev = Directions.UP;
          return Directions.UP;
        }
        _checkY = currentY;
        return Directions.NOTHING;
      }

      if (_prev == Directions.DOWN) {
        if (!_level.checkCollision(--_checkX, _checkY, this)) {
          _checkX = currentX;
       //   _prev = Directions.LEFT;
          return Directions.LEFT;
        }
        _checkX = currentX;

        if (!_level.checkCollision(++_checkX, _checkY, this)) {
          _checkX = currentX;
       //   _prev = Directions.RIGHT;
          return Directions.RIGHT;
        }
        _checkX = currentX;

        if (!_level.checkCollision(_checkX, ++_checkY, this))
          return Directions.DOWN;

        _checkY = currentY;
        return Directions.NOTHING;
      }
    }
    return Directions.NOTHING;
  }
}