part of pacmanLib;

/**
 * represents a power pill in pacman game. Is like a normal pill, but enable the powerMode.
 */
class PowerPill extends Item {
  /**
   * power pill already used?
   */
  bool _used = false;

  /**
   * creates a new power pill
   */
  PowerPill(int x, int y, bool collPlayer, bool collGhost, bool visible,
      int score, PacmanGameModel model)
      : super(x, y, collPlayer, collGhost, visible, score, model);

  @override
  void pickUp() {
    super.pickUp();
    if (!_used) {
      _model._enablePowerMode();
      _used = true;
    }
  }
}
