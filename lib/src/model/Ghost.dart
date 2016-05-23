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
  Directions _savePreviousDirection = Directions.LEFT;
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

  void startScatterMode() {
    //TODO muss noch implementiert werden, Logik fehlt noch, muss ich mir noch überlegen
    scatter = true;
    int _scatterTimer = 7;

    while (_scatterTimer > 0) {
      _scatterTimer--;
    }
  }

  void stopScatter() {
    //TODO muss noch implementiert werden
    scatter = false;
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
      int currentX, int currentY, int targetX, int targetY, GameElement g) {
    if (currentX == targetX && currentY == targetY) return Directions.NOTHING;

    int _currentDistanceX = (targetX - currentX).abs();
    int _currentDistanceY = (targetY - currentY).abs();
    int _checkX = currentX;
    int _checkY = currentY;

    _possibleDirections = 0;
    _possibleDirections != 0
        ? _possibleDirections = 0
        : _possibleDirections = 0;
    _possibleUp = 0;
    _possibleDown = 0;
    _possibleLeft = 0;
    _possibleRight = 0;
    //horizontal difference from currentPosition to targetPosition
    int horDifference = currentX - targetX;
    int verDifference = currentY - targetY;

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
    print(nextDirection.toString() +
        " H " +
        preferredHorDirection.toString() +
        " V " +
        preferredVerDirection.toString() +
        " " +
        verticalMoreImportant.toString());
    //                             UP
    // print("---- START CUR " + currentX.toString() + " " + currentY.toString());
    //print("---- START CHECK " + _checkX.toString() + " " + _checkY.toString());
    if (!_level.checkCollision(_checkX, --_checkY, this)) {
      if (_previousDirection != Directions.DOWN) {
        print("HIER GEHT ES HOCH PossibleUP: " +
            _possibleUp.toString() +
            " X: " +
            _checkX.toString() +
            " Y: " +
            _checkY.toString());
        _possibleDirections++;
        _possibleUp++;
      }
    }
    _checkY = currentY;
    //print("---- ENDE CUR " + currentX.toString() + " " + currentY.toString());
    //print("---- ENDE CHECK " + _checkX.toString() + " " + _checkY.toString());

    //                             DOWN
    //print("------ BEFORE DOWN CHECK " + currentX.toString() + " " + currentY.toString());
    if (!_level.checkCollision(_checkX, ++_checkY, this)) {
      print("DOWN CHECK " + _checkX.toString() + " " + _checkY.toString());
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
            print("--- UP --- 169");
            return Directions.UP;
          }
        }
        _checkY = currentY;
        print(_possibleUp);
        if (!_level.checkCollision(--_checkX, _checkY, this)) {
          _checkX = currentX;
          if ((targetX - --_checkX).abs() < _currentDistanceX) {
            _previousDirection = Directions.LEFT;
            print("--- LEFT --- 179");
            return Directions.LEFT;
          }
        }
        _checkX = currentX;

        if (!_level.checkCollision(++_checkX, _checkY, this)) {
          _checkX = currentX;
          if ((targetX - ++_checkX).abs() < _currentDistanceX) {
            _previousDirection = Directions.RIGHT;
            print("--- RIGHT --- 185");
            // print("---- PossibleUP: " + _possibleUp.toString() + " X: " + _checkX.toString() + " Y: " + _checkY.toString());
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
              print("--- DOWN --- 189");
              return Directions.DOWN;
            }
          }
        }
        _checkY = currentY;

        if (!_level.checkCollision(--_checkX, _checkY, this)) {
          _checkX = currentX;
          if ((targetX - --_checkX).abs() < _currentDistanceX) {
            _previousDirection = Directions.LEFT;
            print("--- LEFT --- 195");
            return Directions.LEFT;
          }
        }
        _checkX = currentX;

        if (!_level.checkCollision(++_checkX, _checkY, this)) {
          _checkX = currentX;
          print("X " + _checkX.toString() + " Y " + _checkY.toString());
          if ((targetX - ++_checkX).abs() < _currentDistanceX) {
            _previousDirection = Directions.RIGHT;
            print("X " +
                _checkX.toString() +
                " Y " +
                _checkY.toString() +
                " Distance " +
                (targetX - _checkX).toString());
            print("--- RIGHT --- 201");
            return Directions.RIGHT;
          }
        }
        _checkX = currentX;

        if (!_level.checkCollision(_checkX, ++_checkY, this)) {
          _checkY = currentY;
          //if ((targetY - ++_checkY).abs() < _currentDistanceY) {
          _previousDirection = Directions.DOWN;
          print("--- DOWN --- 250");
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
              print("--- LEFT --- 214");
              return Directions.LEFT;
            }
          }
          _checkX = currentX;

          if (!_level.checkCollision(_checkX, ++_checkY, this)) {
            _checkY = currentY;
            if (_previousDirection != Directions.UP &&
                (targetY - ++_checkY).abs() < _currentDistanceY) {
              print("--- DOWN --- 220");
              _previousDirection = Directions.DOWN;
              return Directions.DOWN;
            }
          }
          _checkY = currentY;

          if (!_level.checkCollision(_checkX, --_checkY, this)) {
            _checkY = currentY;
            if ((targetY - --_checkY).abs() < _currentDistanceY) {
              print("--- UP --- 226");
              _previousDirection = Directions.UP;
              return Directions.UP;
            }
          }
          _checkY = currentY;
        }

        // go right
        if (_previousDirection != Directions.LEFT && _possibleRight == 1) {
          // print(_previousDirection.toString() + "----------DRIN");
          if (!_level.checkCollision(++_checkX, _checkY, this)) {
            _checkX = currentX;
            if ((targetX - ++_checkX) < _currentDistanceX) {
              print("--- RIGHT --- 236");
              _previousDirection = Directions.RIGHT;
              return Directions.RIGHT;
            }
          }
          _checkX = currentX;

          if (!_level.checkCollision(_checkX, --_checkY, this)) {
            _checkY = currentY;
            if ((targetY - --_checkY).abs() < _currentDistanceY) {
              print("--- UP --- 242");
              _previousDirection = Directions.UP;
              return Directions.UP;
            }
          }
          _checkY = currentY;

          if (!_level.checkCollision(_checkX, ++_checkY, this)) {
            _checkY = currentY;
            if ((targetY - ++_checkY).abs() < _currentDistanceY) {
              print("--- DOWN --- 248");
              _previousDirection = Directions.DOWN;
              return Directions.DOWN;
            }
          }
          _checkY = currentY;
        }
      }
    }
    /**TODO ---------------------------------------------------------------------
        if(nextDirection == _previousDirection)
        {
        //TODO UP OBEN
        if (nextDirection == Directions.UP)
        {
        // UP OBEN
        if (!_level.checkCollision(_checkX, --_checkY, this))
        {
        _previousDirection = Directions.UP;
        print("--- UP --- 281");
        return Directions.UP;
        }
        _checkX = currentX;
        _checkY = currentY;
        // LEFT LINKS
        if (!_level.checkCollision(--_checkX, _checkY, this))
        {
        _previousDirection = Directions.LEFT;
        print("--- LEFT --- 292");
        return Directions.LEFT;
        }
        _checkX = currentX;
        _checkY = currentY;
        // RIGHT RECHTS
        if (!_level.checkCollision(++_checkX, _checkY, this))
        {
        _previousDirection = Directions.RIGHT;
        print("--- RIGHT --- 303");
        return Directions.RIGHT;
        }
        _checkX = currentX;
        _checkY = currentY;
        return Directions.NOTHING;
        }
        // TODO DOWN UNTEN
        if (nextDirection == Directions.DOWN)
        {
        // DOWN UNTEN
        if (!_level.checkCollision(_checkX, ++_checkY, this))
        {
        _previousDirection = Directions.DOWN;
        print("--- DOWN --- 319");
        return Directions.DOWN;
        }
        _checkX = currentX;
        _checkY = currentY;
        // LEFT LINKS
        if (!_level.checkCollision(--_checkX, _checkY, this))
        {
        _previousDirection = Directions.LEFT;
        print("--- LEFT --- 330");
        return Directions.LEFT;
        }
        _checkX = currentX;
        _checkY = currentY;
        // RIGHT RECHTS
        if (!_level.checkCollision(++_checkX, _checkY, this))
        {
        _previousDirection = Directions.RIGHT;
        print("--- RIGHT --- 341");
        return Directions.RIGHT;
        }
        _checkX = currentX;
        _checkY = currentY;
        return Directions.NOTHING;
        }
        // TODO LEFT LINKS
        if (nextDirection == Directions.LEFT) {
        // LEFT LINKS
        if (!_level.checkCollision(--_checkX, _checkY, this))
        {
        _previousDirection = Directions.LEFT;
        print("--- LEFT --- 357");
        return Directions.LEFT;
        }
        _checkX = currentX;
        _checkY = currentY;
        // DOWN UNTEN
        if (!_level.checkCollision(_checkX, ++_checkY, this))
        {
        _previousDirection = Directions.DOWN;
        print("--- DOWN --- 368");
        return Directions.DOWN;
        }
        _checkX = currentX;
        _checkY = currentY;
        // UP OBEN
        if (!_level.checkCollision(_checkX, --_checkY, this))
        {
        _previousDirection = Directions.UP;
        print("--- UP --- 379");
        return Directions.UP;
        }
        _checkX = currentX;
        _checkY = currentY;
        return Directions.NOTHING;
        }
        // TODO RIGHT RECHTS
        if (nextDirection == Directions.RIGHT)
        {
        // RIGHT RECHTS
        if (!_level.checkCollision(++_checkX, _checkY, this))
        {
        _previousDirection = Directions.RIGHT;
        print("--- RIGHT --- 396");
        return Directions.RIGHT;
        }
        _checkX = currentX;
        _checkY = currentY;
        // UP OBEN
        if (!_level.checkCollision(_checkX, --_checkY, this))
        {
        _previousDirection = Directions.UP;
        print("--- UP --- 407");
        return Directions.UP;
        }
        _checkX = currentX;
        _checkY = currentY;
        // DOWN UNTEN
        if (!_level.checkCollision(_checkX, ++_checkY, this))
        {
        _previousDirection = Directions.DOWN;
        print("--- DOWN --- 418");
        return Directions.DOWN;
        }
        _checkX = currentX;
        _checkY = currentY;
        return Directions.NOTHING;
        }
        }
     **/
    //TODO --------------------------------------------------------NORMALE LOGIK LOGIK ÜBER DEM STIMMT NOCH NICHT GANZ
    if (verticalMoreImportant) {
      // TODO UP OBEN
      if (_previousDirection == Directions.UP) {
        //LEFT
        if (!_level.checkCollision(--_checkX, _checkY, this)) {
          _checkX = currentX;
          //  if((targetX - --_checkX).abs() < _currentDistanceX)
          //  {
          _previousDirection = Directions.LEFT;
          print("--- LEFT --- 441");
          return Directions.LEFT;
          //  }
        }
        _checkX = currentX;

        //UP
        if (!_level.checkCollision(_checkX, --_checkY, this)) {
          _checkY = currentY;
          if ((targetY - --_checkY).abs() < _currentDistanceY) {
            _previousDirection = Directions.UP;
            print("--- UP --- 454");
            return Directions.UP;
          }
        }
        _checkY = currentY;

        //RIGHT
        if (!_level.checkCollision(++_checkX, _checkY, this)) {
          _previousDirection = Directions.RIGHT;
          print("--- RIGHT --- 464");
          return Directions.RIGHT;
        }
        _checkX = currentX;
        return Directions.NOTHING;
      }

      // TODO DOWN UNTEN
      if (_previousDirection == Directions.DOWN) {
        //DOWN
        if (!_level.checkCollision(_checkX, ++_checkY, this)) {
          _checkY = currentY;
          if ((targetY - ++_checkY).abs() < _currentDistanceY) {
            _previousDirection = Directions.DOWN;
            print("--- DOWN --- 481");
            return Directions.DOWN;
          }
        }
        _checkY = currentY;

        //LEFT
        if (!_level.checkCollision(--_checkX, _checkY, this)) {
          _checkX = currentX;
          //if((targetX - --_checkX).abs() < _currentDistanceX)
          //{
          _previousDirection = Directions.LEFT;
          print("--- LEFT --- 494");
          return Directions.LEFT;
          //}
        }
        _checkX = currentX;

        //RIGHT
        if (!_level.checkCollision(++_checkX, _checkY, this)) {
          _previousDirection = Directions.RIGHT;
          print("--- RIGHT --- 460");
          return Directions.RIGHT;
        }
        _checkX = currentX;
        return Directions.NOTHING;
      }

      // TODO LEFT LINKS
      if (_previousDirection == Directions.LEFT) {
        //print("hier geh ich durch");
        //UP
        if (!_level.checkCollision(_checkX, --_checkY, this)) {
          _checkY = currentY;
          if ((targetY - --_checkY).abs() < _currentDistanceY) {
            _previousDirection = Directions.UP;
            print("--- UP --- 521");
            return Directions.UP;
          }
        }
        _checkY = currentY;

        //DOWN
        if (!_level.checkCollision(_checkX, ++_checkY, this)) {
          _checkY = currentY;
          if ((targetY - ++_checkY).abs() < _currentDistanceY) {
            _previousDirection = Directions.DOWN;
            print("--- DOWN --- 534");
            return Directions.DOWN;
          }
        }
        _checkY = currentY;
        // print("hier left");
        //LEFT
        if (!_level.checkCollision(--_checkX, _checkY, this)) {
          //print("check");
          _previousDirection = Directions.LEFT;
          print("--- LEFT --- 544");
          return Directions.LEFT;
        }
        _checkX = currentX;
        //  print("gammel");
        return Directions.NOTHING;
      }

      // TODO RIGHT RECHTS
      if (_previousDirection == Directions.RIGHT) {
        //UP
        if (!_level.checkCollision(_checkX, --_checkY, this)) {
          _checkY = currentY;
          if ((targetY - --_checkY).abs() < _currentDistanceY) {
            _previousDirection = Directions.UP;
            print("--- UP --- 566");
            return Directions.UP;
          }
        }
        _checkY = currentY;

        //DOWN
        if (!_level.checkCollision(_checkX, ++_checkY, this)) {
          _checkY = currentY;
          if ((targetY - ++_checkY).abs() < _currentDistanceY) {
            _previousDirection = Directions.DOWN;
            print("--- DOWN --- 579");
            return Directions.DOWN;
          }
        }
        _checkY = currentY;

        //RIGHT
        if (!_level.checkCollision(++_checkX, _checkY, this)) {
          _previousDirection = Directions.RIGHT;
          print("--- RIGHT --- 578");
          return Directions.RIGHT;
        }
        _checkX = currentX;
        return Directions.NOTHING;
      }
    }
    // TODO ----------------------------------------------------------ELSE LOGIK
    else {
      //  if(g is Blinky || g is Inky //TODO    WIE SOLL ICH SAGEN EINMALIG DAS BLINKY UND INKY VON RECHTS KAMEN)

      // TODO LEFT LINKS
      if (_previousDirection == Directions.LEFT) {
        //print("ELSE LEFT");
        //LEFT
        if (!_level.checkCollision(--_checkX, _checkY, this)) {
          //print("eig hier");
          _checkX = currentX;
          //  if((targetX - --_checkX).abs() < _currentDistanceX)
          //  {
          _previousDirection = Directions.LEFT;
          print("--- LEFT --- 606");
          return Directions.LEFT;
          // }
        }
        _checkX = currentX;

        //UP
        if (!_level.checkCollision(_checkX, --_checkY, this)) {
          //print("warum hier");
          _checkY = currentY;
          //  if((targetY - --_checkY).abs() < _currentDistanceY)
          //  {
          _previousDirection = Directions.UP;
          print("--- UP --- 619");
          return Directions.UP;
          //  }
        }
        _checkY = currentY;

        //DOWN
        if (!_level.checkCollision(_checkX, ++_checkY, this)) {
          //print("oder hier?");
          _previousDirection = Directions.DOWN;
          print("--- DOWN --- 621");
          return Directions.DOWN;
        }
        _checkY = currentY;
        return Directions.NOTHING;
      }

      // TODO RIGHT RECHTS
      if (_previousDirection == Directions.RIGHT) {
        //print("ELSE RECHTS");
        //RIGHT
        if (!_level.checkCollision(++_checkX, _checkY, this)) {
          _checkX = currentX;
          //if((targetX - ++_checkX).abs() < _currentDistanceX)
          //{
          _previousDirection = Directions.RIGHT;
          print("--- RIGHT --- 646");
          return Directions.RIGHT;
          //}
        }
        _checkX = currentX;

        //UP
        if (!_level.checkCollision(_checkX, --_checkY, this)) {
          _checkY = currentY;
          // if((targetY - --_checkY).abs() < _currentDistanceY)
          // {
          _previousDirection = Directions.UP;
          print("--- UP --- 659");
          return Directions.UP;
          // }
        }
        _checkX = currentX;

        //DOWN
        if (!_level.checkCollision(_checkX, ++_checkY, this)) {
          _previousDirection = Directions.DOWN;
          print("--- DOWN --- 661");
          return Directions.DOWN;
        }
        _checkY = currentY;
        return Directions.NOTHING;
      }

      // TODO UP OBEN
      if (_previousDirection == Directions.UP) {
        print("ELSE UP");
        //LEFT
        if (!_level.checkCollision(--_checkX, _checkY, this)) {
          _checkX = currentX;
          if ((targetX - --_checkX).abs() < _currentDistanceX) {
            _previousDirection = Directions.LEFT;
            print("--- LEFT --- 686");
            return Directions.LEFT;
          }
          //print("LOGIK FEHLER " + (targetX - --_checkX).abs().toString() + " und " +_currentDistanceX.toString());
        }
        _checkX = currentX;

        //RIGHT
        if (!_level.checkCollision(++_checkX, _checkY, this)) {
          _checkX = currentX;
          if ((targetX - ++_checkX).abs() < _currentDistanceX) {
            _previousDirection = Directions.RIGHT;
            print("--- RIGHT --- 700");
            return Directions.RIGHT;
          }
        }
        _checkX = currentX;

        // UP
        if (!_level.checkCollision(_checkX, --_checkY, this)) {
          _previousDirection = Directions.UP;
          print("--- UP --- 710");
          return Directions.UP;
        }
        _checkY = currentY;
        return Directions.NOTHING;
      }

      // TODO DOWN UNTEN
      if (_previousDirection == Directions.DOWN) {
        //print("ELSE DOWN");
        //LEFT
        if (!_level.checkCollision(--_checkX, _checkY, this)) {
          _checkX = currentX;
          if ((targetX - --_checkX).abs() < _currentDistanceX) {
            _previousDirection = Directions.LEFT;
            print("--- LEFT --- 727");
            return Directions.LEFT;
          }
        }
        _checkX = currentX;

        //RIGHT
        if (!_level.checkCollision(++_checkX, _checkY, this)) {
          _checkX = currentX;
          if ((targetX - ++_checkX).abs() < _currentDistanceX) {
            _previousDirection = Directions.RIGHT;
            print("--- RIGHT --- 740");
            return Directions.RIGHT;
          }
        }
        _checkX = currentX;

        //DOWN
        if (!_level.checkCollision(_checkX, ++_checkY, this)) {
          _previousDirection = Directions.DOWN;
          print("--- DOWN --- 748");
          return Directions.DOWN;
        }
        _checkY = currentY;
        return Directions.NOTHING;
      }
    }

    /**
        if(verticalMoreImportant)
        {
        if(nextDirection == _previousDirection)
        {
        // NEXT UP PREVIOUS UP
        if (nextDirection == Directions.UP)
        {
        if (!_level.checkCollision(currentX, --currentY, this)){
        _previousDirection = Directions.UP;
        return Directions.UP;
        }
        nextDirection = Directions.LEFT;
        if (!_level.checkCollision(--currentX, currentY, this)) {
        _previousDirection = Directions.LEFT;
        return Directions.LEFT;
        }
        nextDirection = Directions.RIGHT;
        if (!_level.checkCollision(++currentX, currentY, this))  {
        _previousDirection = Directions.RIGHT;
        return Directions.RIGHT;
        }
        nextDirection = Directions.DOWN;
        if (!_level.checkCollision(currentX, ++currentY, this)){
        _previousDirection = Directions.DOWN;
        return Directions.DOWN;
        }
        }
        // NEXT DOWN PREVIOUS DOWN
        if (nextDirection == Directions.DOWN)
        {
        if(!_level.checkCollision(currentX, ++currentY, this)) {
        _previousDirection = Directions.DOWN;
        return Directions.DOWN;
        }
        nextDirection = Directions.LEFT;
        if(!_level.checkCollision(--currentX, currentY, this)) {
        _previousDirection = Directions.LEFT;
        return Directions.LEFT;
        }
        nextDirection = Directions.RIGHT;
        if(!_level.checkCollision(++currentX, currentY, this)) {
        _previousDirection = Directions.RIGHT;
        return Directions.RIGHT;
        }
        nextDirection = Directions.UP;
        if(!_level.checkCollision(currentX, --currentY, this)){
        _previousDirection = Directions.UP;
        return Directions.UP;
        }
        }
        }
        // NEXT UP PREVIOUS DOWN
        if(nextDirection == Directions.UP && _previousDirection == Directions.DOWN)
        {
        nextDirection = Directions.LEFT;
        if(!_level.checkCollision(--currentX, currentY, this))  {
        _previousDirection = Directions.LEFT;
        return Directions.LEFT;
        }
        nextDirection = Directions.DOWN;
        if(!_level.checkCollision(currentX, ++currentY, this)){
        _previousDirection = Directions.DOWN;
        return Directions.DOWN;
        }
        nextDirection = Directions.RIGHT;
        if(!_level.checkCollision(++currentX, currentY, this)){
        _previousDirection = Directions.RIGHT;
        return Directions.RIGHT;
        }
        nextDirection = Directions.UP;
        if(!_level.checkCollision(currentX, --currentY, this)){
        _previousDirection = Directions.UP;
        return Directions.UP;
        }
        }
        // NEXT UP PREVIOUS LEFT
        if(nextDirection == Directions.UP && _previousDirection == Directions.LEFT)
        {
        nextDirection = Directions.UP;
        if(!_level.checkCollision(currentX, --currentY, this)){
        _previousDirection = Directions.UP;
        return Directions.UP;
        }
        //TODO er geht nach Oben obwohl er das nicht darf bzw obwohl da eine Kollision ist
        nextDirection = Directions.LEFT;
        if(!_level.checkCollision(--currentX, currentY, this)) {
        _previousDirection = Directions.LEFT;
        return Directions.LEFT;
        }
        nextDirection = Directions.DOWN;
        if(!_level.checkCollision(currentX, ++currentY, this)) {
        _previousDirection = Directions.DOWN;
        return Directions.DOWN;
        }
        nextDirection = Directions.RIGHT;
        if(!_level.checkCollision(++currentX, currentY, this)) {
        _previousDirection = Directions.RIGHT;
        return Directions.RIGHT;
        }
        }
        // NEXT UP PREVIOUS RIGHT
        if(nextDirection == Directions.UP && _previousDirection == Directions.RIGHT)
        {
        nextDirection = Directions.UP;
        if(!_level.checkCollision(currentX, --currentY, this)) {
        _previousDirection = Directions.UP;
        return Directions.UP;
        }
        nextDirection = Directions.DOWN;
        if(!_level.checkCollision(currentX, ++currentY, this)) {
        _previousDirection = Directions.DOWN;
        return Directions.DOWN;
        }
        nextDirection = Directions.RIGHT;
        if(!_level.checkCollision(++currentX, currentY, this)) {
        _previousDirection = Directions.RIGHT;
        return Directions.RIGHT;
        }
        nextDirection = Directions.LEFT;
        if(!_level.checkCollision(--currentX, currentY, this))  {
        _previousDirection = Directions.LEFT;
        return Directions.LEFT;
        }
        }
        // NEXT DOWN PREVIOUS UP
        if(nextDirection == Directions.DOWN && _previousDirection == Directions.UP)
        {
        nextDirection = Directions.LEFT;
        if(!_level.checkCollision(--currentX, currentY, this))  {
        _previousDirection = Directions.LEFT;
        return Directions.LEFT;
        }
        nextDirection = Directions.RIGHT;
        if(!_level.checkCollision(++currentX, currentY, this)){
        _previousDirection = Directions.RIGHT;
        return Directions.RIGHT;
        }
        nextDirection = Directions.DOWN;
        if(!_level.checkCollision(currentX, ++currentY, this)) {
        _previousDirection = Directions.DOWN;
        return Directions.DOWN;
        }
        nextDirection = Directions.UP;
        if(!_level.checkCollision(currentX, --currentY, this)) {
        _previousDirection = Directions.UP;
        return Directions.UP;
        }
        }
        // NEXT DOWN PREVIOUS LEFT
        if(nextDirection == Directions.DOWN && _previousDirection == Directions.LEFT)
        {
        nextDirection = Directions.DOWN;
        if(!_level.checkCollision(currentX, ++currentY, this)) {
        _previousDirection = Directions.DOWN;
        return Directions.DOWN;
        }
        nextDirection = Directions.LEFT;
        if(!_level.checkCollision(--currentX, currentY, this)) {
        _previousDirection = Directions.LEFT;
        return Directions.LEFT;
        }
        nextDirection = Directions.RIGHT;
        if(!_level.checkCollision(++currentX, currentY, this)) {
        _previousDirection = Directions.RIGHT;
        return Directions.RIGHT;
        }
        //TODO Fehler das er obwohl ne wand ist runter gegangen ist ausgemerzt
        return Directions.NOTHING;
        /**nextDirection = Directions.UP;
        if(!_level.checkCollision(currentX, --currentY, this)) {
        return Directions.UP;
        }**/
        }

        // NEXT DOWN PREVIOUS RIGHT
        if(nextDirection == Directions.DOWN && _previousDirection == Directions.RIGHT)
        {
        nextDirection = Directions.DOWN;
        if(!_level.checkCollision(currentX, ++currentY, this)) {
        _previousDirection = Directions.DOWN;
        return Directions.DOWN;
        }

        nextDirection = Directions.UP;
        if(!_level.checkCollision(currentX, --currentY, this)){
        _previousDirection = Directions.UP;
        return Directions.UP;
        }

        nextDirection = Directions.RIGHT;
        if(!_level.checkCollision(++currentX, currentY, this)) {
        _previousDirection = Directions.RIGHT;
        return Directions.RIGHT;
        }

        nextDirection = Directions.LEFT;
        if(!_level.checkCollision(--currentX, currentY, this)) {
        _previousDirection = Directions.LEFT;
        return Directions.LEFT;
        }
        }

        return Directions.NOTHING;
        }
        else
        {
        if(nextDirection == _previousDirection)
        {
        // NEXT LEFT PREVIOUS LEFT
        if (nextDirection == Directions.LEFT)
        {
        if (!_level.checkCollision(--currentX, currentY, this)) {
        _previousDirection = Directions.LEFT;
        return Directions.LEFT;
        }

        //TODO hier geht er nach oben obwohl er nicht darf wegen Kollision
        nextDirection = Directions.UP;
        if(!_level.checkCollision(currentX, --currentY, this)) {
        _previousDirection = Directions.UP;
        return Directions.UP;
        }

        nextDirection = Directions.DOWN;
        if (!_level.checkCollision(currentX, ++currentY, this)){
        _previousDirection = Directions.DOWN;
        return Directions.DOWN;
        }
        }

        // NEXT RIGHT PREVIOUS RIGHT
        if (nextDirection == Directions.RIGHT)
        {
        if(!_level.checkCollision(++currentX, currentY, this)) {
        _previousDirection = Directions.RIGHT;
        return Directions.RIGHT;
        }

        nextDirection = Directions.UP;
        if(!_level.checkCollision(currentX, --currentY, this)){
        _previousDirection = Directions.UP;
        return Directions.UP;
        }

        nextDirection = Directions.DOWN;
        if(!_level.checkCollision(currentX, ++currentY, this)){
        _previousDirection = Directions.DOWN;
        return Directions.DOWN;
        }

        nextDirection = Directions.LEFT;
        if(!_level.checkCollision(--currentX, currentY, this)) {
        _previousDirection = Directions.LEFT;
        return Directions.LEFT;
        }
        }
        }

        // NEXT LEFT PREVIOUS UP
        if(nextDirection == Directions.LEFT && _previousDirection == Directions.UP)
        {
        nextDirection = Directions.LEFT;
        if(!_level.checkCollision(--currentX, currentY, this))  {
        _previousDirection = Directions.LEFT;
        return Directions.LEFT;
        }

        nextDirection = Directions.UP;
        if(!_level.checkCollision(currentX, --currentY, this)) {
        _previousDirection = Directions.UP;
        return Directions.UP;
        }

        nextDirection = Directions.RIGHT;
        if(!_level.checkCollision(++currentX, currentY, this)) {
        _previousDirection = Directions.RIGHT;
        return Directions.RIGHT;
        }

        nextDirection = Directions.DOWN;
        if(!_level.checkCollision(currentX, ++currentY, this)){
        _previousDirection = Directions.DOWN;
        return Directions.DOWN;
        }
        }

        // NEXT LEFT PREVIOUS DOWN
        if(nextDirection == Directions.LEFT && _previousDirection == Directions.DOWN)
        {
        nextDirection = Directions.LEFT;
        if(!_level.checkCollision(--currentX, currentY, this)) {
        _previousDirection = Directions.LEFT;
        return Directions.LEFT;
        }

        nextDirection = Directions.DOWN;
        if(!_level.checkCollision(currentX, ++currentY, this)){
        _previousDirection = Directions.DOWN;
        return Directions.DOWN;
        }

        nextDirection = Directions.RIGHT;
        if(!_level.checkCollision(++currentX, currentY, this)) {
        _previousDirection = Directions.RIGHT;
        return Directions.RIGHT;
        }

        nextDirection = Directions.UP;
        if(!_level.checkCollision(currentX, --currentY, this)) {
        _previousDirection = Directions.UP;
        return Directions.UP;
        }
        }

        // NEXT LEFT PREVIOUS RIGHT
        if(nextDirection == Directions.LEFT && _previousDirection == Directions.RIGHT)
        {
        nextDirection = Directions.UP;
        if(!_level.checkCollision(currentX, --currentY, this)){
        _previousDirection = Directions.UP;
        return Directions.UP;
        }

        nextDirection = Directions.DOWN;
        if(!_level.checkCollision(currentX, ++currentY, this)) {
        _previousDirection = Directions.DOWN;
        return Directions.DOWN;
        }
        nextDirection = Directions.RIGHT;
        if(!_level.checkCollision(++currentX, currentY, this)) {
        _previousDirection = Directions.RIGHT;
        return Directions.RIGHT;
        }

        nextDirection = Directions.LEFT;
        if(!_level.checkCollision(--currentX, currentY, this))  {
        _previousDirection = Directions.LEFT;
        return Directions.LEFT;
        }
        }

        // NEXT RIGHT PREVIOUS UP
        if(nextDirection == Directions.RIGHT && _previousDirection == Directions.UP)
        {
        nextDirection = Directions.RIGHT;
        if(!_level.checkCollision(++currentX, currentY, this)) {
        _previousDirection = Directions.DOWN;
        return Directions.RIGHT;
        }

        nextDirection = Directions.UP;
        if(!_level.checkCollision(currentX, --currentY, this)) {
        _previousDirection = Directions.UP;
        return Directions.UP;
        }

        nextDirection = Directions.LEFT;
        if(!_level.checkCollision(--currentX, currentY, this))  {
        _previousDirection = Directions.LEFT;
        return Directions.LEFT;
        }

        nextDirection = Directions.DOWN;
        if(!_level.checkCollision(currentX, ++currentY, this)) {
        _previousDirection = Directions.DOWN;
        return Directions.DOWN;
        }
        }

        // NEXT RIGHT PREVIOUS DOWN
        if(nextDirection == Directions.RIGHT && _previousDirection == Directions.DOWN)
        {
        nextDirection = Directions.RIGHT;
        if(!_level.checkCollision(++currentX, currentY, this)) {
        _previousDirection = Directions.RIGHT;
        return Directions.RIGHT;
        }

        nextDirection = Directions.DOWN;
        if(!_level.checkCollision(currentX, ++currentY, this)){
        _previousDirection = Directions.DOWN;
        return Directions.DOWN;
        }

        nextDirection = Directions.LEFT;
        if(!_level.checkCollision(--currentX, currentY, this))  {
        _previousDirection = Directions.LEFT;
        return Directions.LEFT;
        }

        nextDirection = Directions.UP;
        if(!_level.checkCollision(currentX, --currentY, this)){
        _previousDirection = Directions.UP;
        return Directions.UP;
        }
        }

        // NEXT RIGHT PREVIOUS LEFT
        if(nextDirection == Directions.RIGHT && _previousDirection == Directions.LEFT)
        {
        nextDirection = Directions.UP;
        if(!_level.checkCollision(currentX, --currentY, this)) {
        _previousDirection = Directions.UP;
        return Directions.UP;
        }

        //TODO er geht runter obwohl hier eine Kollision besteht
        nextDirection = Directions.DOWN;
        if(!_level.checkCollision(currentX, ++currentY, this)) {
        _previousDirection = Directions.DOWN;
        return Directions.DOWN;
        }

        nextDirection = Directions.LEFT;
        if(!_level.checkCollision(--currentX, currentY, this))  {
        _previousDirection = Directions.LEFT;
        return Directions.LEFT;
        }

        nextDirection = Directions.RIGHT;
        if(!_level.checkCollision(++currentX, currentY, this)) {
        _previousDirection = Directions.RIGHT;
        return Directions.RIGHT;
        }
        }

        return Directions.NOTHING;
        }
     **/
  }
}

/**
 * returnToHome, ScatterMode, Frightened Mode
 * alles in die Ghost kommen und die Geister selben haben nur ihre
 * individuelle Chase/Verfolger Methode und je nach Geist komplex
 *
 * UP -> LEFT -> DOWN
 *
 *
 * WENN ES MÖGLICH SIT DAS MAN ZWEI WEGE GEHEN KANN ... DANN GUCK OB WENN ICH NACH OBEN GEHEN DER Y/X-WERT SICH VERRINGERT
 * FALLS JA DANN GEH DAHIN
 **/
