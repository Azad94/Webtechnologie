part of pacmanLib;

class Cherry extends Item {

  Cherry(int x, int y, bool collPlayer, bool collGhost, bool visible, int score, PacmanGameModel model)
      : super(x, y, collPlayer, collGhost, visible, score, model);

  void scoreReached() {}
}