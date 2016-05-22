part of pacmanLib;

abstract class Ghost extends GameElement {
  final _x_start, _y_start;
  bool _eatable = false;
  bool scatter;
  Directions nextDirection;
  Directions _previousDirection = Directions.LEFT;
  Directions _savePreviousDirection = Directions.LEFT;
  int _ghostsEaten = 0;
  int _eatTime;
  int _eatTimeCounter = 0;
  Level _level;

  Ghost(int x, int y, bool collPlayer, bool collGhost, Level l, num eatTime)
      : super(x, y, collPlayer, collGhost),
        this._level = l,
        this._eatTime = eatTime,
        this._x_start = x,
        this._y_start = y;

  void move() {
    if(_eatable) {
      _eatTimeCounter++;
      if (_eatTimeCounter == _eatTime) {
        _eatable = false;
        _eatTimeCounter = 0;
      }
    }
  }
  void eatableMode() {
    _eatable = true;
  }

  void respwan() {
    _eatable = false;
    _x = _x_start;
    _y = _y_start;
  }

  /**
      void setDirection(Directions dir)
      {
      _previousDirection = nextDirection;
      nextDirection = dir;
      }
   **/

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

  //as param give the ghost to be respawned
  void respawn(Dynamics ghost) {
    //TODO muss noch geklärt werden auf wessen seite das passiert auf meiner oder der von niklas
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

  Directions getNextMove(
      int currentX, int currentY, int targetX, int targetY, GameElement g) {
    if (currentX == targetX && currentY == targetY) return Directions.NOTHING;
    //horizontal difference from currentPosition to targetPosition
    int horDifference = currentX - targetX;
    int verDifference = currentY - targetY;

    //preferred direction considering the difference     UP-> LEFT-> DOWN
    Directions preferredHorDirection =
        horDifference > 0 ? Directions.LEFT : Directions.RIGHT;
    Directions preferredVerDirection =
        verDifference > 0 ? Directions.UP : Directions.DOWN;

    //checks if the vertical difference is greater than the horizontal
    bool verticalMoreImportant = verDifference.abs() > horDifference.abs();

        //sets next preferred direction
        verticalMoreImportant
        ? nextDirection = preferredVerDirection
        : nextDirection = preferredHorDirection;

    if (verticalMoreImportant) {
      if (nextDirection == _previousDirection) {
        // NEXT UP PREVIOUS UP
        if (nextDirection == Directions.UP) {
          if (!_level.checkCollision(currentX, --currentY, this)) {
            _previousDirection = Directions.UP;
            return Directions.UP;
          }

          nextDirection = Directions.LEFT;
          if (!_level.checkCollision(--currentX, currentY, this)) {
            _previousDirection = Directions.LEFT;
            return Directions.LEFT;
          }

          nextDirection = Directions.RIGHT;
          if (!_level.checkCollision(++currentX, currentY, this)) {
            _previousDirection = Directions.RIGHT;
            return Directions.RIGHT;
          }

          nextDirection = Directions.DOWN;
          if (!_level.checkCollision(currentX, ++currentY, this)) {
            _previousDirection = Directions.DOWN;
            return Directions.DOWN;
          }
        }

        // NEXT DOWN PREVIOUS DOWN
        if (nextDirection == Directions.DOWN) {
          if (!_level.checkCollision(currentX, ++currentY, this)) {
            _previousDirection = Directions.DOWN;
            return Directions.DOWN;
          }

          nextDirection = Directions.LEFT;
          if (!_level.checkCollision(--currentX, currentY, this)) {
            _previousDirection = Directions.LEFT;
            return Directions.LEFT;
          }

          nextDirection = Directions.RIGHT;
          if (!_level.checkCollision(++currentX, currentY, this)) {
            _previousDirection = Directions.RIGHT;
            return Directions.RIGHT;
          }

          nextDirection = Directions.UP;
          if (!_level.checkCollision(currentX, --currentY, this)) {
            _previousDirection = Directions.UP;
            return Directions.UP;
          }
        }
      }
      // NEXT UP PREVIOUS DOWN
      if (nextDirection == Directions.UP &&
          _previousDirection == Directions.DOWN) {
        nextDirection = Directions.LEFT;
        if (!_level.checkCollision(--currentX, currentY, this)) {
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }

        nextDirection = Directions.DOWN;
        if (!_level.checkCollision(currentX, ++currentY, this)) {
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }

        nextDirection = Directions.RIGHT;
        if (!_level.checkCollision(++currentX, currentY, this)) {
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }

        nextDirection = Directions.UP;
        if (!_level.checkCollision(currentX, --currentY, this)) {
          _previousDirection = Directions.UP;
          return Directions.UP;
        }
      }

      // NEXT UP PREVIOUS LEFT
      if (nextDirection == Directions.UP &&
          _previousDirection == Directions.LEFT) {
        nextDirection = Directions.UP;
        if (!_level.checkCollision(currentX, --currentY, this)) {
          _previousDirection = Directions.UP;
          return Directions.UP;
        }

        //TODO er geht nach Oben obwohl er das nicht darf bzw obwohl da eine Kollision ist
        nextDirection = Directions.LEFT;
        if (!_level.checkCollision(--currentX, currentY, this)) {
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }

        nextDirection = Directions.DOWN;
        if (!_level.checkCollision(currentX, ++currentY, this)) {
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }

        nextDirection = Directions.RIGHT;
        if (!_level.checkCollision(++currentX, currentY, this)) {
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }
      }

      // NEXT UP PREVIOUS RIGHT
      if (nextDirection == Directions.UP &&
          _previousDirection == Directions.RIGHT) {
        nextDirection = Directions.UP;
        if (!_level.checkCollision(currentX, --currentY, this)) {
          _previousDirection = Directions.UP;
          return Directions.UP;
        }

        nextDirection = Directions.DOWN;
        if (!_level.checkCollision(currentX, ++currentY, this)) {
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }

        nextDirection = Directions.RIGHT;
        if (!_level.checkCollision(++currentX, currentY, this)) {
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }

        nextDirection = Directions.LEFT;
        if (!_level.checkCollision(--currentX, currentY, this)) {
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }
      }

      // NEXT DOWN PREVIOUS UP
      if (nextDirection == Directions.DOWN &&
          _previousDirection == Directions.UP) {
        nextDirection = Directions.LEFT;
        if (!_level.checkCollision(--currentX, currentY, this)) {
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }

        nextDirection = Directions.RIGHT;
        if (!_level.checkCollision(++currentX, currentY, this)) {
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }

        nextDirection = Directions.DOWN;
        if (!_level.checkCollision(currentX, ++currentY, this)) {
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }

        nextDirection = Directions.UP;
        if (!_level.checkCollision(currentX, --currentY, this)) {
          _previousDirection = Directions.UP;
          return Directions.UP;
        }
      }

      // NEXT DOWN PREVIOUS LEFT
      if (nextDirection == Directions.DOWN &&
          _previousDirection == Directions.LEFT) {
        nextDirection = Directions.DOWN;
        if (!_level.checkCollision(currentX, ++currentY, this)) {
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }

        nextDirection = Directions.LEFT;
        if (!_level.checkCollision(--currentX, currentY, this)) {
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }

        nextDirection = Directions.RIGHT;
        if (!_level.checkCollision(++currentX, currentY, this)) {
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
      if (nextDirection == Directions.DOWN &&
          _previousDirection == Directions.RIGHT) {
        nextDirection = Directions.DOWN;
        if (!_level.checkCollision(currentX, ++currentY, this)) {
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }

        nextDirection = Directions.UP;
        if (!_level.checkCollision(currentX, --currentY, this)) {
          _previousDirection = Directions.UP;
          return Directions.UP;
        }

        nextDirection = Directions.RIGHT;
        if (!_level.checkCollision(++currentX, currentY, this)) {
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }

        nextDirection = Directions.LEFT;
        if (!_level.checkCollision(--currentX, currentY, this)) {
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }
      }

      return Directions.NOTHING;
    } else {
      if (nextDirection == _previousDirection) {
        // NEXT LEFT PREVIOUS LEFT
        if (nextDirection == Directions.LEFT) {
          if (!_level.checkCollision(--currentX, currentY, this)) {
            _previousDirection = Directions.LEFT;
            return Directions.LEFT;
          }

          //TODO hier geht er nach oben obwohl er nicht darf wegen Kollision
          nextDirection = Directions.UP;
          if (!_level.checkCollision(currentX, --currentY, this)) {
            _previousDirection = Directions.UP;
            return Directions.UP;
          }

          nextDirection = Directions.DOWN;
          if (!_level.checkCollision(currentX, ++currentY, this)) {
            _previousDirection = Directions.DOWN;
            return Directions.DOWN;
          }
        }

        // NEXT RIGHT PREVIOUS RIGHT
        if (nextDirection == Directions.RIGHT) {
          if (!_level.checkCollision(++currentX, currentY, this)) {
            _previousDirection = Directions.RIGHT;
            return Directions.RIGHT;
          }

          nextDirection = Directions.UP;
          if (!_level.checkCollision(currentX, --currentY, this)) {
            _previousDirection = Directions.UP;
            return Directions.UP;
          }

          nextDirection = Directions.DOWN;
          if (!_level.checkCollision(currentX, ++currentY, this)) {
            _previousDirection = Directions.DOWN;
            return Directions.DOWN;
          }

          nextDirection = Directions.LEFT;
          if (!_level.checkCollision(--currentX, currentY, this)) {
            _previousDirection = Directions.LEFT;
            return Directions.LEFT;
          }
        }
      }

      // NEXT LEFT PREVIOUS UP
      if (nextDirection == Directions.LEFT &&
          _previousDirection == Directions.UP) {
        nextDirection = Directions.LEFT;
        if (!_level.checkCollision(--currentX, currentY, this)) {
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }

        nextDirection = Directions.UP;
        if (!_level.checkCollision(currentX, --currentY, this)) {
          _previousDirection = Directions.UP;
          return Directions.UP;
        }

        nextDirection = Directions.RIGHT;
        if (!_level.checkCollision(++currentX, currentY, this)) {
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }

        nextDirection = Directions.DOWN;
        if (!_level.checkCollision(currentX, ++currentY, this)) {
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }
      }

      // NEXT LEFT PREVIOUS DOWN
      if (nextDirection == Directions.LEFT &&
          _previousDirection == Directions.DOWN) {
        nextDirection = Directions.LEFT;
        if (!_level.checkCollision(--currentX, currentY, this)) {
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }

        nextDirection = Directions.DOWN;
        if (!_level.checkCollision(currentX, ++currentY, this)) {
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }

        nextDirection = Directions.RIGHT;
        if (!_level.checkCollision(++currentX, currentY, this)) {
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }

        nextDirection = Directions.UP;
        if (!_level.checkCollision(currentX, --currentY, this)) {
          _previousDirection = Directions.UP;
          return Directions.UP;
        }
      }

      // NEXT LEFT PREVIOUS RIGHT
      if (nextDirection == Directions.LEFT &&
          _previousDirection == Directions.RIGHT) {
        nextDirection = Directions.UP;
        if (!_level.checkCollision(currentX, --currentY, this)) {
          _previousDirection = Directions.UP;
          return Directions.UP;
        }

        nextDirection = Directions.DOWN;
        if (!_level.checkCollision(currentX, ++currentY, this)) {
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }
        nextDirection = Directions.RIGHT;
        if (!_level.checkCollision(++currentX, currentY, this)) {
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }

        nextDirection = Directions.LEFT;
        if (!_level.checkCollision(--currentX, currentY, this)) {
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }
      }

      // NEXT RIGHT PREVIOUS UP
      if (nextDirection == Directions.RIGHT &&
          _previousDirection == Directions.UP) {
        nextDirection = Directions.RIGHT;
        if (!_level.checkCollision(++currentX, currentY, this)) {
          _previousDirection = Directions.DOWN;
          return Directions.RIGHT;
        }

        nextDirection = Directions.UP;
        if (!_level.checkCollision(currentX, --currentY, this)) {
          _previousDirection = Directions.UP;
          return Directions.UP;
        }

        nextDirection = Directions.LEFT;
        if (!_level.checkCollision(--currentX, currentY, this)) {
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }

        nextDirection = Directions.DOWN;
        if (!_level.checkCollision(currentX, ++currentY, this)) {
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }
      }

      // NEXT RIGHT PREVIOUS DOWN
      if (nextDirection == Directions.RIGHT &&
          _previousDirection == Directions.DOWN) {
        nextDirection = Directions.RIGHT;
        if (!_level.checkCollision(++currentX, currentY, this)) {
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }

        nextDirection = Directions.DOWN;
        if (!_level.checkCollision(currentX, ++currentY, this)) {
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }

        nextDirection = Directions.LEFT;
        if (!_level.checkCollision(--currentX, currentY, this)) {
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }

        nextDirection = Directions.UP;
        if (!_level.checkCollision(currentX, --currentY, this)) {
          _previousDirection = Directions.UP;
          return Directions.UP;
        }
      }

      // NEXT RIGHT PREVIOUS LEFT
      if (nextDirection == Directions.RIGHT &&
          _previousDirection == Directions.LEFT) {
        nextDirection = Directions.UP;
        if (!_level.checkCollision(currentX, --currentY, this)) {
          _previousDirection = Directions.UP;
          return Directions.UP;
        }

        //TODO er geht runter obwohl hier eine Kollision besteht
        nextDirection = Directions.DOWN;
        if (!_level.checkCollision(currentX, ++currentY, this)) {
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }

        nextDirection = Directions.LEFT;
        if (!_level.checkCollision(--currentX, currentY, this)) {
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }

        nextDirection = Directions.RIGHT;
        if (!_level.checkCollision(++currentX, currentY, this)) {
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }
      }

      return Directions.NOTHING;
    }
  }
}

/**
 * returnToHome, ScatterMode, Frightened Mode
 * alles in die Ghost kommen und die Geister selben haben nur ihre
 * individuelle Chase/Verfolger Methode und je nach Geist komplex
 *
 * UP -> LEFT -> DOWN
 **/
