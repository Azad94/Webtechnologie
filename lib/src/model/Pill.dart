part of pacmanLib;

class Pill extends Item {
  static int _pills = 0;
  static int _pickedUpPills = 0;
  Pill(int x, int y, bool collPlayer, bool collGhost, bool visible, int score,
      PacmanGameModel model)
      : super(x, y, collPlayer, collGhost, visible, score, model) {
    _pills++;
  }

  @override
  void pickUp() {
    if (_visible) {
      _visible = false;
      if (++_pickedUpPills == _pills) _model.gameWon();
    }
  }
}
