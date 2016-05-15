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

  Directions getNextMove(int currentX, int currentY, int targetX, int targetY, GameElement g)
  {
    if(currentX == targetX && currentY == targetY) return Directions.NOTHING;
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

    print("--- PH : "+preferredHorDirection.toString());
    print("--- PV : "+preferredVerDirection.toString());
    print("--- NEXT : "+nextDirection.toString());
    print("--- PREV : "+ _previousDirection.toString());

    if(verticalMoreImportant)
    {
      if(nextDirection == _previousDirection)
      {
        // NEXT UP PREVIOUS UP
        if (nextDirection == Directions.UP)
        {
          if (!_level.checkCollision(currentX, --currentY, this)){
            print("-------------------------------------UP EINS");
            _previousDirection = Directions.UP;
            return Directions.UP;
          }

          nextDirection = Directions.LEFT;
          if (!_level.checkCollision(--currentX, currentY, this)) {
            print("-------------------------------------LEFT EINS");
            _previousDirection = Directions.LEFT;
            return Directions.LEFT;
          }

          nextDirection = Directions.RIGHT;
          if (!_level.checkCollision(++currentX, currentY, this))  {
            print("-------------------------------------RIGHT EINS");
            _previousDirection = Directions.RIGHT;
            return Directions.RIGHT;
          }

          nextDirection = Directions.DOWN;
          if (!_level.checkCollision(currentX, ++currentY, this)){
            print("-------------------------------------DOWN EINS");
            _previousDirection = Directions.DOWN;
            return Directions.DOWN;
          }
        }

        // NEXT DOWN PREVIOUS DOWN
        if (nextDirection == Directions.DOWN)
        {
          if(!_level.checkCollision(currentX, ++currentY, this)) {
            print("-------------------------------------DOWN ZWEI");
            _previousDirection = Directions.DOWN;
            return Directions.DOWN;
          }

          nextDirection = Directions.LEFT;
          if(!_level.checkCollision(--currentX, currentY, this)) {
            print("-------------------------------------LEFT ZWEI");
            _previousDirection = Directions.LEFT;
            return Directions.LEFT;
          }

          nextDirection = Directions.RIGHT;
          if(!_level.checkCollision(++currentX, currentY, this)) {
            print("-------------------------------------RIGHT ZWEI");
            _previousDirection = Directions.RIGHT;
            return Directions.RIGHT;
          }

          nextDirection = Directions.UP;
          if(!_level.checkCollision(currentX, --currentY, this)){
            print("-------------------------------------UP ZWEI");
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
          print("-------------------------------------LEFT DREI");
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }

        nextDirection = Directions.DOWN;
        if(!_level.checkCollision(currentX, ++currentY, this)){
          print("-------------------------------------DOWN DREI");
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }

        nextDirection = Directions.RIGHT;
        if(!_level.checkCollision(++currentX, currentY, this)){
          print("-------------------------------------RIGHT DREI");
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }

        nextDirection = Directions.UP;
        if(!_level.checkCollision(currentX, --currentY, this)){
          print("-------------------------------------UP DREI");
          _previousDirection = Directions.UP;
          return Directions.UP;
        }
      }

      // NEXT UP PREVIOUS LEFT
      if(nextDirection == Directions.UP && _previousDirection == Directions.LEFT)
      {
        nextDirection = Directions.UP;
        if(!_level.checkCollision(currentX, --currentY, this)){
          print("-------------------------------------UP VIER");
          _previousDirection = Directions.UP;
          return Directions.UP;
        }

        //TODO er geht nach Oben obwohl er das nicht darf bzw obwohl da eine Kollision ist
        nextDirection = Directions.LEFT;
        if(!_level.checkCollision(--currentX, currentY, this)) {
          print("-------------------------------------LEFT VIER");
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }

        nextDirection = Directions.DOWN;
        if(!_level.checkCollision(currentX, ++currentY, this)) {
          print("-------------------------------------DOWN VIER");
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }

        nextDirection = Directions.RIGHT;
        if(!_level.checkCollision(++currentX, currentY, this)) {
          print("-------------------------------------RIGHT VIER");
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }
      }

      // NEXT UP PREVIOUS RIGHT
      if(nextDirection == Directions.UP && _previousDirection == Directions.RIGHT)
      {
        nextDirection = Directions.UP;
        if(!_level.checkCollision(currentX, --currentY, this)) {
          print("-------------------------------------UP FÜNF");
          _previousDirection = Directions.UP;
          return Directions.UP;
        }

        nextDirection = Directions.DOWN;
        if(!_level.checkCollision(currentX, ++currentY, this)) {
          print("-------------------------------------DOWN FÜNF");
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }

        nextDirection = Directions.RIGHT;
        if(!_level.checkCollision(++currentX, currentY, this)) {
          print("-------------------------------------RIGHT FÜNF");
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }

        nextDirection = Directions.LEFT;
        if(!_level.checkCollision(--currentX, currentY, this))  {
          print("-------------------------------------LEFT FÜNF");
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }
      }

      // NEXT DOWN PREVIOUS UP
      if(nextDirection == Directions.DOWN && _previousDirection == Directions.UP)
      {
        nextDirection = Directions.LEFT;
        if(!_level.checkCollision(--currentX, currentY, this))  {
          print("-------------------------------------LEFT SECHS");
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }

        nextDirection = Directions.RIGHT;
        if(!_level.checkCollision(++currentX, currentY, this)){
          print("-------------------------------------RIGHT SECHS");
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }

        nextDirection = Directions.DOWN;
        if(!_level.checkCollision(currentX, ++currentY, this)) {
          print("-------------------------------------DOWN SECHS");
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }

        nextDirection = Directions.UP;
        if(!_level.checkCollision(currentX, --currentY, this)) {
          print("-------------------------------------UP SECHS");
          _previousDirection = Directions.UP;
          return Directions.UP;
        }
      }

      // NEXT DOWN PREVIOUS LEFT
      if(nextDirection == Directions.DOWN && _previousDirection == Directions.LEFT)
      {
        nextDirection = Directions.DOWN;
        if(!_level.checkCollision(currentX, ++currentY, this)) {
          print("-------------------------------------DOWN SIEBEN");
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }

        nextDirection = Directions.LEFT;
        if(!_level.checkCollision(--currentX, currentY, this)) {
          print("-------------------------------------LEFT SIEBEN");
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }

        nextDirection = Directions.RIGHT;
        if(!_level.checkCollision(++currentX, currentY, this)) {
          print("-------------------------------------RIGHT SIEBEN");
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }

        //TODO Fehler das er obwohl ne wand ist runter gegangen ist ausgemerzt
        return Directions.NOTHING;
        /**nextDirection = Directions.UP;
            if(!_level.checkCollision(currentX, --currentY, this)) {
            print("-------------------------------------UP SIEBEN");
            return Directions.UP;

            }**/
      }

      // NEXT DOWN PREVIOUS RIGHT
      if(nextDirection == Directions.DOWN && _previousDirection == Directions.RIGHT)
      {
        nextDirection = Directions.DOWN;
        if(!_level.checkCollision(currentX, ++currentY, this)) {
          print("-------------------------------------DOWN ACHT");
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }

        nextDirection = Directions.UP;
        if(!_level.checkCollision(currentX, --currentY, this)){
          print("-------------------------------------UP ACHT");
          _previousDirection = Directions.UP;
          return Directions.UP;
        }

        nextDirection = Directions.RIGHT;
        if(!_level.checkCollision(++currentX, currentY, this)) {
          print("-------------------------------------RIGHT ACHT");
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }

        nextDirection = Directions.LEFT;
        if(!_level.checkCollision(--currentX, currentY, this)) {
          print("-------------------------------------LEFT ACHT");
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
            print("-------------------------------------LEFT NEUN");
            _previousDirection = Directions.LEFT;
            return Directions.LEFT;
          }

          //TODO hier geht er nach oben obwohl er nicht darf wegen Kollision
          nextDirection = Directions.UP;
          if(!_level.checkCollision(currentX, --currentY, this)) {
            print("-------------------------------------UP NEUN");
            _previousDirection = Directions.UP;
            return Directions.UP;
          }

          nextDirection = Directions.DOWN;
          if (!_level.checkCollision(currentX, ++currentY, this)){
            print("-------------------------------------DOWN NEUN");
            _previousDirection = Directions.DOWN;
            return Directions.DOWN;
          }
        }

        // NEXT RIGHT PREVIOUS RIGHT
        if (nextDirection == Directions.RIGHT)
        {
          if(!_level.checkCollision(++currentX, currentY, this)) {
            print("-------------------------------------RIGHT NEUN");
            _previousDirection = Directions.RIGHT;
            return Directions.RIGHT;
          }

          nextDirection = Directions.UP;
          if(!_level.checkCollision(currentX, --currentY, this)){
            print("-------------------------------------UP ZEHN");
            _previousDirection = Directions.UP;
            return Directions.UP;
          }

          nextDirection = Directions.DOWN;
          if(!_level.checkCollision(currentX, ++currentY, this)){
            print("-------------------------------------DOWN ZEHN");
            _previousDirection = Directions.DOWN;
            return Directions.DOWN;
          }

          nextDirection = Directions.LEFT;
          if(!_level.checkCollision(--currentX, currentY, this)) {
            print("-------------------------------------LEFT ZEHN");
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
          print("-------------------------------------LEFT ELF");
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }

        nextDirection = Directions.UP;
        if(!_level.checkCollision(currentX, --currentY, this)) {
          print("-------------------------------------UP ELF");
          _previousDirection = Directions.UP;
          return Directions.UP;
        }

        nextDirection = Directions.RIGHT;
        if(!_level.checkCollision(++currentX, currentY, this)) {
          print("-------------------------------------RIGHT ZEHN");
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }

        nextDirection = Directions.DOWN;
        if(!_level.checkCollision(currentX, ++currentY, this)){
          print("-------------------------------------DOWN ELF");
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }
      }

      // NEXT LEFT PREVIOUS DOWN
      if(nextDirection == Directions.LEFT && _previousDirection == Directions.DOWN)
      {
        nextDirection = Directions.LEFT;
        if(!_level.checkCollision(--currentX, currentY, this)) {
          print("-------------------------------------LEFT ZWÖLF");
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }

        nextDirection = Directions.DOWN;
        if(!_level.checkCollision(currentX, ++currentY, this)){
          print("-------------------------------------DOWN ZWÖLF");
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }

        nextDirection = Directions.RIGHT;
        if(!_level.checkCollision(++currentX, currentY, this)) {
          print("-------------------------------------RIGHT ELF");
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }

        nextDirection = Directions.UP;
        if(!_level.checkCollision(currentX, --currentY, this)) {
          print("-------------------------------------UP ZWÖLF");
          _previousDirection = Directions.UP;
          return Directions.UP;
        }
      }

      // NEXT LEFT PREVIOUS RIGHT
      if(nextDirection == Directions.LEFT && _previousDirection == Directions.RIGHT)
      {
        nextDirection = Directions.UP;
        if(!_level.checkCollision(currentX, --currentY, this)){
          print("-------------------------------------UP DREIZEHN");
          _previousDirection = Directions.UP;
          return Directions.UP;
        }

        nextDirection = Directions.DOWN;
        if(!_level.checkCollision(currentX, ++currentY, this)) {
          print("-------------------------------------DOWN DREIZEHN");
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }
        nextDirection = Directions.RIGHT;
        if(!_level.checkCollision(++currentX, currentY, this)) {
          print("-------------------------------------RIGHT ZWÖLF");
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }

        nextDirection = Directions.LEFT;
        if(!_level.checkCollision(--currentX, currentY, this))  {
          print("-------------------------------------LEFT DREIZEHN");
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
          print("-------------------------------------UP VIERZEHN");
          _previousDirection = Directions.UP;
          return Directions.UP;
        }

        nextDirection = Directions.LEFT;
        if(!_level.checkCollision(--currentX, currentY, this))  {
          print("-------------------------------------LEFT VIERZEHN");
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }

        nextDirection = Directions.DOWN;
        if(!_level.checkCollision(currentX, ++currentY, this)) {
          print("-------------------------------------DOWN FÜNZEHN");
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }
      }

      // NEXT RIGHT PREVIOUS DOWN
      if(nextDirection == Directions.RIGHT && _previousDirection == Directions.DOWN)
      {
        nextDirection = Directions.RIGHT;
        if(!_level.checkCollision(++currentX, currentY, this)) {
          print("-------------------------------------RIGHT DREIZEHN");
          _previousDirection = Directions.RIGHT;
          return Directions.RIGHT;
        }

        nextDirection = Directions.DOWN;
        if(!_level.checkCollision(currentX, ++currentY, this)){
          print("-------------------------------------DOWN SECHSZEHN");
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }

        nextDirection = Directions.LEFT;
        if(!_level.checkCollision(--currentX, currentY, this))  {
          print("-------------------------------------LEFT SECHSZEHN");
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }

        nextDirection = Directions.UP;
        if(!_level.checkCollision(currentX, --currentY, this)){
          print("-------------------------------------UP FÜNFZEHN");
          _previousDirection = Directions.UP;
          return Directions.UP;
        }
      }

      // NEXT RIGHT PREVIOUS LEFT
      if(nextDirection == Directions.RIGHT && _previousDirection == Directions.LEFT)
      {
        nextDirection = Directions.UP;
        if(!_level.checkCollision(currentX, --currentY, this)) {
          print("-------------------------------------UP SECHSZEHN");
          _previousDirection = Directions.UP;
          return Directions.UP;
        }

        //TODO er geht runter obwohl hier eine Kollision besteht
        nextDirection = Directions.DOWN;
        if(!_level.checkCollision(currentX, ++currentY, this)) {
          print("-------------------------------------DOWN SIEBZEHN");
          _previousDirection = Directions.DOWN;
          return Directions.DOWN;
        }

        nextDirection = Directions.LEFT;
        if(!_level.checkCollision(--currentX, currentY, this))  {
          print("-------------------------------------LEFT SIEBZEHN");
          _previousDirection = Directions.LEFT;
          return Directions.LEFT;
        }

        nextDirection = Directions.RIGHT;
        if(!_level.checkCollision(++currentX, currentY, this)) {
          print("-------------------------------------RIGHT VIERZEHN");
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