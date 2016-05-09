part of pacmanLib;

class LevelLoader {
  /**
   * indicates if a file is loaded
   */
  static bool _loaded = false;

  /**
   * the map coded as [String]
   */
  static String _map = null;

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

  // TODO choose level
  // Path for json files? Fix hard coding of path
  static const jsonLevel =
      "C:/Users/Niklas/WebstormProjects/Webtechnologie/lib/src/model/1_Level.json";

  /**
   * Loads a level from json file by given level number.
   * Return true if file is loaded, else false
   */
  static bool loadLevel(int level) {
    // TODO exception handling and logging
    io.File f = new io.File(jsonLevel);
    String json =  f.readAsStringSync(encoding: const Utf8Codec());

    Map data = JSON.decode(json);
    levelNumber = data["level"];
    sizeX = data["sizeX"];
    sizeY = data["sizeY"];
    _map = data["map"];
    _lives = data["lives"];

    _loaded = true;
    return true;
  }
}
