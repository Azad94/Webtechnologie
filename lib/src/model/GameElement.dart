part of pacmanLib;

/**
 * Mother of all elements in pacman game.
 */
abstract class GameElement {
  /**
   * position on game field
   */
  int _x, _y;

  /**
   * collision with player possible?
   */
  bool _collisionPlayer;

  /**
   * collision with ghost possible?
   */
  bool _collisionGhost;

  /**
   * creates a new game element
   */
  GameElement(this._x, this._y, this._collisionPlayer, this._collisionGhost);
}
