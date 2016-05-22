part of pacmanLib;

class Score {
  int _scoreSum = 0;
  int _multiplier = 1;

  int get totalScore => _scoreSum;

  void addScore(int score, GameElement g) {
    if (g is Ghost)
      _scoreSum += _multiplier * score;
    else
      _scoreSum += score;
  }

  void incGhostMultiplier() {
    _multiplier++;
  }

  void resetGhostMultiplier() {
    _multiplier = 1;
  }

  void reset() {
    _scoreSum = 0;
    _multiplier = 1;
  }
}
