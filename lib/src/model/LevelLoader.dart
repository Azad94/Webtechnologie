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
   * time(frames) when Blinky starts moving
   */
  static num _startBlinky = 0;

  /**
   * time(frames) when Clyde starts moving
   */
  static num _startClyde = 0;

  /**
   * time(frames) when Inky starts moving
   */
  static num _startInky = 0;

  /**
   * time(frames) when Pinky starts moving
   */
  static num _startPinky = 0;

  /**
   * current level number
   */
  static num _levelNumber = -1;

  /**
   * width field size
   */
  static num _sizeX;

  /**
   * height field size
   */
  static num _sizeY;

  /* gerneral const */

  /**
   * score of one pill
   */
  static num _scorePill = -1;

  /**
   * score of one powerPill
   */
  static num _scorePowerPill = -1;

  /**
   * score of one cherry
   */
  static num _scoreCherry = -1;

  /**
   * basic score for one ghost
   */
  static num _scoreGhost = -1;

  static String _gamekeyHost;
  static num _gamekeyPort;
  static String _gamekeyID;
  static String _gamekeySecret;

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

  static const _CONFIG_JSON = "GameConfig.json";

  /**
   * Loads a level from json file by given level number.
   * Return true if file is loaded, else false
   */
  static Future loadLevel(int level) async {
    String json = await HttpRequest.getString("${level}_Level.json");
    final data = JSON.decode(json);
    _levelNumber = data["level"];
    _sizeX = data["sizeX"];
    _sizeY = data["sizeY"];
    _map = data["map"];
    _lives = data["lives"];
    _eatTime = data["ghostEatTime"];
    _startBlinky = data["startBlinky"];
    _startClyde = data["startClyde"];
    _startInky = data["startInky"];
    _startPinky = data["startPinky"];
    _loaded = true;
    return true;
  }

  static Future<bool> loadConfig() async {
    String json = await HttpRequest.getString(_CONFIG_JSON);
    final data = JSON.decode(json);
    _scorePill = data["scorePill"];
    _scorePowerPill = data["scorePowerPill"];
    _scoreCherry = data["scoreCherry"];
    _scoreGhost = data["scoreSingleGhost"];
    _gamekeyHost = data["GamekeyHost"];
    _gamekeyPort = data["GamekeyPort"];
    _gamekeyID = data["GamekeyID"];
    _gamekeySecret = data["GamekeySecret"];

    return true;
  }
}
