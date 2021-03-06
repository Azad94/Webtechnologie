part of pacmanViewLib;

/**
 * A [PacmanGameView] object interacts with the DOM tree
 * to reflect actual [PacmanGame] state to the user
 */
class PacmanGameView {

  //the different div-classes from the html-document
  final _error = querySelector("#error");
  final _loadingscreen = querySelector(".cssload-container");
  final _pause = querySelector("#pause");
  final _game = querySelector(".game");
  final _overlay = querySelector("#overlay");
  final _gameend = querySelector("#gameend");
  final startNext = querySelector("#startNext");
  final _highscore = querySelector("#userinput");
  final username = querySelector("#username");
  final savename = querySelector("#save");
  final _labyrinth = querySelector("#gamefield");
  final _level = querySelector("#value1");
  final _score = querySelector("#value2");
  final _lives = querySelector("#value3");
  final _time = querySelector("#value4");
  final _mobile = querySelector(".mobile");
  final mobileUp = querySelector("#mobileUp");
  final mobileDown = querySelector("#mobileDown");
  final mobileLeft = querySelector("#mobileLeft");
  final mobileRight = querySelector("#mobileRight");
  final mobilePause = querySelector("#mobilePause");
  final _message = querySelector(".messages");

  //mql and mqlLandscape is used to determine if a mobile device is used
  // and the orientation of the device
  var _mql = window.matchMedia("screen and (max-device-width : 800px)");
  var _mqlLandscape = window.matchMedia("screen and (orientation: landscape)");

  MediaQueryList get mql => _mql;

  /**
   * This method is used to
   * hide the game and the loadingscreen Elements
   * and display the error Screen
   */
  void showErrorScreen() {
    _error.style.display = "block";
    _game.style.display = "none";
    _loadingscreen.style.display = "none";
  }

  /**
   * display the pause graphic
   */
  void showPause(){
    _pause.style.display = "block";
  }

  /**
   * hide the pause graphic
   */
  void hidePause() {
    _pause.style.display = "none";
  }

  /**
   * hide the laoding screen
   */
  void hideLoading() {
    _loadingscreen.style.display = "none";
  }

  /**
   * display the laoding screen
   */
  void showLoading() {
    _loadingscreen.style.display = "block";
  }

  /**
   * display the game container
   */
  void showGame() {
    _game.style.display = "block";
  }

  /**
   * updates the gameoverlay according to the gameend condition
   */
  void updateOverlay(String s) {
    _gameend.innerHtml = s;
    _overlay.style.display = "block";
  }

  /**
   * hides the overlay
   */
  void hideOverlay() {
    _overlay.style.display = "none";
  }

  /**
   * hides the nextlevel button
   */
  void hideNextLevel() {
    startNext.style.display = "none";
  }

  /**
   * display the userinput to enter the name for the highscore
   */
  void showHighscore() {
    _highscore.style.visibility = "visible";
  }

