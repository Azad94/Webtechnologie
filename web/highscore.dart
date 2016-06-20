import 'package:Webtechnologie/pacmanControllerLib.dart';
import 'dart:html';
import 'dart:async';
import 'dart:convert';

final highscore = querySelector("#highscorehtml");
final loading = querySelector(".cssload-container");

const _CONFIG_JSON = "GameConfig.json";
String gamekeyHost;
num gamekeyPort;
String gamekeyID;
String gamekeySecret;

/**
 * highscore.dart is used to be able to load the top 10 players from the gamekeyserver
 * when the button Highscore is clicked in the Main Menu
 */
void main() {
  loadConfig().then((b) {GameKeyClient gamekey =
  new GameKeyClient(gamekeyHost, gamekeyPort, gamekeyID, gamekeySecret);
  authenticateGamekey(gamekey);});
}

Future authenticateGamekey(GameKeyClient gamekey) async {
  await gamekey.authenticate();
  gamekey.getTop10().then((scores) {
    showTop10(scores);
  });
}

void showTop10(List<Map> scores) {
  loading.style.display = "none";
  highscore.style.display = "block";
  int i = 0;
  final list = scores
      .map((entry) =>
          "<tr><td>" +
          (++i).toString() +
          "</td><td>${entry['name']}</td><td> ${entry['score']}</td></tr>")
      .join("");
  highscore.innerHtml =
      "<table id='scoretable'><tr id=\"head\"><td>PLACE</td><td>NAME</td><td>SCORE</td></tr>${ list.isEmpty? "" : "$list"}</div>";
  ;
}

Future<bool> loadConfig() async {
  try {
    String json = await HttpRequest.getString(_CONFIG_JSON);
    if (json == null) throw new Exception("Can not read $_CONFIG_JSON");
    final data = await JSON.decode(json);
    gamekeyHost = data["GamekeyHost"];
    gamekeyPort = data["GamekeyPort"];
    gamekeyID = data["GamekeyID"];
    gamekeySecret = data["GamekeySecret"];
    if (gamekeyHost == null ||
        gamekeyPort == null ||
        gamekeyID == null ||
        gamekeySecret == null)
      throw new Exception("Can not read $_CONFIG_JSON");
  } catch (error, stackTrace) {
    print("loadConfig() caused following error: $error");
    print(stackTrace);
    return false;
  }
  return true;
}
