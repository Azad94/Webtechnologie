part of pacmanLib;

class Pill extends Item {
  Pill(int x, int y, bool collPlayer, bool collGhost, bool visible, int score)
      : super(x, y, collPlayer, collGhost, visible, score);
}