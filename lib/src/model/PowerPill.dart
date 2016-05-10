part of pacmanLib;

class PowerPill extends Item {

  PowerPill(int x, int y, bool collPlayer, bool collGhost, bool visible, int score)
      : super(x, y, collPlayer, collGhost, visible, score);
  void enablePowerMode() {}
}