part of pacmanLib;

abstract class Ghost extends GameElement{
  Level _level;

  Ghost(int x, int y, bool collPlayer, bool collGhost, Level l) : super(x, y, collPlayer, collGhost), this._level = l;

  void move();
  void eatableMode();
}