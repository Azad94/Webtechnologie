part of pacmanLib;

//shadow
class Blinky extends Ghost {
  Level _level;
  bool eatable = false;

  int x1 = 5;
  int y1 = 5;

 Directions nextMove;

  Blinky(int x, int y, bool collPlayer, bool collGhost, Level l)
      : super(x, y, collPlayer, collGhost, l);



//gibt die bisher beste Liste zurück
  List<Directions> getRoute() {
    List<Directions> route = new List();
    return getRouteRecursive(route, _x, _y);
  }

  List<Directions> getRouteRecursive(
      List<Directions> prev, int routeX, int routeY) {
    if (prev.length > 10) {
      return prev;
    }

    List<Directions> left;
    List<Directions> up;
    List<Directions> right;
    List<Directions> down;
    List<Directions> best = new List();

      // requires better interface to differentiate collisions from finding pacman
      if ((prev.length == 0 || prev.last != Directions.RIGHT) &&
          !_level.checkCollision(routeX + 1, routeY, this)) {
        if (routeX + 1 == x1 && routeY == y1) {
          prev.add(Directions.RIGHT);
          right = prev;
        } else {
          prev.add(Directions.RIGHT);
          right = getRouteRecursive(prev, routeX + 1, routeY);
        }
      }
      if ((prev.length == 0 || prev.last != Directions.UP) &&
          !_level.checkCollision(routeX, routeY + 1, this)) {
        if (routeX == x1 && routeY + 1 == y1) {
          prev.add(Directions.UP);
          up = prev;
        } else {
          prev.add(Directions.UP);
          up = getRouteRecursive(prev, routeX, routeY + 1);
        }
      }
      if ((prev.length == 0 || prev.last != Directions.LEFT) &&
          !_level.checkCollision(routeX - 1, routeY, this)) {
        if (routeX - 1 == x1 && routeY == y1) {
          prev.add(Directions.LEFT);
          left = prev;
        } else {
          prev.add(Directions.LEFT);
          left = getRouteRecursive(prev, routeX - 1, routeY);
        }
      }
      if ((prev.length == 0 || prev.last != Directions.DOWN) &&
          !_level.checkCollision(routeX, routeY - 1, this)) {
        if (routeX + 1 == x1 && routeY == y1) {
          prev.add(Directions.DOWN);
          down = prev;
        } else {
          prev.add(Directions.DOWN);
          down = getRouteRecursive(prev, routeX, routeY - 1);
        }
      }
//Vergleich der Listen um den kürzesten Weg zu finden
      if (left != null) {
        best = left;
      }
      if (up != null && (best.length == 0 || up.length < best.length)) {
        best = up;
      }
      if (right != null && (best.length == 0 || right.length < best.length)) {
        best = right;
      }
      if (down != null && (best.length == 0 || down.length < best.length)) {
        best = down;
      }
      return best;
    }

  // @override
  // bool getNextMove(currentX, currentY, targetX, targetY) {
// getRoute().first;


void move(){

  switch(nextMove)
  {
    case Directions.UP:

        if(!_level.checkCollision(_x, _y + 1, this)){
          _level.registerElement(_x, _y, _x, _y++, this);
        }
        break;

    case Directions.DOWN:

      if(!_level.checkCollision(_x, _y - 1, this)){
        _level.registerElement(_x, _y, _x, _y--, this);
      }
      break;

    case Directions.LEFT:

      if(!_level.checkCollision(_x + 1, _y, this)){
        _level.registerElement(_x, _y, _x++, _y, this);
      }
      break;

    case Directions.RIGHT:

      if(!_level.checkCollision(_x - 1, _y, this)){
        _level.registerElement(_x, _y, _x--, _y, this);
      }
      break;
  }
      }

  void eatableMode() {
          return;
      }

}
