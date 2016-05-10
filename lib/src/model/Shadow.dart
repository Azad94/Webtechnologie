part of pacmanLib;

class Shadow extends Ghost {
  int getXPacMan = 3;
  int getYPacMan = 3;

  int start = 0;

  int x = 4;
  int y = 4;

  // weiterer Test

/*solange ShadowXY != PacXY ist, sollen die for-Schleifen die Werte hochzählen
  Muss nach jedem Durchlauf aktuelle Pac Postion abfragen
  !!!Problem, man muss evlt. runterzählen, also variabel mal rauf mal runter, wie unterscheiden????
  bricht ab bei PowerPill, dann soll shadow langsamer werden
  wenn gefressen, dann ins Haus
  ScatterMode und InvsibleMode verschiedene Strategien unterscheiden

*/
  void PacManRun(int getXPacMan, int getYPacMan) {
    for (int x = 0; x < 100; x++) {
      getXPacMan = x;
      for (int y = 0; y < 100; y++) {
        getYPacMan = y;
      }
    }

    while (getYPacMan != x) {
      if (getXPacMan < x) {
        for (int i = 0; i < getXPacMan; i++) {
          i = x;
          if (getYPacMan < y) {
            for (int j = 0; j < getYPacMan; j++) {
              j = y;
            }
          } else {
            for (int k = 0; k < getYPacMan; k--) {
              k = y;
            }
            if (getXPacMan < x) {
              for (int l = 0; l < getXPacMan; l++) {
                l = x;
                if (getYPacMan < y) {
                  for (int m = 0; m < getYPacMan; m++) {
                    m = y;
                  }
                } else {
                  for (int n = 0; n < getYPacMan; n--) {
                    n = y;
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}
