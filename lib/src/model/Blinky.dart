part of pacmanLib;

//shadow
class Blinky extends Ghost {
  Level _level;
  bool eatable = false;

  int x1 = 5;
  int y1 = 5;
  int x2 = 1;
  int y2 = 4;

  Blinky(int x, int y, bool collPlayer, bool collGhost, Level l)
      : super(x, y, collPlayer, collGhost, l);

//gibt die bisher beste Liste zurück
  List<Direction> getRoute() {
    List<Direction> route = new List();
    return getRouteRecursive(route, _x, _y);
  }

  List<Direction> getRouteRecursive(
      List<Direction> prev, int routeX, int routeY) {
    if (prev.length > 10) {
      return prev;
    }

    List<Direction> left;
    List<Direction> up;
    List<Direction> right;
    List<Direction> down;
    List<Direction> best = new List();

    // requires better interface to differentiate collisions from finding pacman
    if ((prev.length == 0 || prev.last != Direction.RIGHT) &&
        !_level.checkCollision(routeX + 1, routeY, this)) {
      if (routeX + 1 == x1 && routeY == y1) {
        prev.add(Direction.RIGHT);
        right = prev;
      } else {
        prev.add(Direction.RIGHT);
        right = getRouteRecursive(prev, routeX + 1, routeY);
      }
    }
    if ((prev.length == 0 || prev.last != Direction.UP) &&
        !_level.checkCollision(routeX, routeY + 1, this)) {
      if (routeX == x1 && routeY + 1 == y1) {
        prev.add(Direction.UP);
        up = prev;
      } else {
        prev.add(Direction.UP);
        up = getRouteRecursive(prev, routeX, routeY + 1);
      }
    }
    if ((prev.length == 0 || prev.last != Direction.LEFT) &&
        !_level.checkCollision(routeX - 1, routeY, this)) {
      if (routeX - 1 == x1 && routeY == y1) {
        prev.add(Direction.LEFT);
        left = prev;
      } else {
        prev.add(Direction.LEFT);
        left = getRouteRecursive(prev, routeX - 1, routeY);
      }
    }
    if ((prev.length == 0 || prev.last != Direction.DOWN) &&
        !_level.checkCollision(routeX, routeY - 1, this)) {
      if (routeX + 1 == x1 && routeY == y1) {
        prev.add(Direction.DOWN);
        down = prev;
      } else {
        prev.add(Direction.DOWN);
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
      best = rigth;
    }
    if (down != null && (best.length == 0 || down.length() < best.length)) {
      best = down;
    }
    return best;
  }

  // @override
  // bool getNextMove(currentX, currentY, targetX, targetY) {
// getRoute().first;
}

void eatableMode() {}

void calcRoute() {}

void move() {
  dir = getRoute().first;
  if (dir == Directions.UP) {
    if (!_level.checkCollision(_x, _y - 1, this))
      _level.registerElement(_x, _y, _x, --_y, this);
  }
  if (dir == Directions.DOWN) {
    if (!_level.checkCollision(_x, _y + 1, this))
      _level.registerElement(_x, _y, _x, ++_y, this);
  }
  if (dir == Directions.LEFT) {
    if (!_level.checkCollision(_x - 1, _y, this))
      _level.registerElement(_x, _y, --_x, _y, this);
  }
  if (dir == Directions.RIGHT) {
    if (!_level.checkCollision(_x + 1, _y, this))
      _level.registerElement(_x, _y, ++_x, _y, this);
  }

  /*switch(d)
  {
    case Direction.UP:

        if((checkCollision(bx,by+1))==false){
        by++;
        }
        break;

    case Direction.DOWN:

      if((checkCollision(bx,by-1))==false){
        by--;
        }
         break;

    case Direction.LEFT:r

         if((checkCollision(bx-1,by))==false){
          bx--;
         }
        break;

    case Direction.RIGHT:

      if((checkCollision(bx+1,by))==false){
          bx++;
         }
         break;
  }*/
}
