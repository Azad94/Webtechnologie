part of pacmanLib;

/**
 * A [PacmanGameView] object interacts with the DOM tree
 * to reflect actual [PacmanGame] state to the user
 */
class PacmanGameView {

  PacmanGameController _con;

  //Die verschiedenen DivKlassen aus dem HTML-Dokument
  final _startScreen = querySelector(".start");
  final _message = querySelector(".messages");
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

  void updateListen(List<List<Statics>> l) {
    _labyrinth.innerHtml = _labyrinthToHTMLTable(l);
  }
  void updateScore(int score) {
    _score.innerHtml = "Score: $score";
  }
  String _labyrinthToHTMLTable(List<List<Statics>> l) {

   /* l.forEach((List<Statics> s) => s.forEach((Statics k) => print(k)));*/

    String htmlTable = "<table>";
    int xindex = 0;
    int yindex = 0;
    for (List<Statics> row in l) {
      htmlTable += "<tr>";

      for (Statics s in row) {
        if(s == Statics.WALL){
          htmlTable += "<td></td>";
        } else { htmlTable += "<td></td>";
        }
      }
      htmlTable += "</tr>";
    }
    return htmlTable += "</table>";
  }
  void _labyrinthAddStatics(List<List<Statics>> l) {

    var kl = _labyrinth.children[0].children[0];

    int dummy = 0;
    int dummy2 = 0;
    for (List<Statics> row in l) {

      for (Statics s in row) {

        switch(s) {
          case Statics.WALL :
            kl.children[dummy].children[dummy2].setAttribute("style", "background-image:url(../web/resc/wall32.png);background-repeat:no-repeat;background-size:32px 32px;   width: 32px; height: 32px;");
            /*"background-image:url(../web/resc/blinky32.png);background-repeat:no-repeat;background-size:32px 32px;   width: 32px; height: 32px;";*/
            break;
          case Statics.FLOOR :
            break;
          case Statics.DOOR :
            kl.children[dummy].children[dummy2].setAttribute("style", "background-image:url(../web/resc/door32.png);background-repeat:no-repeat;background-size:32px 32px;   width: 32px; height: 32px;");
            break;
          case Statics.NOTHING :
            break;
          default:
            break;
        }
        dummy2++;
      }
      dummy2 = 0;
      dummy++;
    }
  }
  void _labyrinthAddDynamic(List<List<Dynamics>> l) {

    var kl = _labyrinth.children[0].children[0];

    int dummy = 0;
    int dummy2 = 0;
    for (List<Dynamics> row in l) {

      for (Dynamics s in row) {

        switch(s) {
          case Dynamics.BLINKY :
            kl.children[dummy].children[dummy2].setAttribute("style", "background-image:url(../web/resc/blinky32.png);background-repeat:no-repeat;background-size:32px 32px;   width: 32px; height: 32px;");
            /*"background-image:url(../web/resc/blinky32.png);background-repeat:no-repeat;background-size:32px 32px;   width: 32px; height: 32px;";*/
            break;
          case Dynamics.PINKY :
            kl.children[dummy].children[dummy2].setAttribute("style", "background-image:url(../web/resc/pinky32.png);background-repeat:no-repeat;background-size:32px 32px;   width: 32px; height: 32px;");
            break;
          case Dynamics.INKY :
            kl.children[dummy].children[dummy2].setAttribute("style", "background-image:url(../web/resc/inky32.png);background-repeat:no-repeat;background-size:32px 32px;   width: 32px; height: 32px;");
            break;
          case Dynamics.CLYDE :
            kl.children[dummy].children[dummy2].setAttribute("style", "background-image:url(../web/resc/clyde32.png);background-repeat:no-repeat;background-size:32px 32px;   width: 32px; height: 32px;");
            break;
          case Dynamics.PACMAN :
            kl.children[dummy].children[dummy2].setAttribute("style", "background-image:url(../web/resc/animatedPac.gif);background-repeat:no-repeat;background-size:32px 32px;   width: 32px; height: 32px;");
            break;
          case Dynamics.NOTHING :
            break;
          default:
            break;
        }
        dummy2++;
    }
      dummy2 = 0;
      dummy++;
    }
  }

  void _labyrinthAddItems(List<List<Items>> l) {

    var kl = _labyrinth.children[0].children[0];

    int dummy = 0;
    int dummy2 = 0;
    for (List<Items> row in l) {

      for (Items s in row) {

        switch(s) {
          case Items.PILL :
            kl.children[dummy].children[dummy2].setAttribute("style", "background-image:url(../web/resc/pill32.png);background-repeat:no-repeat;background-size:32px 32px;   width: 32px; height: 32px;");
            break;
          case Items.POWERPILL :
            kl.children[dummy].children[dummy2].setAttribute("style", "background-image:url(../web/resc/powerpill32.png);background-repeat:no-repeat;background-size:32px 32px;   width: 32px; height: 32px;");
            break;
          case Items.CHERRY :
            kl.children[dummy].children[dummy2].setAttribute("style", "background-image:url(../web/resc/cherry32.png);background-repeat:no-repeat;background-size:32px 32px;   width: 32px; height: 32px;");
            break;
          case Items.NOTHING :
            break;
          default:
            break;
        }
        dummy2++;
      }
      dummy2 = 0;
      dummy++;
    }
  }
}
