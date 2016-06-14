part of pacmanModelLib;

/**
 * Represents one level. A level includes the map and all meta data, like lives, score etc.
 * The level also detect collision of two [GameElement]s.
 */
class Level {
  /**
   * field size X
   */
  num _sizeX;

  /**
   * field size Y
   */
  num _sizeY;

  /**
   * number of level
   */
  num _levelNumber;

  /**
   * x position of the door
   */
  num _doorX;

  /**
   * y position of the door
   */
  num _doorY;

  /**
   * number of lives for [Pacman]
   */
  num _lives;

  /**
   * time (frames) who long the [Ghost]s are in eatable mode
   */
  num _eatTime;

  /**
   * time(frames) when Blinky starts moving
   */
  num _startBlinky;

  /**
   * time(frames) when Clyde starts moving
   */
  num _startClyde;

  /**
   * time(frames) when Inky starts moving
   */
  num _startInky;

  /**
   * time(frames) when Pinky starts moving
   */
  num _startPinky;

  /**
   * score for one single [Pill]
   */
  num _scorePill;

  /**
   * score for one single [Cherry]
   */
  num _scoreCherry;

  /**
   * score for one single [PowerPill]
   */
  num _scorePowerPill;

  /**
   * score for on single [Ghost]
   */
  num _scoreGhost;

  /**
   * X position for entry to bonus level
   */
  num _portX;

  /**
   * Y position for entry to bonus level
   */
  num _portY;

  /**
   * time(frames) how long entry to bonus level is open
   */
  num _openTime;

  /**
   * hast level a bonus level?
   */
  bool _hasBonus = false;

  /**
   * reference to [Pacman]
   */
  Pacman _pacman;

  /**
   * score of the level
   */
  Score _score;

  /**
   * [Pacman]s next [Directions]
   */
  Directions _pacmanDir = Directions.RIGHT;

  /**
   * [Pacman]s previous direction
   */
  Types _pacmanPre = Types.PACMAN_RIGHT;

  /**
   * Direction of [Inky]
   */
  Directions _inkyDir = Directions.UP;

  /**
   * Direction of [Pinky]
   */
  Directions _pinkyDir = Directions.UP;

  /**
   * Direction of [Blinky]
   */
  Directions _blinkyDir = Directions.UP;

  /**
   * Direction of [Clyde]
   */
  Directions _clydeDir = Directions.UP;

  /**
   * gamefiled as [List] over [List] of [Tile]s
   */
  List<List<Tile>> _tiles = new List<List<Tile>>();

  /**
   * model
   */
  PacmanGameModel _model;

  /**
   * Creates a level by given parameters
   */
  Level(
      String environmentCode,
      this._sizeX,
      this._sizeY,
      this._levelNumber,
      this._lives,
      this._scorePill,
      this._scoreCherry,
      this._scorePowerPill,
      this._scoreGhost,
      this._eatTime,
      this._startBlinky,
      this._startClyde,
      this._startInky,
      this._startPinky,
      this._model,
      [this._portX,
      this._portY,
      this._openTime]) {
    _score = new Score();
    if (_portX != null && _portY != null && _openTime != null) _hasBonus = true;
    initTiles();
    createObjects(environmentCode);
  }

  /**
   * Getter for [Pacman]s x position
   */
  int get pacmanX => _pacman._x;

  /**
   * Getter for [Pacman]s y position
   */
  int get pacmanY => _pacman._y;

  /**
   * Getter for current score
   */
  int get score => _score.totalScore;

  /**
   * getter for field size X
   */
  int get width => _sizeX;

  /**
   * getter for field size Y
   */
  int get height => _sizeY;

  /**
   * get x position of the door
   */
  int get doorX => _doorX;

  /**
   * get y position of the door
   */
  int get doorY => _doorY;

  /**
   * Setter to chance [Pacman]s next direction
   */
  void set pacmanDir(Directions dir) {
    this._pacmanDir = dir;
  }

