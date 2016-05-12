part of pacmanLib;

class Pinky extends Ghost {
  Pinky(int x, int y, bool collPlayer, bool collGhost, Level l) : super(x, y, collPlayer, collGhost, l);

  void move()
  {
    _level.registerElement(_x,_y,_x,_y,this);
  }

  void eatableMode() {}
}

/**  * Wenn i.wann mal die Werte für die Map übergeben werden sind
 * folgende Berechnungen für die Scatter Position einmal notwendig 
 * * für die X-Koordinate  *    x - 1 
 * * für die Y-Koordinate  *    y -1  **/