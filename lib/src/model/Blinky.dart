part of pacmanLib;

class Blinky extends Ghost {
  Blinky(int x, int y, bool collPlayer, bool collGhost, Level l) : super(x, y, collPlayer, collGhost, l);

  void move() {}

  void eatableMode() {}
}