  /**
   * checks if the given [GameElement] collides on a given position with a [Environment]
   * return true if the object collides with another one, if not false; error: null
   */
  bool checkCollision(int x, int y, GameElement g) {
    if (x == null || y == null || g == null) {
      print("Level.checkCollision(): param null");
      return false;
    }
    // position outside field
    if (x < 0 || x >= _sizeX || y < 0 || y >= _sizeY) return true;
    final tile = _tiles[y][x];
    // calculate side of the collision
    Directions side = getDirection(g._x, g._y, x, y);
    // no Statics
    if (tile._environment == null) return false;
    // ghosts collides
    if (tile._environment._collisionGhost == true && g is Ghost) {
      // is a side where is no collision
      if (tile._environment._noCollisionSidesGhost != null) {
        //check if side in list and calculate side is the same, if yes no collision
        for (int i = 0;
            i < tile._environment._noCollisionSidesGhost.length;
            i++)
          if (tile._environment._noCollisionSidesGhost[i] == side) return false;
      }
      return true;
    }

    // pacman collides
    if (tile._environment._collisionPlayer == true && g is Pacman) {
      // is a side where is no collision
      if (tile._environment._noCollisionSidesPlayer != null) {
        //check if side in list and calculate side is the same, if yes no collision
        for (int i = 0;
            i < tile._environment._noCollisionSidesPlayer.length;
            i++)
          if (tile._environment._noCollisionSidesPlayer[i] == side)
            return false;
      }
      return true;
    }
    // no collision
    return false;
  }