  /**
   * creates a list, to display the best 10 players
   */
  void showTop10(List<Map> scores, int score) {
    final list = scores
        .map((entry) => "<li>${entry['name']}: ${entry['score']}</li>")
        .join("");
    final points = "You got $score points";
    _overlay.innerHtml =
        "<div id='scorelist'> $points ${ list.isEmpty? ""
            : "<ol>$list</ol>"}</div>";
  }

  String get user =>
      (document.querySelector('#username') as InputElement).value;

  /**
   * see _labyrinthToHTMLTable
   */
  void initTable(List<List<Types>> l) {
    String k = _createLabyrinth(l);
    _labyrinth.innerHtml = k;
  }

  /**
   * creates the table in the html-document
   */
  String _createLabyrinth(List<List<Types>> l) {
    String labyrinthTable = "<table id=\"labyrinth\">";
    final field = l;
    for (int row = 0; row < l.length; row++) {
      labyrinthTable += "<tr>";

      for (int col = 0; col < field[row].length; col++) {
        labyrinthTable += "<td>" "</td>";
      }

      labyrinthTable += "</tr>";

    }
    return labyrinthTable += "</table>";
  }

  /**
   * loads the different game elements and their graphical representation
   * into the table distingush between screen/mobile(portrait)
   * and mobile(landscape)
   */
  void labyrinthFill(List<List<Types>> l) {
    var kl = _labyrinth.children[0].children[0];

    int _row = 0;
    int _col = 0;
    for (List<Types> row in l) {
      for (Types s in row) {
        if (_mql.matches && _mqlLandscape.matches) {
          switch (s) {
            case Types.WALL:
              kl.children[_row].children[_col].setAttribute("style", _wall16);
              break;
            case Types.DOOR:
              kl.children[_row].children[_col].setAttribute("style", _door16);
              break;
            case Types.BLINKY_RIGHT:
              kl.children[_row].children[_col]
                  .setAttribute("style", _blinky_r16);
              break;
            case Types.BLINKY_DOWN:
              kl.children[_row].children[_col]
                  .setAttribute("style", _blinky_d16);
              break;
            case Types.BLINKY_LEFT:
              kl.children[_row].children[_col]
                  .setAttribute("style", _blinky_l16);
              break;
            case Types.BLINKY_UP:
              kl.children[_row].children[_col]
                  .setAttribute("style", _blinky_u16);
              break;
            case Types.BLINKY_SCARE_RIGHT:
              kl.children[_row].children[_col]
                  .setAttribute("style", _scared_r16);
              break;
            case Types.BLINKY_SCARE_DOWN:
              kl.children[_row].children[_col]
                  .setAttribute("style", _scared_d16);
              break;
            case Types.BLINKY_SCARE_LEFT:
              kl.children[_row].children[_col]
                  .setAttribute("style", _scared_l16);
              break;
            case Types.BLINKY_SCARE_UP:
              kl.children[_row].children[_col]
                  .setAttribute("style", _scared_u16);
              break;
            case Types.PINKY_RIGHT:
              kl.children[_row].children[_col]
                  .setAttribute("style", _pinky_r16);
              break;
            case Types.PINKY_DOWN:
              kl.children[_row].children[_col]
                  .setAttribute("style", _pinky_d16);
              break;
            case Types.PINKY_LEFT:
              kl.children[_row].children[_col]
                  .setAttribute("style", _pinky_l16);
              break;
            case Types.PINKY_UP:
              kl.children[_row].children[_col]
                  .setAttribute("style", _pinky_u16);
              break;
            case Types.PINKY_SCARE_RIGHT:
              kl.children[_row].children[_col]
                  .setAttribute("style", _scared_r16);
              break;
            case Types.PINKY_SCARE_DOWN:
              kl.children[_row].children[_col]
                  .setAttribute("style", _scared_d16);
              break;
            case Types.PINKY_SCARE_LEFT:
              kl.children[_row].children[_col]
                  .setAttribute("style", _scared_l16);
              break;
            case Types.PINKY_SCARE_UP:
              kl.children[_row].children[_col]
                  .setAttribute("style", _scared_u16);
              break;
            case Types.INKY_RIGHT:
              kl.children[_row].children[_col].setAttribute("style", _inky_r16);
              break;
            case Types.INKY_DOWN:
              kl.children[_row].children[_col].setAttribute("style", _inky_d16);
              break;
            case Types.INKY_LEFT:
              kl.children[_row].children[_col].setAttribute("style", _inky_l16);
              break;
            case Types.INKY_UP:
              kl.children[_row].children[_col].setAttribute("style", _inky_u16);
              break;
            case Types.INKY_SCARE_RIGHT:
              kl.children[_row].children[_col]
                  .setAttribute("style", _scared_r16);
              break;
            case Types.INKY_SCARE_DOWN:
              kl.children[_row].children[_col]
                  .setAttribute("style", _scared_d16);
              break;
            case Types.INKY_SCARE_LEFT:
              kl.children[_row].children[_col]
                  .setAttribute("style", _scared_l16);
              break;
            case Types.INKY_SCARE_UP:
              kl.children[_row].children[_col]
                  .setAttribute("style", _scared_u16);
              break;
            case Types.CLYDE_RIGHT:
              kl.children[_row].children[_col]
                  .setAttribute("style", _clyde_r16);
              break;
            case Types.CLYDE_DOWN:
              kl.children[_row].children[_col]
                  .setAttribute("style", _clyde_d16);
              break;
            case Types.CLYDE_LEFT:
              kl.children[_row].children[_col]
                  .setAttribute("style", _clyde_l16);
              break;
            case Types.CLYDE_UP:
              kl.children[_row].children[_col]
                  .setAttribute("style", _clyde_u16);
              break;
            case Types.CLYDE_SCARE_RIGHT:
              kl.children[_row].children[_col]
                  .setAttribute("style", _scared_r16);
              break;
            case Types.CLYDE_SCARE_DOWN:
              kl.children[_row].children[_col]
                  .setAttribute("style", _scared_d16);
              break;
            case Types.CLYDE_SCARE_LEFT:
              kl.children[_row].children[_col]
                  .setAttribute("style", _scared_l16);
              break;
            case Types.CLYDE_SCARE_UP:
              kl.children[_row].children[_col]
                  .setAttribute("style", _scared_u16);
              break;
            case Types.PACMAN_RIGHT:
              kl.children[_row].children[_col]
                  .setAttribute("style", _pacman_r16);
              break;
            case Types.PACMAN_LEFT:
              kl.children[_row].children[_col]
                  .setAttribute("style", _pacman_l16);
              break;
            case Types.PACMAN_UP:
              kl.children[_row].children[_col]
                  .setAttribute("style", _pacman_u16);
              break;
            case Types.PACMAN_DOWN:
              kl.children[_row].children[_col]
                  .setAttribute("style", _pacman_d16);
              break;
            case Types.PILL:
              kl.children[_row].children[_col].setAttribute("style", _pill16);
              break;
            case Types.POWERPILL:
              kl.children[_row].children[_col]
                  .setAttribute("style", _powerpill16);
              break;
            case Types.CHERRY:
              kl.children[_row].children[_col].setAttribute("style", _cherry16);
              break;
            case Types.APPLE:
              kl.children[_row].children[_col].setAttribute("style", _apple16);
              break;
            case Types.NOTHING:
              kl.children[_row].children[_col].setAttribute("style", "");
              break;
            default:
              break;
          }
        } else {
          switch (s) {
            case Types.WALL:
              kl.children[_row].children[_col].setAttribute("style", _wall);
              break;
            case Types.DOOR:
              kl.children[_row].children[_col].setAttribute("style", _door);
              break;
            case Types.BLINKY_RIGHT:
              kl.children[_row].children[_col].setAttribute("style", _blinky_r);
              break;
            case Types.BLINKY_DOWN:
              kl.children[_row].children[_col].setAttribute("style", _blinky_d);
              break;
            case Types.BLINKY_LEFT:
              kl.children[_row].children[_col].setAttribute("style", _blinky_l);
              break;
            case Types.BLINKY_UP:
              kl.children[_row].children[_col].setAttribute("style", _blinky_u);
              break;
            case Types.BLINKY_SCARE_RIGHT:
              kl.children[_row].children[_col].setAttribute("style", _scared_r);
              break;
            case Types.BLINKY_SCARE_DOWN:
              kl.children[_row].children[_col].setAttribute("style", _scared_d);
              break;
            case Types.BLINKY_SCARE_LEFT:
              kl.children[_row].children[_col].setAttribute("style", _scared_l);
              break;
            case Types.BLINKY_SCARE_UP:
              kl.children[_row].children[_col].setAttribute("style", _scared_u);
              break;
            case Types.PINKY_RIGHT:
              kl.children[_row].children[_col].setAttribute("style", _pinky_r);
              break;
            case Types.PINKY_DOWN:
              kl.children[_row].children[_col].setAttribute("style", _pinky_d);
              break;
            case Types.PINKY_LEFT:
              kl.children[_row].children[_col].setAttribute("style", _pinky_l);
              break;
            case Types.PINKY_UP:
              kl.children[_row].children[_col].setAttribute("style", _pinky_u);
              break;
            case Types.PINKY_SCARE_RIGHT:
              kl.children[_row].children[_col].setAttribute("style", _scared_r);
              break;
            case Types.PINKY_SCARE_DOWN:
              kl.children[_row].children[_col].setAttribute("style", _scared_d);
              break;
            case Types.PINKY_SCARE_LEFT:
              kl.children[_row].children[_col].setAttribute("style", _scared_l);
              break;
            case Types.PINKY_SCARE_UP:
              kl.children[_row].children[_col].setAttribute("style", _scared_u);
              break;
            case Types.INKY_RIGHT:
              kl.children[_row].children[_col].setAttribute("style", _inky_r);
              break;
            case Types.INKY_DOWN:
              kl.children[_row].children[_col].setAttribute("style", _inky_d);
              break;
            case Types.INKY_LEFT:
              kl.children[_row].children[_col].setAttribute("style", _inky_l);
              break;
            case Types.INKY_UP:
              kl.children[_row].children[_col].setAttribute("style", _inky_u);
              break;
            case Types.INKY_SCARE_RIGHT:
              kl.children[_row].children[_col].setAttribute("style", _scared_r);
              break;
            case Types.INKY_SCARE_DOWN:
              kl.children[_row].children[_col].setAttribute("style", _scared_d);
              break;
            case Types.INKY_SCARE_LEFT:
              kl.children[_row].children[_col].setAttribute("style", _scared_l);
              break;
            case Types.INKY_SCARE_UP:
              kl.children[_row].children[_col].setAttribute("style", _scared_u);
              break;
            case Types.CLYDE_RIGHT:
              kl.children[_row].children[_col].setAttribute("style", _clyde_r);
              break;
            case Types.CLYDE_DOWN:
              kl.children[_row].children[_col].setAttribute("style", _clyde_d);
              break;
            case Types.CLYDE_LEFT:
              kl.children[_row].children[_col].setAttribute("style", _clyde_l);
              break;
            case Types.CLYDE_UP:
              kl.children[_row].children[_col].setAttribute("style", _clyde_u);
              break;
            case Types.CLYDE_SCARE_RIGHT:
              kl.children[_row].children[_col].setAttribute("style", _scared_r);
              break;
            case Types.CLYDE_SCARE_DOWN:
              kl.children[_row].children[_col].setAttribute("style", _scared_d);
              break;
            case Types.CLYDE_SCARE_LEFT:
              kl.children[_row].children[_col].setAttribute("style", _scared_l);
              break;
            case Types.CLYDE_SCARE_UP:
              kl.children[_row].children[_col].setAttribute("style", _scared_u);
              break;
            case Types.PACMAN_RIGHT:
              kl.children[_row].children[_col].setAttribute("style", _pacman_r);
              break;
            case Types.PACMAN_LEFT:
              kl.children[_row].children[_col].setAttribute("style", _pacman_l);
              break;
            case Types.PACMAN_UP:
              kl.children[_row].children[_col].setAttribute("style", _pacman_u);
              break;
            case Types.PACMAN_DOWN:
              kl.children[_row].children[_col].setAttribute("style", _pacman_d);
              break;
            case Types.PILL:
              kl.children[_row].children[_col].setAttribute("style", _pill);
              break;
            case Types.POWERPILL:
              kl.children[_row].children[_col]
                  .setAttribute("style", _powerpill);
              break;
            case Types.CHERRY:
              kl.children[_row].children[_col].setAttribute("style", _cherry);
              break;
            case Types.APPLE:
              kl.children[_row].children[_col].setAttribute("style", _apple);
              break;
            case Types.NOTHING:
              kl.children[_row].children[_col].setAttribute("style", "");
              break;
            default:
              break;
          }
        }
        _col++;
      }
      _col = 0;
      _row++;
    }
  }

  /**
   * display the current level
   */
  void updateLevel(int level) {
    _level.innerHtml = " $level";
  }

  /**
   * display the current score
   */
  void updateScore(int score) {
    _score.innerHtml = " $score";
  }

  /**
   * display the current number of lives
   */
  void updateLives(int lives) {
    _lives.innerHtml = " $lives";
  }

  /**
   * display the powerUp duration time
   */
  void updatePowerUpTime(int time) {
    if(time == -1){
      _time.innerHtml = "";
    }
    else {
      _time.innerHtml = " $time";
    }
  }

  /**
   * dispaly the mobile keys, when a mobile device is used
   */
  void showMobile() {
    _mobile.style.display = "block";
  }

  /**
   * display the gamekey status
   */
  void updateMessages(String str, bool f) {
    if (f) {
      _message.style.color = "yellow";
      _message.style.border = "5px solid yellow";
    } else {
      _message.style.color = "red";
      _message.style.border = "5px solid yellow";
    }
    _message.innerHtml = str;
  }
}
