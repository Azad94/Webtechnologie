part of pacmanLib;

abstract class Ghost extends GameElement{

  bool _eatable = false;
  bool scatter;
  Directions nextDirection;
  Directions _previousDirection = Directions.NOTHING;
  Directions _savePreviousDirection = Directions.NOTHING;
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


    if(verticalMoreImportant)
    {
      if(_previousDirection == Directions.UP || _previousDirection == Directions.DOWN)
      {
        _savePreviousDirection = _previousDirection;

        nextDirection == _previousDirection ? nextDirection : nextDirection = Directions.LEFT;

        //try move from above
        switch (nextDirection)
            {
          case Directions.UP:
            if(!_level.checkCollision(currentX, currentY - 1, this)) return Directions.UP;
            break;

          case Directions.DOWN:
            if(!_level.checkCollision(currentX, currentY + 1, this)) return Directions.DOWN;
            break;

          case Directions.LEFT:
            if(!_level.checkCollision(currentX - 1, currentY, this)) return Directions.LEFT;
            break;

          default:
            break;
        }

        //if move from above wasnt possible change Direction
        switch(nextDirection)
            {
          case Directions.UP :
            nextDirection = Directions.LEFT;
            if(!_level.checkCollision(currentX - 1, currentY, this)) return Directions.LEFT;

            nextDirection = Directions.RIGHT;
            if(!_level.checkCollision(currentX + 1, currentY, this)) return Directions.RIGHT;
            break;

          case Directions.DOWN :
            nextDirection = Directions.LEFT;
            if(!_level.checkCollision(currentX - 1, currentY, this)) return Directions.LEFT;

            nextDirection = Directions.RIGHT;
            if(!_level.checkCollision(currentX + 1, currentY, this)) return Directions.RIGHT;
            break;

          case Directions.LEFT :
            if(_previousDirection == Directions.UP)
            {
              nextDirection = Directions.RIGHT;
              if(!_level.checkCollision(currentX + 1, currentY, this)) return Directions.RIGHT;

              nextDirection = Directions.DOWN;
              if(!_level.checkCollision(currentX, currentY + 1, this)) return Directions.DOWN;
            }
            else
            {
              nextDirection = Directions.RIGHT;
              if(!_level.checkCollision(currentX + 1, currentY, this)) return Directions.RIGHT;

              nextDirection = Directions.UP;
              if(!_level.checkCollision(currentX, currentY - 1, this)) return Directions.UP;
            }
            break;

          default:
            Directions.RIGHT;
            break;
        }
      }
    }
    else
    { //if the next and previous Direction are same nothing changes
      if(_previousDirection == Directions.LEFT || _previousDirection == Directions.RIGHT) {
        _savePreviousDirection = _previousDirection;

        //if they are different, try going UP first
        nextDirection == _previousDirection ? nextDirection : nextDirection = Directions.UP;

        //try move from above
        switch (nextDirection)
            {
          case Directions.UP:
            if(!_level.checkCollision(currentX, currentY - 1, this)) return Directions.UP;
            break;

          case Directions.LEFT:
            if(!_level.checkCollision(currentX - 1, currentY, this)) return Directions.LEFT;
            break;

          case Directions.RIGHT:
            if(!_level.checkCollision(currentX + 1, currentY, this)) return Directions.RIGHT;
            break;

          default:
            break;
        }

        if (nextDirection == Directions.UP)
        {
          if(_savePreviousDirection == Directions.LEFT)
          {
            nextDirection = Directions.DOWN;
            if(!_level.checkCollision(currentX, currentY + 1, this)) return Directions.DOWN;

            if (nextDirection == Directions.DOWN && preferredHorDirection == Directions.RIGHT)
            {
              nextDirection = Directions.RIGHT;
              if(!_level.checkCollision(currentX + 1, currentY, this)) return Directions.RIGHT;
            }
          }
          else
          {
            if(_savePreviousDirection == Directions.RIGHT && preferredHorDirection == Directions.LEFT)
            {
              nextDirection = Directions.DOWN;
              if(!_level.checkCollision(currentX, currentY + 1, this)) return Directions.DOWN;

              nextDirection = Directions.LEFT;
              if(!_level.checkCollision(currentX - 1, currentY, this)) return Directions.LEFT;

              return Directions.NOTHING;
            }

            return Directions.NOTHING;
          }
        }

        //if RIGHT is not allowed try going UP
        if(nextDirection == Directions.RIGHT && _savePreviousDirection == Directions.RIGHT && preferredHorDirection == Directions.RIGHT)
        {
          nextDirection = Directions.UP;
          if(!_level.checkCollision(currentX, currentY - 1, this)) return Directions.UP;

          //if UP not allowed try going DOWN
          nextDirection = Directions.DOWN;
          if(!_level.checkCollision(currentX, currentY + 1, this)) return Directions.DOWN;

          return Directions.NOTHING;
        }

        //if going LEFT ist not allowed try going DOWN
        nextDirection == Directions.LEFT ? nextDirection = Directions.DOWN : Directions.UP;
        if(!_level.checkCollision(currentX, currentY + 1, this)) return Directions.DOWN;
        if(!_level.checkCollision(currentX, currentY - 1, this)) return Directions.UP;

        //if going DOWN is not allowed try going UP
        if(nextDirection == Directions.DOWN) nextDirection = Directions.UP;
        if(!_level.checkCollision(currentX, currentY - 1, this)) return Directions.UP;

        return Directions.NOTHING;
      }
    }
    return Directions.NOTHING;
  }
}

/**
 * returnToHome, ScatterMode, Frightened Mode
 * alles in die Ghost kommen und die Geister selben haben nur ihre
 * individuelle Chase/Verfolger Methode und je nach Geist komplex
 *
 * UP -> LEFT -> DOWN
 **/