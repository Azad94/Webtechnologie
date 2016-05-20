part of pacmanLib;

abstract class Ghost extends GameElement{

  bool _eatable = false;
  bool scatter;
  Directions nextDirection;
  Directions _previousDirection = Directions.LEFT;
  Directions _savePreviousDirection = Directions.LEFT;
  int _ghostsEaten = 0;
  Level _level;

  Ghost(int x, int y, bool collPlayer, bool collGhost, Level l) : super(x, y, collPlayer, collGhost), this._level = l;

  void move();
  void eatableMode();

  /**
   * if the ghosts are eatable, return value is set to false
   * if the ghosts are not eatable, return value is set to true
   **/
  void setEatable()
  {
    _eatable ? _eatable = true : _eatable = false;
  }

  //return's true if the ghosts are eatable else false
  bool isEatable()
  {
    return _eatable;
  }

  /**
      void setDirection(Directions dir)
      {
      _previousDirection = nextDirection;
      nextDirection = dir;
      }
   **/

  //returns true if the ghosts are in Scatter Mode
  bool isScatterModeOn()
  {
    return scatter;
  }

  void startScatterMode()
  {
    //TODO muss noch implementiert werden, Logik fehlt noch, muss ich mir noch überlegen
    scatter = true;
    int _scatterTimer = 7;

    while (_scatterTimer > 0)
    {
      _scatterTimer--;
    }
  }

  void stopScatter()
  {
    //TODO muss noch implementiert werden
    scatter = false;

  }

  //as param give the ghost to be respawned
  void respawn(Dynamics ghost){
    //TODO muss noch geklärt werden auf wessen seite das passiert auf meiner oder der von niklas
  }

  //abhängig davon wieviele Ghosts schon gefressen wurden
  int getScoreValue()
  {
    _ghostsEaten++;
    return _ghostsEaten;
  }

  //sets the score of the ghosts to zero
  void setGhostScoreToZero()
  {
    _ghostsEaten = 0;
  }

  int _possibleDirections;
  int _possibleUp;
  int _possibleDown;
  int _possibleLeft;
  int _possibleRight;

