part of pacmanLib;

class Item extends GameElement {
  bool _visible = false;
  int _score = 0;
  PacmanGameModel _model;

  Item(int x, int y, bool collPlayer, bool collGhost, bool visible, int score,
      PacmanGameModel model)
      : super(x, y, collPlayer, collGhost),
        this._visible = visible,
        this._score = score,
        this._model = model;
  /**
   * the [Item] is picked up. Make [Item] invisible
   */
  void pickUp() {
    _visible = false;
  }
}
