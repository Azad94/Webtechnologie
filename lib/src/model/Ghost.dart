part of pacmanLib;

abstract class Ghost extends GameElement{

  Ghost(int x, int y, bool collPlayer, bool collGhost) : super(x, y, collPlayer, collGhost);
}