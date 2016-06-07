part of pacmanLib;

class Item extends GameElement {
  bool _visible = false;
  int _score = 0;
  static int _items = 0;
  static int _itemsPickedUp = 0;
  PacmanGameModel _model;

  Item(int x, int y, bool collPlayer, bool collGhost, bool visible, int score,
      PacmanGameModel model)
      : super(x, y, collPlayer, collGhost) {
    this._visible = visible;
    this._score = score;
    this._model = model;
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

  static void resetCounter() {
    // TODO Doku
    _items = 0;
    _itemsPickedUp = 0;
  }
}
