part of pacmanLib;

class Clyde extends Ghost {
  Clyde(int x, int y, bool collPlayer, bool collGhost, Level l) : super(x, y, collPlayer, collGhost, l);

  int _doorTargetX = 15;
  int _doorTargetY = 9;

  int _scatterTargetX = 2;
  int _scatterTargetY = 17;

  //Blinky scatter mode position
  int _alternativeTargetX = 28;
  int _alternativeTargetY = 2;

  int _currentX = 18;
  int _currentY = 11;

  void move()
  {
    _level.registerElement(_x,_y,_x,_y,this);
  }

  void eatableMode() {}
}

/**  * Wenn i.wann mal die Werte für die Map übergeben werden sind folgende
 * Berechnungen für die Scatter Position einmal notwendig 
 * * für die X-Koordinate  *    (x - x) + 2  *
 * für die Y-Koordinate  *    y - 1  **/
