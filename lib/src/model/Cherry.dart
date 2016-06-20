part of pacmanModelLib;

/**
 * A special item with high score. If a bonus level available, open wall for entry
 */
class Cherry extends Item {
  /**
   * time(frames) how long entry fpr bonus level is open
   */
  int _openTime;

  /**
   * counter to count frames
   */
  int _counter = 0;

  /**
   * create a new cherry
   */
  Cherry(int x, int y, bool collPlayer, bool collGhost, bool visible, int score,
      PacmanGameModel model,
      [this._openTime])
      : super(x, y, collPlayer, collGhost, visible, score, model);

  /**
   * called every frame, count frames and activate bonus level
   */
  void _triggerFrame() {
    // bonus level is active and cherry is picked up
    if (_openTime != null && !_visible) {
      if (++_counter == _openTime) {
        _model._closeWall();
      }
    }
  }

  @override
  void _pickUp() {
    if (_model._hasBonus && _visible) {
      _model._openWall();
    }
    super._pickUp();
  }
}
