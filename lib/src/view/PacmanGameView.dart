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
  final startButton = querySelector("#startButton");

  final _msg = querySelector("#msg");

  final _labyrinth = querySelector("#labyrinth");

  final _information = querySelector("#information");
  final _level = querySelector("#level");
  final _score = querySelector("#score");
  final _lives = querySelector("#lives");

  //Konstruktor
  PacmanGameView(_con);


  void showGameview() {
    _startScreen.classes.toggle('close');
    _game.classes.toggle('show');
    _message.classes.toggle('show');
  }


  void updateEnvironmentMap() {

  }

  void updateDynamicMap() {

  }

  void updateItemMap() {

  }

  void updateGameStatus() {}

  void updateListen(List<List<Tile>> l) {
    _labyrinth.innerHtml = _labyrinthToHTMLTable(l);
  }

  void updateScore(int score) {
    _score.innerHtml = "Score: $score";
  }
  String _labyrinthToHTMLTable(List<List<Tile>> l) {

    String htmlTable = "<table><tbody>";

    for (List<Tile> row in l) {
      htmlTable += "<tr>";

      for (Tile t in row) {
        if(t.enviornment != Statics.NOTHING){
          htmlTable += "<td>#</td>";
        }
      }
    }
  }
}
