part of pacmanLib;

class Level {
  num _sizeX;
  num _sizeY;
  num _lives;
  num _scorePill;
  num _scoreCherry;
  num _scorePowerPill;

  Pacman _pacman;
  Directions _pacmanDir = Directions.RIGHT;
  Types _pacmanPre = Types.PACMAN_RIGHT;

  List<List<Tile>> _tiles = new List<List<Tile>>();
  PacmanGameModel _model;

  /**
   * Creates a level by given parameters
   */
  Level(String environmentCode, num sizeX, num sizeY, int lives, num scorePill,
      num scoreCherry, num scorePowerPill, PacmanGameModel model) {
    this._sizeX = sizeX;
    this._sizeY = sizeY;
    this._model = model;
    this._lives = lives;
    this._scorePill = scorePill;
    this._scoreCherry = scoreCherry;
    this._scorePowerPill = scorePowerPill;
    initTiles();
    createObjects(environmentCode);
  }

  int get pacmanX => _pacman._x;
  int get pacmanY => _pacman._y;

  void set pacmanDir(Directions dir) {
    this._pacmanDir = dir;
  }

  /**
   * checks if the given [GameElement] collides with another [GameElement]
   * return true if the object collides with another one, else false
   */
  bool checkCollision(int x, int y, GameElement g) {
    // no Statics
    if (_tiles[y][x]._environment == null) return false;
    // ghosts collides
    if (_tiles[y][x]._environment._collisionGhost == true && g is Ghost)
      return true;
    // pacman collides
    if (_tiles[y][x]._environment._collisionPlayer == true && g is Pacman)
      return true;
    // no collision
    return false;
  }

  /**
   * Register a [GameElement] on a new position.
   * xOld and yOld is the old position and xNew and yNew the new one. g is a reference on the moving objekt.
   */
  void registerElement(int xOld, int yOld, int xNew, int yNew, GameElement g) {
    // position not correct
    assert(!this.checkCollision(xNew, yNew, g));
    // pacman chance position
    if (g is Pacman) {
      _tiles[yOld][xOld]._pacman = null;
      _tiles[yNew][xNew]._pacman = g;
      this.collisionDetectionItem(xNew, yNew);
      this.collisionDetectionGhost(xNew, yNew);
    }
    // ghost chance position
    if (g is Ghost) {
      _tiles[yOld][xOld]._ghosts.remove(g);
      _tiles[yNew][xNew]._ghosts.add(g);
      this.collisionDetectionGhost(xNew, yNew);
    }
  }

  /**
   * return the full gameField as list over list with enum [Type]
   */
  List<List<Types>> getMap() {
    /*
         * if more ghosts of pacman and ghosts on the same field the following priority are used:
         * if pacman on a field, only pacman is returned
         * if two or more ghost on one field, only the first ghost in list is returned
         */
    List<List<Types>> ret = new List<List<Types>>();
    for (int y = 0; y < _sizeY; y++) {
      ret.add(new List());
      for (int x = 0; x < _sizeX; x++) {
        final tile = _tiles[y][x];

        // pacman
        if (tile._pacman != null)
          switch (_pacmanDir) {
          case Directions.UP:
            ret[y].add(Types.PACMAN_UP);
            _pacmanPre = Types.PACMAN_UP;
            break;
          case Directions.DOWN:
            ret[y].add(Types.PACMAN_DOWN);
            _pacmanPre = Types.PACMAN_DOWN;
            break;
          case Directions.LEFT:
            ret[y].add(Types.PACMAN_LEFT);
            _pacmanPre = Types.PACMAN_LEFT;
            break;
          case Directions.RIGHT:
            ret[y].add(Types.PACMAN_RIGHT);
            _pacmanPre = Types.PACMAN_RIGHT;
            break;
          default:
            ret[y].add(_pacmanPre);
            break;
        }

        // ghosts
        else if (tile._ghosts.length != 0) {
          // blinky
          if (tile._ghosts[0] is Blinky)
            ret[y].add(Types.BLINKY);
          // pinky
          else if (tile._ghosts[0] is Pinky)
            ret[y].add(Types.PINKY);
          // inky
          else if (tile._ghosts[0] is Inky)
            ret[y].add(Types.INKY);
          // clyde
          else if (tile._ghosts[0] is Clyde) ret[y].add(Types.CLYDE);
        }
        // items
        else if (tile._item != null) {
          // pill
          if (tile._item is Pill && tile._item._visible)
            ret[y].add(Types.PILL);
          // powerpill
          else if (tile._item is PowerPill && tile._item._visible)
            ret[y].add(Types.POWERPILL);
          // cherry
          else if (tile._item is Cherry && tile._item._visible)
            ret[y].add(Types.CHERRY);
          else
            ret[y].add(Types.NOTHING);
        } // environments
        else if (tile._environment != null) {
          // door
          if (tile._environment._door)
            ret[y].add(Types.DOOR);
          // wall
          else if (tile._environment._collisionPlayer) ret[y].add(Types.WALL);
        } else
          ret[y].add(Types.NOTHING);
      }
    }
    return ret;
  }

