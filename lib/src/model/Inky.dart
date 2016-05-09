part of pacmanLib;

class Inky extends Ghost {
  Inky(int x, int y, bool collPlayer, bool collGhost, Level l) : super(x, y, collPlayer, collGhost, l);

  void move() {}
  void eatableMode() {}
}
