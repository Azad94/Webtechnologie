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
  static int _lives = -1;

  /**
   * current level number
   */
  static int levelNumber = -1;

  /**
   * width field size
   */
  static int sizeX;

  /**
   * height field size
   */
  static int sizeY;

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

  static const _CONFIGJSON = "lib/GameConfig.json";

  // TODO choose level
  // Path for json files? Fix hard coding of path
  static const _jsonLevel = "lib/1_Level.json";

  /**
   * Loads a level from json file by given level number.
   * Return true if file is loaded, else false
   */
  static bool loadLevel(int level) {
    File f = new File(_jsonLevel);
    String json = f.readAsStringSync(encoding: const Utf8Codec());

    Map data = JSON.decode(json);
    levelNumber = data["level"];
    sizeX = data["sizeX"];
    sizeY = data["sizeY"];
    _map = data["map"];
    _lives = data["lives"];

    _loaded = true;
    return true;
  }

  static bool loadConfig() {
    File f = new File(_CONFIGJSON);
    String json = f.readAsStringSync(encoding: const Utf8Codec());

    Map data = JSON.decode(json);
    SCORE_PILL = data["scorePill"];
    SCORE_POWERPILL = data["scorePowerPill"];
    SCORE_CHERRY = data["scoreCherry"];

    return true;
  }
}
