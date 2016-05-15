part of pacmanLib;

abstract class Ghost extends GameElement {
  bool _eatable = false;
  bool scatter;
  Directions nextDirection;
//  Directions _previousDirection = Directions.LEFT;
//  Directions _savePreviousDirection = Directions.LEFT;
  int _ghostsEaten = 0;
  Level _level;

  Ghost(int x, int y, bool collPlayer, bool collGhost, Level l)
      : super(x, y, collPlayer, collGhost),
        this._level = l;

  void move();

  void eatableMode();

  /**
   * if the ghosts are eatable, return value is set to false
   * if the ghosts are not eatable, return value is set to true
   **/
  void setEatable() {
    _eatable ? _eatable = true : _eatable = false;
  }

  //return's true if the ghosts are eatable else false
  bool isEatable() {
    return _eatable;
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
    //horizontal difference from currentPosition to targetPosition
    int horDifference = currentX - targetX;
    int verDifference = currentY - targetY;

    //preferred direction considering the difference     UP-> LEFT-> DOWN
    Directions preferredHorDirection = horDifference > 0 ? Directions.LEFT : Directions.RIGHT;
    Directions preferredVerDirection = verDifference > 0 ? Directions.UP : Directions.DOWN;

    //checks if the vertical difference is greater than the horizontal
    bool verticalMoreImportant = verDifference > horDifference;

        //sets next preferred direction
        verticalMoreImportant ? nextDirection = preferredVerDirection : nextDirection = preferredHorDirection;

      switch (nextDirection) {
        case Directions.UP:
       //   if (!_level.checkCollision(currentX, currentY--, this))
            return Directions.UP;
          break;

        case Directions.DOWN:
     //     if (!_level.checkCollision(currentX, currentY++, this))
            return Directions.DOWN;
          break;

        case Directions.LEFT:
      //    if (!_level.checkCollision(currentX--, currentY, this))
            return Directions.LEFT;
          break;
        case Directions.RIGHT:
    //      if (!_level.checkCollision(currentX--, currentY, this))
            return Directions.RIGHT;
          break;

        case Directions.NOTHING:
          _level.registerElement(_x, _y, _x, _y, this);
          break;
      }
  }
}
