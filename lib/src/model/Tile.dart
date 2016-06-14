part of pacmanModelLib;

/**
 * is one part of the game field.
 */
class Tile {
  /**
   * environment
   */
  Environment _environment;

  /**
   * item
   */
  Item _item;

  /**
   * pacman
   */
  Pacman _pacman;

  /**
   * all ghosts
   */
  List<Ghost> _ghosts = new List();
}
