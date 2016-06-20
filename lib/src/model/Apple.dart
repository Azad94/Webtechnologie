part of pacmanModelLib;

/**
 * A special Item for Pacman. After picked up Pacman can go into walls.
 */
class Apple extends Item {
  /**
   * creates a new apple
   */
  Apple(int x, int y, bool collPlayer, bool collGhost, bool visible, int score,
      PacmanGameModel model)
      : super(x, y, collPlayer, collGhost, visible, score, model);

  @override
  void _pickUp() {
    if (_visible) {
      _model._activatePacmanPowerMode();
    }
    super._pickUp();
  }
}