  Directions getNextMove(int currentX, int currentY, int targetX, int targetY, GameElement g)
  {
    if(currentX == targetX && currentY == targetY) return Directions.NOTHING;

    int _currentDistanceX = targetX - currentX;
    int _currentDistanceY = targetY - currentY;
    int _checkX = currentX;
    int _checkY = currentY;

    _possibleDirections = 0;
    _possibleUp = 0;
    _possibleDown = 0;
    _possibleLeft = 0;
    _possibleRight = 0;
    //horizontal difference from currentPosition to targetPosition
    int horDifference = currentX-targetX;
    int verDifference = currentY-targetY;

    //preferred direction considering the difference     UP-> LEFT-> DOWN
    Directions preferredHorDirection = horDifference > 0 ? Directions.LEFT : Directions.RIGHT;
    Directions preferredVerDirection = verDifference > 0 ? Directions.UP : Directions.DOWN;

    //checks if the vertical difference is greater than the horizontal
    bool verticalMoreImportant = verDifference.abs() > horDifference.abs();

    //sets next preferred direction
    verticalMoreImportant ? nextDirection = preferredVerDirection : nextDirection = preferredHorDirection;

    //                             UP
    if(!_level.checkCollision(currentX, --currentY, this))
    {
      _possibleDirections++;
      _possibleUp++;
    }

    //                             DOWN
    if(!_level.checkCollision(currentX, ++currentY, this))
    {
      _possibleDirections++;
      _possibleDown++;
    }

    //                             LEFT
    if(!_level.checkCollision(--currentX, currentY, this))
    {
      _possibleDirections++;
      _possibleLeft++;
    }

    //                             RIGHT
    if(!_level.checkCollision(++currentX, currentY, this))
    {
      _possibleDirections++;
      _possibleRight++;
    }

    if(_possibleDirections > 1)
    {
      // go up
      if(_previousDirection != Directions.DOWN && _possibleUp == 1)
      {
        if(--_checkY < _currentDistanceY) return Directions.UP;
        _checkX = currentX;
        _checkY = currentY;
        if(--_checkX < _currentDistanceX) return Directions.LEFT;
        _checkX = currentX;
        _checkY = currentY;
        if(++_checkX < _currentDistanceX) return Directions.RIGHT;
        _checkX = currentX;
        _checkY = currentY;
      }

      // go down
      if(_previousDirection != Directions.UP && _possibleDown == 1)
      {
        if(++_checkY < _currentDistanceY) return Directions.DOWN;
        _checkX = currentX;
        _checkY = currentY;
        if(--_checkX < _currentDistanceX) return Directions.LEFT;
        _checkX = currentX;
        _checkY = currentY;
        if(++_checkX < _currentDistanceX) return Directions.RIGHT;
        _checkX = currentX;
        _checkY = currentY;
      }

      // go left
      if(_previousDirection != Directions.RIGHT && _possibleLeft == 1)
      {
        if(--_checkX < _currentDistanceX) return Directions.LEFT;
        _checkX = currentX;
        _checkY = currentY;
        if(++_checkY < _currentDistanceY) return Directions.DOWN;
        _checkX = currentX;
        _checkY = currentY;
        if(--_checkY < _currentDistanceY) return Directions.UP;
        _checkX = currentX;
        _checkY = currentY;
      }

      // go right
      if(_previousDirection != Directions.LEFT && _possibleRight == 1)
      {
        if(++_checkX < _currentDistanceX) return Directions.RIGHT;
        _checkX = currentX;
        _checkY = currentY;
        if(--_checkY < _currentDistanceY) return Directions.UP;
        _checkX = currentX;
        _checkY = currentY;
        if(++_checkY < _currentDistanceY) return Directions.DOWN;
        _checkX = currentX;
        _checkY = currentY;
      }
    }

    if(nextDirection == _previousDirection)
    {
      //TODO UP OBEN
      if (nextDirection == Directions.UP)
      {
        // UP OBEN
        if (!_level.checkCollision(_checkX, --_checkY, this))
        {
          _previousDirection = Directions.UP;
          return Directions.UP;
        }

        _checkX = currentX;
        _checkY = currentY;

        // LEFT LINKS
        if (!_level.checkCollision(--_checkX, _checkY, this))
        {
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }

        _checkX = currentX;
        _checkY = currentY;

        // RIGHT RECHTS
        if (!_level.checkCollision(++_checkX, _checkY, this))
        {
          _previousDirection = Directions.RIGHT;
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
          return Directions.DOWN;
        }

        _checkX = currentX;
        _checkY = currentY;

        // LEFT LINKS
        if (!_level.checkCollision(--_checkX, _checkY, this))
        {
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }

        _checkX = currentX;
        _checkY = currentY;

        // RIGHT RECHTS
        if (!_level.checkCollision(++_checkX, _checkY, this))
        {
          _previousDirection = Directions.RIGHT;
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
          return Directions.LEFT;
        }

        _checkX = currentX;
        _checkY = currentY;

        // DOWN UNTEN
        if (!_level.checkCollision(_checkX, ++_checkY, this))
        {
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }

        _checkX = currentX;
        _checkY = currentY;

        // UP OBEN
        if (!_level.checkCollision(_checkX, --_checkY, this))
        {
          _previousDirection = Directions.UP;
          return Directions.UP;
        }

        _checkX = currentX;
        _checkY = currentY;

        return Directions.NOTHING;
      }

      // TODO RIGHT RECHTS
      if (nextDirection == Directions.RIGHT)
      {
        // UP OBEN
        if (!_level.checkCollision(_checkX, --_checkY, this))
        {
          _previousDirection = Directions.UP;
          return Directions.UP;
        }

        _checkX = currentX;
        _checkY = currentY;

        // LEFT LINKS
        if (!_level.checkCollision(--_checkX, _checkY, this))
        {
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }

        _checkX = currentX;
        _checkY = currentY;

        // DOWN UNTEN
        if (!_level.checkCollision(_checkX, ++_checkY, this))
        {
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }

        _checkX = currentX;
        _checkY = currentY;

        return Directions.NOTHING;
      }
    }
    //TODO --------------------------------------------------------NORMALE LOGIK
    if(verticalMoreImportant)
    {
      // TODO UP OBEN
      if(_previousDirection == Directions.UP)
      {
        //LEFT
        if(!_level.checkCollision(--_checkX,_checkY,this))
        {
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }

        _checkX = currentX;
        _checkY = currentY;

        //UP
        if(!_level.checkCollision(_checkX,--_checkY,this))
        {
          _previousDirection = Directions.UP;
          return Directions.UP;
        }

        _checkX = currentX;
        _checkY = currentY;

        //RIGHT
        if(!_level.checkCollision(++_checkX,_checkY,this))
        {
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }

        _checkX = currentX;
        _checkY = currentY;

        return Directions.NOTHING;
      }

      // TODO DOWN UNTEN
      if(_previousDirection == Directions.DOWN)
      {
        //DOWN
        if(!_level.checkCollision(_checkX,++_checkY,this))
        {
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }

        _checkX = currentX;
        _checkY = currentY;

        //LEFT
        if(!_level.checkCollision(--_checkX,_checkY,this))
        {
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }

        _checkX = currentX;
        _checkY = currentY;

        //RIGHT
        if(!_level.checkCollision(++_checkX,_checkY,this))
        {
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }

        _checkX = currentX;
        _checkY = currentY;


        return Directions.NOTHING;
      }

      // TODO LEFT LINKS
      if(_previousDirection == Directions.LEFT)
      {
        //UP
        if(!_level.checkCollision(_checkX,--_checkY,this))
        {
          _previousDirection = Directions.UP;
          return Directions.UP;
        }

        _checkX = currentX;
        _checkY = currentY;

        //DOWN
        if(!_level.checkCollision(_checkX,++_checkY,this))
        {
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }

        _checkX = currentX;
        _checkY = currentY;

        //LEFT
        if(!_level.checkCollision(--_checkX,_checkY,this))
        {
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }

        _checkX = currentX;
        _checkY = currentY;

        return Directions.NOTHING;
      }

      // TODO RIGHT RECHTS
      if(_previousDirection == Directions.RIGHT)
      {
        //UP
        if(!_level.checkCollision(_checkX,--_checkY,this))
        {
          _previousDirection = Directions.UP;
          return Directions.UP;
        }

        _checkX = currentX;
        _checkY = currentY;

        //DOWN
        if(!_level.checkCollision(_checkX,++_checkY,this))
        {
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }

        _checkX = currentX;
        _checkY = currentY;

        //RIGHT
        if(!_level.checkCollision(++_checkX,_checkY,this))
        {
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }

        _checkX = currentX;
        _checkY = currentY;

        return Directions.NOTHING;
      }

    }
    // TODO ----------------------------------------------------------ELSE LOGIK
    else
    {
      // TODO LEFT LINKS
      if(_previousDirection == Directions.LEFT)
      {
        //LEFT
        if(!_level.checkCollision(--_checkX,_checkY,this))
        {
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }

        _checkX = currentX;
        _checkY = currentY;

        //UP
        if(!_level.checkCollision(_checkX,--_checkY,this))
        {
          _previousDirection = Directions.UP;
          return Directions.UP;
        }

        _checkX = currentX;
        _checkY = currentY;

        //DOWN
        if(!_level.checkCollision(_checkX,++_checkY,this))
        {
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }

        _checkX = currentX;
        _checkY = currentY;


        return Directions.NOTHING;
      }

      // TODO RIGHT RECHTS
      if(_previousDirection == Directions.RIGHT)
      {
        //RIGHT
        if(!_level.checkCollision(++_checkX,_checkY,this))
        {
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }

        _checkX = currentX;
        _checkY = currentY;

        //UP
        if(!_level.checkCollision(_checkX,--_checkY,this))
        {
          _previousDirection = Directions.UP;
          return Directions.UP;
        }

        _checkX = currentX;
        _checkY = currentY;

        //DOWN
        if(!_level.checkCollision(_checkX,++_checkY,this))
        {
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }

        _checkX = currentX;
        _checkY = currentY;

        return Directions.NOTHING;
      }

      // TODO UP OBEN
      if(_previousDirection == Directions.UP)
      {
        //LEFT
        if(!_level.checkCollision(--_checkX,_checkY,this))
        {
          if((--_checkX - targetY) < _currentDistanceX)
          {
            _previousDirection = Directions.LEFT;
            return Directions.LEFT;
          }
          else nextDirection = Directions.RIGHT;

          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }

        _checkX = currentX;
        _checkY = currentY;

        //RIGHT
        if(!_level.checkCollision(++_checkX,_checkY,this))
        {
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }

        _checkX = currentX;
        _checkY = currentY;

        if(_currentDistanceY != 0)
        {
        //UP
          if(!_level.checkCollision(_checkX,--_checkY,this))
          {
            _previousDirection = Directions.UP;
            return Directions.UP;
          }

          _checkX = currentX;
          _checkY = currentY;
        }

        return Directions.NOTHING;
      }

      // TODO DOWN UNTEN
      if(_previousDirection == Directions.DOWN)
      {
        //LEFT
        if(!_level.checkCollision(--_checkX,_checkY,this))
        {
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }

        _checkX = currentX;
        _checkY = currentY;

        //RIGHT
        if(!_level.checkCollision(++_checkX,_checkY,this))
        {
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }

        _checkX = currentX;
        _checkY = currentY;

        //DOWN
        if(!_level.checkCollision(_checkX,++_checkY,this))
        {
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }

        _checkX = currentX;
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