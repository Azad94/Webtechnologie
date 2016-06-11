part of pacmanLib;

/**
 * represents a static [GameElement] like a wall.
 */
class Environment extends GameElement {
  /**
   * is it possible to put a item on it? (not used at the moment)
   */
  bool _itemPlaceable;

  /**
   * is environment a door?
   */
  bool _door;

  /**
   * Sides where are no collision with the objekt and Ghosts
   * null if no sides are relevant
   */
  List<Directions> _noCollisionSidesGhost;
  /**
   * Sides where are no collision with the objekt and Ghosts
   * null if no sides are relevant
   */
  List<Directions> _noCollisionSidesPlayer;

  /**
   * creates a new Environment
   */
  Environment(
      int x,
      int y,
      bool collPlayer,
      bool collGhost,
      this._itemPlaceable,
      this._door,
      this._noCollisionSidesGhost,
      this._noCollisionSidesPlayer)
      : super(x, y, collPlayer, collGhost);
}