  /**
   * Register a [GameElement] on a new position.
   * xOld and yOld is the old position and xNew and yNew the new one. g is a reference on the moving objekt.
   */
  void registerElement(int xOld, int yOld, int xNew, int yNew, GameElement g) {
    if (xOld == null ||
        yOld == null ||
        xNew == null ||
        yNew == null ||
        g == null) {
      print("Level.registerElement(): param null");
      return;
    }
    // position not correct
    assert(!this.checkCollision(xNew, yNew, g));
    // pacman chance position
    if (g is Pacman) {
      _tiles[yOld][xOld]._pacman = null;
      _tiles[yNew][xNew]._pacman = g;
      this.collisionDetectionItem(xNew, yNew);
      this.collisionDetectionGhost(xNew, yNew);
      // entry bonus level
      if (_hasBonus && xNew == _portX && yNew == _portY) {
        _model._joinBonusLevel();
      }
    }
    // ghost chance position
    if (g is Ghost) {
      _tiles[yOld][xOld]._ghosts.remove(g);
      _tiles[yNew][xNew]._ghosts.add(g);
      this.collisionDetectionGhost(xNew, yNew);
      Directions dir = getDirection(xOld, yOld, xNew, yNew);
      if (g is Blinky) _blinkyDir = dir;
      if (g is Inky) _inkyDir = dir;
      if (g is Pinky) _pinkyDir = dir;
      if (g is Clyde) _clydeDir = dir;
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
        if (tile._pacman != null) {
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
        }
        // ghosts
        else if (tile._ghosts.length != 0) {
          Ghost ghost = tile._ghosts[0];
          // Blinky
          if (ghost is Blinky) {
            switch (_blinkyDir) {
              case Directions.LEFT:
                if (ghost.eatable)
                  ret[y].add(Types.BLINKY_SCARE_LEFT);
                else
                  ret[y].add(Types.BLINKY_LEFT);
                break;
              case Directions.RIGHT:
                if (ghost.eatable)
                  ret[y].add(Types.BLINKY_SCARE_RIGHT);
                else
                  ret[y].add(Types.BLINKY_RIGHT);
                break;
              case Directions.UP:
                if (ghost.eatable)
                  ret[y].add(Types.BLINKY_SCARE_UP);
                else
                  ret[y].add(Types.BLINKY_UP);
                break;
              case Directions.DOWN:
                if (ghost.eatable)
                  ret[y].add(Types.BLINKY_SCARE_DOWN);
                else
                  ret[y].add(Types.BLINKY_DOWN);
                break;
              default:
                break;
            }
          }
          // Inky
          if (ghost is Inky) {
            switch (_inkyDir) {
              case Directions.LEFT:
                if (ghost.eatable)
                  ret[y].add(Types.INKY_SCARE_LEFT);
                else
                  ret[y].add(Types.INKY_LEFT);
                break;
              case Directions.RIGHT:
                if (ghost.eatable)
                  ret[y].add(Types.INKY_SCARE_RIGHT);
                else
                  ret[y].add(Types.INKY_RIGHT);
                break;
              case Directions.UP:
                if (ghost.eatable)
                  ret[y].add(Types.INKY_SCARE_UP);
                else
                  ret[y].add(Types.INKY_UP);
                break;
              case Directions.DOWN:
                if (ghost.eatable)
                  ret[y].add(Types.INKY_SCARE_DOWN);
                else
                  ret[y].add(Types.INKY_DOWN);
                break;
              default:
                break;
            }
          }
          // Pinky
          if (ghost is Pinky) {
            switch (_pinkyDir) {
              case Directions.LEFT:
                if (ghost.eatable)
                  ret[y].add(Types.PINKY_SCARE_LEFT);
                else
                  ret[y].add(Types.PINKY_LEFT);
                break;
              case Directions.RIGHT:
                if (ghost.eatable)
                  ret[y].add(Types.PINKY_SCARE_RIGHT);
                else
                  ret[y].add(Types.PINKY_RIGHT);
                break;
              case Directions.UP:
                if (ghost.eatable)
                  ret[y].add(Types.PINKY_SCARE_UP);
                else
                  ret[y].add(Types.PINKY_UP);
                break;
              case Directions.DOWN:
                if (ghost.eatable)
                  ret[y].add(Types.PINKY_SCARE_DOWN);
                else
                  ret[y].add(Types.PINKY_DOWN);
                break;
              default:
                break;
            }
          }
          // Clyde
          if (ghost is Clyde) {
            switch (_clydeDir) {
              case Directions.LEFT:
                if (ghost.eatable)
                  ret[y].add(Types.CLYDE_SCARE_LEFT);
                else
                  ret[y].add(Types.CLYDE_LEFT);
                break;
              case Directions.RIGHT:
                if (ghost.eatable)
                  ret[y].add(Types.CLYDE_SCARE_RIGHT);
                else
                  ret[y].add(Types.CLYDE_RIGHT);
                break;
              case Directions.UP:
                if (ghost.eatable)
                  ret[y].add(Types.CLYDE_SCARE_UP);
                else
                  ret[y].add(Types.CLYDE_UP);
                break;
              case Directions.DOWN:
                if (ghost.eatable)
                  ret[y].add(Types.CLYDE_SCARE_DOWN);
                else
                  ret[y].add(Types.CLYDE_DOWN);
                break;
              default:
                break;
            }
          }
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
        }
        // environments
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

  /**
   * ends eatable mode
   */
  void endEatableMode() => _score._resetGhostMultiplier();

  /**
   * Removes a Wall for entering into bonus level
   */
  void _openWall() {
    _tiles[_portY][_portX]._environment = null;
  }

  /**
   * add the Wall, where wall for bonus level was removed
   */
  void _closeWall() {
    _tiles[_portY][_portX]._environment =
        new Environment(_portX, _portY, true, true, false, false, null, null);
  }

  /*
  Helper methods
   */
////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /**
   *  DO NOT CALL; PRIVATE
   * creates all game objects and put them into the game field (_tiles).
   * Needs a [String] with the map coding
   *
   */
  void createObjects(String environmentCode) {
    if (environmentCode == null) {
      print("Level.createObjects(): param null");
      return;
    }
    // Split string in lines
    List<String> lines = environmentCode.split(LevelLoader.NEWLINE);
    try {
      for (int y = 0; y < _sizeY; y++) {
        String line = lines[y];
        for (int x = 0; x < _sizeX; x++) {
          switch (line[x]) {
            case LevelLoader.WALL:
              _tiles[y][x]._environment =
                  new Environment(x, y, true, true, false, false, null, null);
              break;

            case LevelLoader.PILL:
              _tiles[y][x]._item =
                  new Pill(x, y, true, false, true, _scorePill, _model);
              break;

            case LevelLoader.POWERPILL:
              _tiles[y][x]._item = new PowerPill(
                  x, y, true, false, true, _scorePowerPill, _model);
              break;

            case LevelLoader.CHERRY:
              Item i;
              if (_hasBonus) {
                i = new Cherry(
                    x, y, true, false, true, _scoreCherry, _model, _openTime);
              } else {
                i = new Cherry(x, y, true, false, true, _scoreCherry, _model);
              }
              _tiles[y][x]._item = i;
              _model._registerGameElement(i);
              break;

            case LevelLoader.INKY:
              Ghost g = new Inky(
                  x, y, false, false, this, _eatTime, _startInky, _scoreGhost);
              _tiles[y][x]._ghosts.add(g);
              _model._registerGameElement(g);

              break;

            case LevelLoader.PINKY:
              Ghost g = new Pinky(
                  x, y, false, false, this, _eatTime, _startPinky, _scoreGhost);
              _tiles[y][x]._ghosts.add(g);
              _model._registerGameElement(g);
              break;

            case LevelLoader.CLYDE:
              Ghost g = new Clyde(
                  x, y, false, false, this, _eatTime, _startClyde, _scoreGhost);
              _tiles[y][x]._ghosts.add(g);
              _model._registerGameElement(g);
              break;

            case LevelLoader.BLINKY:
              Ghost g = new Blinky(x, y, false, false, this, _eatTime,
                  _startBlinky, _scoreGhost);
              _tiles[y][x]._ghosts.add(g);
              _model._registerGameElement(g);
              break;

            case LevelLoader.PACMAN:
              _pacman = new Pacman(x, y, false, true, _lives, this, _model);
              _tiles[y][x]._pacman = _pacman;
              _model._registerGameElement(_pacman);
              break;

            case LevelLoader.DOOR:
              // set UP as no collision
              List<Directions> noCollision = new List();
              noCollision.add(Directions.UP);
              _tiles[y][x]._environment = new Environment(
                  x, y, true, false, false, true, noCollision, null);
              // set door position
              _doorX = x;
              _doorY = y;
              break;

            default:
              break;
          }
        }
      }
    } catch (error, stackTrace) {
      print("Level.createObjects() caused following error: $error");
      print(stackTrace);
      _model._errorScreen();
      return;
    }
  }

  /**
   * DO NOT CALL; PRIVATE
   * initialize the _tiles
   */
  void initTiles() {
    if (_sizeX == null || _sizeY == null) {
      print("Level.initTiles(): size null");
      return;
    }
    for (int i = 0; i < _sizeY; i++) {
      List<Tile> list = new List();
      for (int j = 0; j < _sizeX; j++) {
        list.add(new Tile());
      }
      _tiles.add(list);
    }
  }

  /**
   * DO NOT CALL; PRIVATE
   * checks if [Pacman] collides with a Item on the given position
   */
  void collisionDetectionItem(int x, int y) {
    if (x == null || y == null) {
      print("Level.collisionDetectionItem(): param null");
      return;
    }
    // no collision possible, pacman is not here
    if (_tiles[y][x]._pacman == null) return;
    // pacman collides with item
    if (_tiles[y][x]._item != null) {
      if (_tiles[y][x]._item._visible)
        _score._addScore(_tiles[y][x]._item._score, _tiles[y][x]._item);
      _tiles[y][x]._item._pickUp();
    }
  }

  /**
   * DO NOT CALL; PRIVATE
   * checks if [Pacman] collides with a ghost on the given position
   */
  void collisionDetectionGhost(int x, int y) {
    if (x == null || y == null) {
      print("Level.collisionDetectionGhost(): param null");
      return;
    }
    // ghost collides with pacman
    if (_tiles[y][x]._pacman != null && _tiles[y][x]._ghosts.length != 0) {
      if (_tiles[y][x]._ghosts[0]._eatable) {
        final g = _tiles[y][x]._ghosts[0];
        g.respwan();
        _score._addScore(g._score, g);
        _score._incGhostMultiplier();
      } else {
        final Pacman p = _tiles[y][x]._pacman;
        p._decreaseLife();
        p._respawn();
        _model._respawnGhosts();
        _score._resetGhostMultiplier();
      }
    }
  }

  /**
   * DO NOT CALL; PRIAVTE
   * calculate the direction
   */
  Directions getDirection(int xOld, int yOld, int xNew, int yNew) {
    if (xOld == null || yOld == null || xNew == null || yNew == null) {
      print("Level.getDirection(): param null");
      return null;
    }
    Directions ret = Directions.NOTHING;
    int diff_x = xOld - xNew;
    int diff_y = yOld - yNew;
    if (diff_x == -1)
      ret = Directions.RIGHT;
    else if (diff_x == 1)
      ret = Directions.LEFT;
    else if (diff_y == -1)
      ret = Directions.DOWN;
    else
      ret = Directions.UP;
    return ret;
  }
}
