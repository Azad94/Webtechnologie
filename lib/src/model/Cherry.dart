part of pacmanModelLib;

class Cherry extends Item {
  int _openTime;
  int _counter = 0;
  Cherry(int x, int y, bool collPlayer, bool collGhost, bool visible, int score,
      PacmanGameModel model,
      [this._openTime])
      : super(x, y, collPlayer, collGhost, visible, score, model);

  void triggerFrame() {
    // bonus level is active and cherry is picked up
    if (_openTime != null && !_visible) {
      if (++_counter == _openTime) {
        _model._closeWall();
      }
    }
  }

  @override
  void pickUp() {
    if (_model._hasBonus && _visible) {
      _model._openWall();
    }
    super.pickUp();
  }
}
