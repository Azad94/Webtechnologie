part of pacmanLib;

/**
 * A [PacmanGameView] object interacts with the DOM tree
 * to reflect actual [PacmanGame] state to the user
 */
class PacmanGameView {

  PacmanGameController _con;

  //Die verschiedenen DivKlassen aus dem HTML-Dokument
  final _startScreen = querySelector(".start");
  final _message = querySelector(".message");
  final _game = querySelector(".game");

  //Die verschiedenen Elemente aus dem HTML-Dokument
  final _startText = querySelector("#startText");
  final _startButton = querySelector("#startButton");

  final _msg = querySelector("#msg");

  final _labyrinth = querySelector("#labyrinth");

  final _information = querySelector("#information");
  final _level = querySelector("#level");
  final _score = querySelector("#score");
  final _lives = querySelector("#lives");

  PacmanGameView(_con);

  void updateEnvironmentMap() {}

  void updateDynamicMap() {}

  void updateItemMap() {}

  void updateGameStatus() {}

  void updateListen() {}

  void updateScore(int score) {
    _score.innerHtml = "Score: $score";
  }

}
