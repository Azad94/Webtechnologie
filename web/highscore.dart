
import 'package:Webtechnologie/pacmanLib.dart';
import 'dart:html';
import 'dart:async';

final highscore = querySelector("#highscorehtml");
final loading = querySelector(".cssload-container");
String Gamekeyhost = "212.201.22.161";
int Gamekeyport = 50001;
String GamekeyID = "53a9c30c-8319-446a-bb1d-06af98442d05";
String GamekeySecret = "f2eb8b84b6c948d1";

void main() {
  GameKeyClient gamekey = new GameKeyClient(Gamekeyhost, Gamekeyport, GamekeyID, GamekeySecret);
  authenticateGamekey(gamekey);
}

Future authenticateGamekey(GameKeyClient gamekey) async{
  await gamekey.authenticate();
  gamekey.getTop10().then((scores) { showTop10(scores);});
}

void showTop10 (List<Map> scores) {
  loading.style.display = "none";
  highscore.style.display = "block";
  int i = 0;
  final list = scores.map((entry) => "<tr><td>" + (++i).toString() + "</td><td>${entry['name']}</td><td> ${entry['score']}</td></tr>").join("");
  highscore.innerHtml = "<table id='scoretable'><tr id=\"head\"><td>PLACE</td><td>NAME</td><td>SCORE</td></tr>${ list.isEmpty? "" : "$list"}</div>";;
}