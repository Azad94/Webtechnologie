part of pacmanLib;

class Pinky extends Ghost {

  Pinky(int x, int y, bool collPlayer, bool collGhost, Level l, num eatTime, num score) : super(x, y, collPlayer, collGhost, l, eatTime, score);

  int nextMove=1;
  int i=1;

//  int _targetX=7;
//  int _targetY=1;

//  int routeX=11;
//  int routeY=10;

/*  int _doorTargetX = 14;
  int _doorTargetY = 9;

  int _scatterTargetX = 2;
  int _scatterTargetY = 2;

  int _alternativeTargetX = 28;
  int _alternativeTargetY = 17;

  int _directionsChanged = 0;
*/

  //gibt die bisher beste Liste zurück
/*  List<Directions> getRoute() {
    List<Directions> route = new List();
    return getRouteRecursive(route, _x, _y);
  }


  List<Directions> getRouteRecursive(List<Directions> prev, int routeX,int routeY) {


    if (prev.length > 5) {
      return prev;
    }

    List<Directions> left;
    List<Directions> up;
    List<Directions> right;
    List<Directions> down;
    List<Directions> nothing;
    List<Directions> best = new List();


    // requires better interface to differentiate collisions from finding pacman
    //Abbruchbedingungen für Abfrage fehlt
    if (!_level.checkCollision(routeX++, routeY, this) && (routeX < 15) ) {
        print(routeX);
        prev.add(Directions.RIGHT);
        right = getRouteRecursive(prev, ++routeX , routeY);
    }
    if (!_level.checkCollision(routeX--, routeY, this) && (routeX > 1)) {
        prev.add(Directions.LEFT);
        left = getRouteRecursive(prev, --routeX, routeY);
    }
    if (!_level.checkCollision(routeX, routeY-1, this) && (routeY > 7)) {
      prev.add(Directions.UP);
      up = getRouteRecursive(prev, routeX, --routeY);
   //   print(routeY);
    }
    if (!_level.checkCollision(routeX, routeY+1, this) && (routeY < 1)) {
      prev.add(Directions.DOWN);
      down = getRouteRecursive(prev, routeX, ++routeY);
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
  } */




  // @override

//NextDirection should be the first element from best

  @override
  void move() {
    super.move();
    // nextDirection = getRoute().first;
    //  print(getRoute());
    // print(nextDirection);

    //   var route = ['apples', 'pears', 'oranges'];

    /*   var iterator = fruits.iterator;
    while (iterator.moveNext()) {
      var fruit = iterator.current;
      print(fruit);}*/

    /* var iterator = getRoute().iterator;
   while (iterator.moveNext()) {
     nextDirection = iterator.current;
      print(nextDirection);

*/
    //   if(_x == _targetX && _y == _targetY) _directionsChanged++;

    /*   switch(_directionsChanged)
    {
      case 0:
        _targetX = _doorTargetX;
        _targetY = _doorTargetY;
        break;

      case 1:
        _targetX = _scatterTargetX;
        _targetY = _scatterTargetY;
        break;

      case 2:
        _targetX = _alternativeTargetX;
        _targetY = _alternativeTargetY;
        break;

      case 3:
        _targetX = _doorTargetX;
        _targetY = _doorTargetY;
        _directionsChanged = 0;
        break;
    }*/
//getNextMove(_x, _y, _targetX, _targetY, this)

    if(i<=100){
      switch(nextMove) {
        case 1:
//          (!_level.checkCollision(_x, _y --, this))
          _level.registerElement(_x, _y, 13, 10, this);
          nextMove++;
          break;
        case 2:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(13, 10, 14, 10, this);
          nextMove++;
          break;
       case 3:
//          (!_level.checkCollision(_x, _y --, this))
          _level.registerElement(14, 10, 15, 10, this);
          nextMove++;
          break;
        case 4:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(15, 10, 15, 9, this);
          nextMove++;
          break;
        case 5:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(15, 9, 15, 8, this);
          nextMove++;
          break;
        case 6:
//          (!_level.checkCollision(_x, _y --, this))
          _level.registerElement(15, 8, 15, 7, this);
          nextMove++;
          break;
        case 7:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(15, 7, 15, 6, this);
          nextMove++;
          break;
        case 8:
//          (!_level.checkCollision(_x, _y --, this))
          _level.registerElement(15, 6, 16,6, this);
          nextMove++;
          break;
        case 9:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(16,6, 17, 6, this);
          nextMove++;
          break;
        case 10:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(17,6, 18, 6, this);
          nextMove++;
          break;
        case 11:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(18,6, 19, 6, this);
          nextMove++;
          break;
        case 12:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(19,6, 20, 6, this);
          nextMove++;
          break;
        case 13:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(20,6, 20, 5, this);
          nextMove++;
          break;
        case 14:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(20,5, 20, 4, this);
          nextMove++;
          break;
        case 15:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(20,4, 21, 4, this);
          nextMove++;
          break;
        case 16:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(21,4, 22, 4, this);
          nextMove++;
          break;
        case 17:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(22,4, 22, 5, this);
          nextMove++;
          break;
        case 18:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(22,5, 22, 6, this);
          nextMove++;
          break;
        case 19:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(22,6, 22, 7, this);
          nextMove++;
          break;
        case 20:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(22,7, 22, 8, this);
          nextMove++;
          break;
        case 21:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(22,8, 22, 9, this);
          nextMove++;
          break;
        case 22:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(22,9, 22, 10, this);
          nextMove++;
          break;
        case 23:
//          (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(22,10, 21, 10, this);
          nextMove++;
          break;
        case 24:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(21,10, 20, 10, this);
          nextMove++;
          break;
        case 25:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(20,10, 20, 9, this);
          nextMove++;
          break;
        case 26:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(20,9, 20, 8, this);
          nextMove++;
          break;
        case 27:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(20,8, 19, 8, this);
          nextMove++;
          break;
        case 28:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(19,8, 18, 8, this);
          nextMove++;
          break;
        case 29:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(18,8, 17, 8, this);
          nextMove++;
          break;
        case 30:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(17,8, 16, 8, this);
          nextMove++;
          break;
        case 31:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(16,8, 15, 8, this);
          nextMove=6;
          i++;
          break;
      /*  case 32:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(20,8, 19, 8, this);
          nextMove++;
          break;
        case 33:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(19,8, 18, 8, this);
          nextMove++;
          break;
        case 34:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(18,8, 17, 8, this);
          nextMove++;
          break;
        case 35:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(17,8, 16, 8, this);
          nextMove++;
          break;
        case 36:
//           (!_level.checkCollision(_x, _y ++, this))
          _level.registerElement(16,8, 15, 8, this);
          nextMove++;
          break;
        case 37:
//          (!_level.checkCollision(_x, _y --, this))
          _level.registerElement(15, 8, 14, 8, this);
          nextMove=6;
          i++;
          break;*/
        default:
          break;
      }
    }

  }
}