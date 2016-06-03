part of pacmanLib;

class PowerPill extends Item {
  bool _used = false;
  PowerPill(int x, int y, bool collPlayer, bool collGhost, bool visible,
      int score, PacmanGameModel model)
      : super(x, y, collPlayer, collGhost, visible, score, model);

  @override
  void pickUp() {
    super.pickUp();
      if(!_used) {
        _model.enablePowerMode();
        _used = true;
      }
  }
}
