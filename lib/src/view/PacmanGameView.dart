part of pacmanLib;

/**
 * A [PacmanGameView] object interacts with the DOM tree
 * to reflect actual [PacmanGame] state to the user
 */
class PacmanGameView {

  PacmanGameController _con;

  //the different div-classes from the html-document
  final _startScreen = querySelector(".start");
  final _message = querySelector(".messages");
  final _game = querySelector(".game");

  //different elements from the html-document
  final _startText = querySelector("#startText");
  final startButton = querySelector("#startButton");

  final _msg = querySelector("#msg");

  final _labyrinth = querySelector("#labyrinth");

  final _information = querySelector("#information");
  final _level = querySelector("#level");
  final _score = querySelector("#score");
  final _lives = querySelector("#lives");

  //constructor
  PacmanGameView(_con);

  //close start screen and show the gamefield
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

  //see _labyrinthToHTMLTable
  void initField(List<List<Types>> l) {
    _labyrinth.innerHtml = _labyrinthToHTMLTable(l);
  }
  //displays the current score
  void updateScore(int score) {
    _score.innerHtml = "Score: $score";
  }
  void updateLevel(int level){
    _level.innerHtml = "Level: $level";
  }
  void updateLives(int lives){
    _level.innerHtml = "Lives: $lives";
  }
  //creates the table in the html-document
  String _labyrinthToHTMLTable(List<List<Types>> l) {

    String htmlTable = "<table>";
    for (List<Types> row in l) {
      htmlTable += "<tr>";

      for (Types s in row) {
          htmlTable += "<td></td>";
        }

      htmlTable += "</tr>";
    }
    return htmlTable += "</table>";
  }

  //loads the different game elements and their graphical representation into the table
  void _labyrinthFill(List<List<Types>> l) {

    var kl = _labyrinth.children[0].children[0];

    int _row = 0;
    int _col = 0;
    for (List<Types> row in l) {

      for (Types s in row) {

        switch(s) {
          case Types.WALL :
            kl.children[_row].children[_col].setAttribute("style", "background-image:url(../web/resc/wall32.png);background-repeat:no-repeat;background-size:32px 32px;   width: 32px; height: 32px;");
            break;
          case Types.DOOR :
            kl.children[_row].children[_col].setAttribute("style", "background-image:url(../web/resc/door32.png);background-repeat:no-repeat;background-size:32px 32px;   width: 32px; height: 32px;");
            break;
          case Types.BLINKY :
            kl.children[_row].children[_col].setAttribute("style", "background-image:url(../web/resc/blinky32.png);background-repeat:no-repeat;background-size:32px 32px;   width: 32px; height: 32px;");
            break;
          case Types.PINKY :
            kl.children[_row].children[_col].setAttribute("style", "background-image:url(../web/resc/pinky32.png);background-repeat:no-repeat;background-size:32px 32px;   width: 32px; height: 32px;");
            break;
          case Types.INKY :
            kl.children[_row].children[_col].setAttribute("style", "background-image:url(../web/resc/inky32.png);background-repeat:no-repeat;background-size:32px 32px;   width: 32px; height: 32px;");
            break;
          case Types.CLYDE :
            kl.children[_row].children[_col].setAttribute("style", "background-image:url(../web/resc/clyde32.png);background-repeat:no-repeat;background-size:32px 32px;   width: 32px; height: 32px;");
            break;
          case Types.PACMAN :
            kl.children[_row].children[_col].setAttribute("style", "background-image:url(../web/resc/animatedPac.gif);background-repeat:no-repeat;background-size:32px 32px;   width: 32px; height: 32px;");
            break;
          case Types.PILL :
            kl.children[_row].children[_col].setAttribute("style", "background-image:url(../web/resc/pill32_2.png);background-repeat:no-repeat;background-size:32px 32px;   width: 32px; height: 32px;");
            break;
          case Types.POWERPILL :
            kl.children[_row].children[_col].setAttribute("style", "background-image:url(../web/resc/powerpill32.gif);background-repeat:no-repeat;background-size:32px 32px;   width: 32px; height: 32px;");
            break;
          case Types.CHERRY :
            kl.children[_row].children[_col].setAttribute("style", "background-image:url(../web/resc/animatedcherry32.gif);background-repeat:no-repeat;background-size:32px 32px;   width: 32px; height: 32px;");
            break;
          case Types.NOTHING :
            kl.children[_row].children[_col].setAttribute("style", "");
            break;
          default:
            break;
        }
        _col++;
      }
      _col = 0;
      _row++;
    }
  }

}
