part of pacmanLib;

class GameKeyClient {

  /**
   * URI of GameKey Service
   */
  Uri _uri;

  /**
   * Game ID
   */
  String _gid;

  /**
   * Game secret
   */
  String _secret;

  /**
   * Status of GameKeyServer
   */
  bool _available = false;

  const _userName = "pacman";
  const _userPassword = "geheimesPasswort";

  static String _parameter(Map<String, String> p) => (new Uri(queryParameters: p)).query;


  GameKeyClient(String host, int port, this._gid, this._secret) {
    this._uri = new Uri.http("$host:$port", "/");
  }

  Future<bool> authenticate() async {
    try {
      final uri = this._uri.resolve("/game/$_gid").resolveUri(new Uri(queryParameters: { 'secret' : "$_secret" }));
      final answer = await HttpRequest.request("$uri", method: 'GET');
      if (answer.status == 200) { this._available = true;
        final userID = await _getUserId(_userName);
        if(userID == null) {
          final ret = await _registerUser(_userName, _userPassword);
          if(ret == null)
            return false;
        }
        return true;
      }

    } catch (error, stacktrace) {
      print ("GameKey.getGame() caused following error: '$error'");
      print ("$stacktrace");
      this._available = false;
      return false;
    }
  }


  Future<Map> _registerUser(String name, String pwd) async {
    if (!_available) return new Future.value(null);
    try {
      final answer = await HttpRequest.request(
          "${this._uri.resolve("/user")}",
          method: 'POST',
          sendData: parameter({
            'name'   : "$name",
            'pwd' : "$pwd",
          }),
          requestHeaders: {
            'content-type': 'application/x-www-form-urlencoded',
            'charset': 'UTF-8'
          }
      );
      return answer.status == 200 ? JSON.decode(answer.responseText) : throw answer.responseText;
    } catch (error, stacktrace) {
      print ("GameKey.registerUser() caused following error: '$error'");
      print ("$stacktrace");
      return null;
    }
  }

  Future<String> _getUserId(String name) async {
    if (!_available) return new Future.value(null);
    try {
      final users = await listUsers();
      if (users == null) return null;
      final user = users.firstWhere((user) => user['name'] == name, orElse: null);
      return user == null ? null : user['id'];
    } catch (error, stacktrace) {
      print ("GameKey.getUserId() caused following error: '$error'");
      print ("$stacktrace");
      return null;
    }
  }

  Future<bool> _storeState(String uid, Map state) async {
    if (!_available) return new Future.value(false);
    try {
      final answer = await HttpRequest.request(
          "${this._uri.resolve("/gamestate/$_gid/$uid")}",
          method: 'POST',
          sendData: parameter({
            'secret' : "$_secret",
            'state' : "${JSON.encode(state)}",
          }),
          requestHeaders: {
            'content-type': 'application/x-www-form-urlencoded',
            'charset': 'UTF-8'
          }
      );
      return answer.status == 200 ? true : throw answer.responseText;
    } catch (error, stacktrace) {
      print ("GameKey.storeState() caused following error: '$error'");
      print ("$stacktrace");
      return false;
    }
  }

  Future<bool> addScore(String name, int score) async {
      // TODO
  }

  Future<Map> getTop10() {
    // TODO
  }


}