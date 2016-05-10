part of pacmanLib;

class Shadow extends Ghost {

  int _getXPacMan;
  int _getYPacMan;

  int _start=0;

  int _x=4;
  int _y=4;
  // weiterer Test

  boolean scatter=false;
  super();
  this.speed=speed;

if(scatter==false)

/*solange ShadowXY != PacXY ist, sollen die for-Schleifen die Werte hochzählen
  Muss nach jedem Durchlauf aktuelle Pac Postion abfragen
  !!!Problem, man muss evlt. runterzählen, also variabel mal rauf mal runter, wie unterscheiden????
  bricht ab bei PowerPill, dann soll shadow langsamer werden
  wenn gefressen, dann ins Haus
*/
  {
  while(getXPacMan && getYPacMan != x && y){
    if(getXPacMan< x){
    for (int i = 0; i <getXPacMan; i++){
      i=x;
      if(getYPacMan <y){
      for (int j = 0; j <getYPacMan; j++){
        j=y;
       }}
       else{for (int k = 0; k <getYPacMan; k--){
        j=y;
      }
    if(getYPacman>x){

  if(getXPacMan< x){
  for (int i = 0; i <getXPacMan; i++){
  i=x;
  if(getYPacMan <y){
  for (int j = 0; j <getYPacMan; j++){
  j=y;
  }}
  else{for (int k = 0; k <getYPacMan; k--){
  j=y;
  }
      }

   }
  }}}}
 if(scatter==true) {
    void returnHome(){

  }
  }
}
