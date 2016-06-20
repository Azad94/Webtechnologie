part of pacmanModelLib;

/**
 * represents a pill in pacman game
 */
class Pill extends Item {
  /**
   * create a new pill
   */
  Pill(int x, int y, bool collPlayer, bool collGhost, bool visible, int score,
      PacmanGameModel model)
      : super(x, y, collPlayer, collGhost, visible, score, model);
}
