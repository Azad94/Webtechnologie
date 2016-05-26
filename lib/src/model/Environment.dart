part of pacmanLib;

class Environment extends GameElement {
  bool _itemPlaceable, _door;

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

  Environment(int x, int y, bool collPlayer, bool collGhost, bool itemPlaceable,
      bool door, List<Directions> noCollisionSidesGhost, List<Directions> noCollisionSidesPlayer)
      : super(x, y, collPlayer, collGhost),
        this._itemPlaceable = itemPlaceable,
        this._door = door,
        this._noCollisionSidesGhost = noCollisionSidesGhost,
        this._noCollisionSidesPlayer  = noCollisionSidesPlayer;
}