part of pacmanLib;

// TODO exception handling and logging
class LevelLoader {
  /**
   * indicates if a file is loaded
   */
  static bool _loaded = false;

  /**
   * the map coded as [String]
   */
  static String _map = null;

  /**
   * lives of Pacman
   */
  static num _lives = -1;

  /**
   * time(frames) where ghosts are eatable
   */
  static num _eatTime = 0;

  /**
   * current level number
   */
  static num levelNumber = -1;

  /**
   * width field size
   */
  static num sizeX;

  /**
   * height field size
   */
  static num sizeY;

  /* gerneral const */

  /**
   * score of one pill
   */
  static num SCORE_PILL = -1;

  /**
   * score of one powerPill
   */
  static num SCORE_POWERPILL = -1;

  /**
   * score of one cherry
   */
  static num SCORE_CHERRY = -1;

  /*
  MapCode
   */
  /**
   *character for a new line
   */
  static const NEWLINE = "/";

  /**
   * character for a wall
   */
  static const WALL = "#";

  /**
   * character for a pill
   */
  static const PILL = "*";

  /**
   * charactor for power pill
   */
  static const POWERPILL = "+";

  /**
   * character for cherry
   */
  static const CHERRY = "^";

  /**
   * character for Ghost
   */
  static const GHOST = "G";

  /**
   * character for Pinky
   */
  static const PINKY = "Y";

  /**
   * character for Clyde
   */
  static const CLYDE = "C";

  /**
   * character for Blinky
   */
  static const BLINKY = "B";

  /**
   * character for Inky
   */
  static const INKY = "I";

  /**
   * character for Pacman
   */
  static const PACMAN = "P";

  /**
   * character for door
   */
  static const DOOR = "~";

  /**
   * charater for nothing
   */
  static const NOTHING = "X";

  static const _CONFIGJSON = "GameConfig.json";


  /**
   * Loads a level from json file by given level number.
   * Return true if file is loaded, else false
   */
  static bool loadLevel(int level) {
    HttpRequest.getString("${level}_Level.json").then((json) {
      final data = JSON.decode(json);
      levelNumber = data["level"];
      sizeX = data["sizeX"];
      sizeY = data["sizeY"];
      _map = data["map"];
      _lives = data["lives"];
      _eatTime = data["ghostEatTime"];
    });
    _loaded = true;
    return true;
  }

  static bool loadConfig() {
    HttpRequest.getString(_CONFIGJSON).then((json) {
      final data = JSON.decode(json);
      SCORE_PILL = data["scorePill"];
      SCORE_POWERPILL = data["scorePowerPill"];
      SCORE_CHERRY = data["scoreCherry"];
    });

    return true;
  }
}