  /*
  Helper methods
   */

  void createObjects(String environmentCode) {
    // Split string in lines
    List<String> lines = environmentCode.split(LevelLoader.NEWLINE);
    // compatible to size?
    if (lines.length != _sizeY) {
      // TODO log
      return;
    }
    for (int y = 0; y < _sizeY; y++) {
      String line = lines[y];
      for (int x = 0; x < _sizeX; x++) {
        switch (line[x]) {
          case LevelLoader.WALL:
            _tiles[y][x]._environment =
                new Environment(x, y, true, true, false, false);
            break;

          case LevelLoader.PILL:
            _tiles[y][x]._item =
                new Pill(x, y, true, false, true, _scorePill, _model);
            break;

          case LevelLoader.POWERPILL:
            _tiles[y][x]._item =
                new PowerPill(x, y, true, false, true, _scorePowerPill, _model);
            break;

          case LevelLoader.CHERRY:
            _tiles[y][x]._item =
                new Cherry(x, y, true, false, true, _scoreCherry, _model);
            break;

          case LevelLoader.INKY:
            Ghost g = new Inky(x, y, false, false, this);
            _tiles[y][x]._ghosts.add(g);
            _model.registerGameElement(g);

            break;

          case LevelLoader.PINKY:
            Ghost g = new Pinky(x, y, false, false, this);
            _tiles[y][x]._ghosts.add(g);
            _model.registerGameElement(g);
            break;

          case LevelLoader.CLYDE:
            Ghost g = new Clyde(x, y, false, false, this);
            _tiles[y][x]._ghosts.add(g);
            _model.registerGameElement(g);
            break;

          case LevelLoader.BLINKY:
            Ghost g = new Blinky(x, y, false, false, this);
            _tiles[y][x]._ghosts.add(g);
            _model.registerGameElement(g);
            break;

          case LevelLoader.PACMAN:
            _pacman = new Pacman(x, y, false, true, _lives, this, _model);
            _tiles[y][x]._pacman = _pacman;
            _model.registerGameElement(_pacman);
            break;

          case LevelLoader.DOOR:
            _tiles[y][x]._environment =
                new Environment(x, y, true, false, false, true);
            break;

          default:
            break;
        }
      }
    }
  }

  void initTiles() {
    for (int i = 0; i < _sizeY; i++) {
      List<Tile> list = new List();
      for (int j = 0; j < _sizeX; j++) {
        list.add(new Tile());
      }
      _tiles.add(list);
    }
  }

  void collisionDetectionItem(int x, int y) {
    // no collision possible, pacman is not here
    if (_tiles[y][x]._pacman == null) return;
    // pacman collides with item
    if (_tiles[y][x]._item != null) {
      _tiles[y][x]._item.pickUp();
    }
  }

  void collisionDetectionGhost(int x, int y) {
    // ghost collides with pacman
    if (_tiles[y][x]._pacman != null && _tiles[y][x]._ghosts.length != 0) {
      _tiles[y][x]._pacman.decreaseLife();
    }
  }
}
