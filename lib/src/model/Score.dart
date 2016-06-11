part of pacmanModelLib;

/**
 * represents the highscore of player in pacman game
 */
class Score {
  /**
   * total highscore per level
   */
  int _scoreSum = 0;

  /**
   * multiplier for score wehn eating ghosts
   */
  int _multiplier = 1;

  /**
   * return highscore
   */
  int get totalScore => _scoreSum;

  /**
   * adds a new score to highscore
   */
  void addScore(int score, GameElement g) {
    if (g is Ghost)
      _scoreSum += _multiplier * score;
    else
      _scoreSum += score;
  }

  /**
   * increase ghost multiplier
   */
  void incGhostMultiplier() {
    _multiplier++;
  }

  /**
   * reset ghost multiplier
   */
  void resetGhostMultiplier() {
    _multiplier = 1;
  }

  /**
   * reset the whole score
   */
  void reset() {
    _scoreSum = 0;
    _multiplier = 1;
  }
}
