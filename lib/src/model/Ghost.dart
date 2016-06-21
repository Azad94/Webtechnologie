part of pacmanModelLib;

/**
 * Contains the structure for each Ghost
 */
abstract class Ghost extends GameElement {

  /**
   * start position of the Ghost
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
  int _possibleDirections = 0;

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

  /**
   * Position of the Door
   */
  int _doorX, _doorY;

  /**
   * Scatter Position of the Ghost
   */
  int _scatterX, _scatterY;

  /**
   * true if the vertical difference between
   * the Ghost and Pac-Man is higher than
   * the horizontal difference, else false
   */
  bool _isVerticalMoreImportant;

  /**
   * Constructor of class Ghost
   */
  Ghost(int startx, int starty,bool collPlayer, bool collGhost, Level l,
      num eatTime, num startTime, num score)
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
    if(!_started) {
      timeCounter++;

      //Attributs needed for the AI
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
        _doorX = _level._doorX;
        _doorY = _level._doorY;
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
        _level._endEatableMode();
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
    timeCounter = 0;
    _started = false;
    _startTime = 4; // to to wait after respawn
    _level._registerElement(_x, _y, _start_x, _start_y, this);
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
  Directions getNextMove(int currentX, int currentY, int targetX,
      int targetY, bool isOutOfDoor, Directions previouDirection,
      GameElement g) {

    _possibleDirections = 0;
    _possibleUp = false;
    _possibleDown = false;
    _possibleLeft = false;
    _possibleRight = false;

    //calculates the vertical and horizontal distance between the current
    // and target Position
    int _currentDistanceX = (targetX - currentX).abs();
    int _currentDistanceY = (targetY - currentY).abs();

    // variables to check for collision without changing
    // current Position Coordinates
    int _checkX = currentX;
    int _checkY = currentY;

    if(currentX == targetX && currentY == targetY) return Directions.NOTHING;

    //checks if the vertical difference is greater than the horizontal
    _isVerticalMoreImportant = _currentDistanceY > _currentDistanceX;


    /**
     * Checks if there is an intersection and how many possible
     * Directions are allowes
     */
    if (!_level._checkCollision(_checkX, --_checkY, this)){
      if (previouDirection != Directions.DOWN){
        _possibleDirections++;
        _possibleUp = true;
      }
    }
    _checkY = currentY;


    if (!_level._checkCollision(_checkX, ++_checkY, this)){
      if (previouDirection != Directions.UP){
        _possibleDirections++;
        _possibleDown = true;
      }
    }
    _checkY = currentY;


    if (!_level._checkCollision(--_checkX, _checkY, this)){
      if (previouDirection != Directions.RIGHT){
        _possibleDirections++;
        _possibleLeft = true;
      }
    }
    _checkX = currentX;


    if (!_level._checkCollision(++_checkX, _checkY, this)){
      if (previouDirection != Directions.LEFT){
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
      if (previouDirection != Directions.DOWN && _possibleUp){
        if (!_level._checkCollision(_checkX, --_checkY, this)){
          _checkY = currentY;
          if ((targetY - --_checkY).abs() < _currentDistanceY)
            return Directions.UP;
        }
        _checkY = currentY;

        if (!_level._checkCollision(--_checkX, _checkY, this)){
          _checkX = currentX;
          if ((targetX - --_checkX).abs() < _currentDistanceX)
            return Directions.LEFT;

        }
        _checkX = currentX;

        if (!_level._checkCollision(++_checkX, _checkY, this)){
          _checkX = currentX;
          if ((targetX - ++_checkX).abs() < _currentDistanceX)
            return Directions.RIGHT;
        }
        _checkX = currentX;
      }

      if (previouDirection != Directions.UP && _possibleDown){
        if (!_level._checkCollision(_checkX, ++_checkY, this)){
          _checkY = currentY;
          if ((targetY - ++_checkY).abs() < _currentDistanceY){
            if (_currentDistanceY > _currentDistanceX)
              return Directions.DOWN;
          }
        }
        _checkY = currentY;

        if (!_level._checkCollision(--_checkX, _checkY, this)){
          _checkX = currentX;
          if ((targetX - --_checkX).abs() < _currentDistanceX)
            return Directions.LEFT;
        }
        _checkX = currentX;

        if (!_level._checkCollision(++_checkX, _checkY, this)){
          _checkX = currentX;
          if ((targetX - ++_checkX).abs() < _currentDistanceX)
            return Directions.RIGHT;
        }
        _checkX = currentX;

        if (!_level._checkCollision(_checkX, ++_checkY, this)){
          _checkY = currentY;
          if ((targetY - ++_checkY).abs() < _currentDistanceY)
            return Directions.DOWN;
        }
        _checkY = currentY;
      }

      if (previouDirection != Directions.RIGHT && _possibleLeft) {
        if ((targetX - --_checkX).abs() < _currentDistanceX) {
          if (!_level._checkCollision(--_checkX, _checkY, this)) {
            _checkX = currentX;
            if ((targetX - --_checkX).abs() < _currentDistanceX)
              return Directions.LEFT;
          }
          _checkX = currentX;

          if (!_level._checkCollision(_checkX, ++_checkY, this)) {
            _checkY = currentY;
            if (previouDirection != Directions.UP
                && (targetY - ++_checkY).abs() < _currentDistanceY)
              return Directions.DOWN;
          }
          _checkY = currentY;

          if (!_level._checkCollision(_checkX, --_checkY, this)) {
            _checkY = currentY;
            if ((targetY - --_checkY).abs() < _currentDistanceY)
              return Directions.UP;

          }
          _checkY = currentY;
        }
      }
        if (previouDirection != Directions.LEFT && _possibleRight){
          if (!_level._checkCollision(++_checkX, _checkY, this)){
            _checkX = currentX;
            if ((targetX - ++_checkX) < _currentDistanceX)
              return Directions.RIGHT;

          }
          _checkX = currentX;

          if (!_level._checkCollision(_checkX, --_checkY, this)){
            _checkY = currentY;
            if ((targetY - --_checkY).abs() < _currentDistanceY)
              return Directions.UP;

          }
          _checkY = currentY;

          if (!_level._checkCollision(_checkX, ++_checkY, this)){
            _checkY = currentY;
            if ((targetY - ++_checkY).abs() < _currentDistanceY)
              return Directions.DOWN;
          }
          _checkY = currentY;
        }
    }

    /**
     * Checks for next Direction with priority of moving vertically first
     */
    if (_isVerticalMoreImportant) {
      if (previouDirection == Directions.UP) {
        if (!_level._checkCollision(--_checkX, _checkY, this)) {
          _checkX = currentX;
          return Directions.LEFT;
        }
        _checkX = currentX;

        if (!_level._checkCollision(_checkX, --_checkY, this)) {
          _checkY = currentY;
          return Directions.UP;
        }
        _checkY = currentY;

        if (!_level._checkCollision(++_checkX, _checkY, this))
          return Directions.RIGHT;
        _checkX = currentX;

        return Directions.NOTHING;
      }

      if (previouDirection == Directions.DOWN) {
        if (!_level._checkCollision(_checkX, ++_checkY, this)) {
          _checkY = currentY;
          return Directions.DOWN;
        }
        _checkY = currentY;

        if (!_level._checkCollision(--_checkX, _checkY, this)) {
          _checkX = currentX;
          return Directions.LEFT;
        }
        _checkX = currentX;

        if (!_level._checkCollision(++_checkX, _checkY, this))
          return Directions.RIGHT;

        _checkX = currentX;
        return Directions.NOTHING;
      }

      if (previouDirection == Directions.LEFT) {
        if (!_level._checkCollision(_checkX, --_checkY, this)) {
          _checkY = currentY;
          return Directions.UP;
        }
        _checkY = currentY;

        if (!_level._checkCollision(_checkX, ++_checkY, this)) {
          _checkY = currentY;
          return Directions.DOWN;
        }
        _checkY = currentY;

        if (!_level._checkCollision(--_checkX, _checkY, this))
          return Directions.LEFT;

        _checkX = currentX;
        return Directions.NOTHING;
      }

      if (previouDirection == Directions.RIGHT) {
        if (!_level._checkCollision(_checkX, --_checkY, this)) {
          _checkY = currentY;
          return Directions.UP;
        }
        _checkY = currentY;

        if (!_level._checkCollision(_checkX, ++_checkY, this)) {
          _checkY = currentY;
          return Directions.DOWN;
        }
        _checkY = currentY;

        if (!_level._checkCollision(++_checkX, _checkY, this))
          return Directions.RIGHT;
        _checkX = currentX;

        return Directions.NOTHING;
      }
    }
    /**
     * Checks for next Direction with priority of moving horizontally first
     */
    else {
      if (previouDirection == Directions.LEFT) {
        if (!_level._checkCollision(--_checkX, _checkY, this)) {
          _checkX = currentX;
          return Directions.LEFT;
        }
        _checkX = currentX;

        if (!_level._checkCollision(_checkX, --_checkY, this)) {
          _checkY = currentY;
          return Directions.UP;
        }
        _checkY = currentY;

        if (!_level._checkCollision(_checkX, ++_checkY, this))
          return Directions.DOWN;
        _checkY = currentY;

        return Directions.NOTHING;
      }

      if (previouDirection == Directions.RIGHT) {
        if (!_level._checkCollision(++_checkX, _checkY, this)) {
          _checkX = currentX;
          return Directions.RIGHT;
        }
        _checkX = currentX;

        if (!_level._checkCollision(_checkX, --_checkY, this)) {
          _checkY = currentY;
          return Directions.UP;
        }
        _checkX = currentX;

        if (!_level._checkCollision(_checkX, ++_checkY, this))
          return Directions.DOWN;
        _checkY = currentY;

        return Directions.NOTHING;
      }

      if (previouDirection == Directions.UP) {
        if (!_level._checkCollision(--_checkX, _checkY, this)) {
          _checkX = currentX;
          return Directions.LEFT;
        }
        _checkX = currentX;

        if (!_level._checkCollision(++_checkX, _checkY, this)) {
          _checkX = currentX;
          return Directions.RIGHT;
        }
        _checkX = currentX;

        if (!_level._checkCollision(_checkX, --_checkY, this))
          return Directions.UP;
        _checkY = currentY;

        return Directions.NOTHING;
      }

      if (previouDirection == Directions.DOWN) {
        if (!_level._checkCollision(--_checkX, _checkY, this)) {
          _checkX = currentX;
          return Directions.LEFT;
        }
        _checkX = currentX;

        if (!_level._checkCollision(++_checkX, _checkY, this)) {
          _checkX = currentX;
          return Directions.RIGHT;
        }
        _checkX = currentX;

        if (!_level._checkCollision(_checkX, ++_checkY, this))
          return Directions.DOWN;
        _checkY = currentY;

        return Directions.NOTHING;
      }
    }
    return Directions.NOTHING;
  }
}
