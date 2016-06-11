part of pacmanLib;

/**
 * Represents a item which the player can pick up. Some items have an effect on gameplay
 */
class Item extends GameElement {
  /**
   * is item visible?
   */
  bool _visible = false;

  /**
   * score of this single item
   */
  final _score;

  /**
   * counter for all items on the map
   */
  static int _items = 0;

  /**
   * counter for all picked up items
   */
  static int _itemsPickedUp = 0;

  /**
   * model
   */
  PacmanGameModel _model;

  /**
   * creates a new Item
   */
  Item(int x, int y, bool collPlayer, bool collGhost, this._visible,
      this._score, this._model)
      : super(x, y, collPlayer, collGhost) {
    if (!(this is Cherry)) _items++;
  }

  /**
   * the [Item] is picked up. Make [Item] invisible
   */
  void pickUp() {
    if (_visible) {
      if (!(this is Cherry)) _itemsPickedUp++;
      _visible = false;
      if (_itemsPickedUp == _items) _model.gameWon();
    }
  }

  /**
   * resets the item counter. Used if a new level starts
   */
  static void resetCounter() {
    _items = 0;
    _itemsPickedUp = 0;
  }
}
