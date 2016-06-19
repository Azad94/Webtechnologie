part of pacmanControllerLib;

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

  final _userName = "pacman";
  final _userPassword = "geheimesPasswort";
  String _userID;

  /**
   * Autor: Nane Kratzke
   * Helper method to generate parameter body for REST requests.
   */
  static String _parameter(Map<String, String> p) =>
      (new Uri(queryParameters: p)).query;

  GameKeyClient(String host, int port, this._gid, this._secret) {
    if (host == null || port == null || _gid == null || _secret == null)
      print("GameKeyClient(): param null");
    else
    this._uri = new Uri.http("$host:$port", "/");
  }

  /**
   * Autor: primary Nane Kratzke, secondary Niklas Klatt
   * This method can be used to authenticate a game.
   * A game must know its [id] and its [secret].
   * This method is used to check periodically gamekey service availability
   * and sets _available flag accordingly. Furthermore the method checks if the user called "pacman" is available for saving
   * states, if not the user will be created
   */
  Future<bool> authenticate() async {
    try {
      final uri = this
          ._uri
          .resolve("/game/$_gid")
          .resolveUri(new Uri(queryParameters: {'secret': "$_secret"}));
      final answer = await HttpRequest.request("$uri", method: 'GET');
      if (answer.status == 200) {
        /*
         * added/modified by Niklas Klatt
         */
        this._available = true;
        _userID = await _getUserId(_userName);
        if (_userID == null) {
          final ret = await _registerUser(_userName, _userPassword);
          if (ret == null)
            return false;
          else
            _userID = await _getUserId(_userName);
        }
        /*
         * end of added/modified part
         */
      }
    } catch (error, stacktrace) {
      print("GameKey.getGame() caused following error: '$error'");
      print("$stacktrace");
      this._available = false;
      return false;
    }
    return true;
  }

  /**
   * Autor: Nane Kratzke
   * Registers a non existing user with the gamekey service.
   * - Returns user map with stored values on success
   * - Returns null if user could not be stored (due to several reasons, gamekey service not reachable, user already existing)
   */
  Future<Map> _registerUser(String name, String pwd) async {
    if (!_available) return new Future.value(null);
    try {
      final answer = await HttpRequest.request("${this._uri.resolve("/user")}",
          method: 'POST',
          sendData: _parameter({'name': "$name", 'pwd': "$pwd",}),
          requestHeaders: {
            'content-type': 'application/x-www-form-urlencoded',
            'charset': 'UTF-8'
          });
      return answer.status == 200
          ? JSON.decode(answer.responseText)
          : throw answer.responseText;
    } catch (error, stacktrace) {
      print("GameKey.registerUser() caused following error: '$error'");
      print("$stacktrace");
      return null;
    }
  }

  /**
   * Autor: Nane Kratzke
   * Returns the user id of a given name.
   * Returns null if name is not present or on error.
   */
  Future<String> _getUserId(String name) async {
    if (!_available) return new Future.value(null);
    try {
      final users = await _listUsers();
      if (users == null) return null;
      final user =
          users.firstWhere((user) => user['name'] == name, orElse: null);
      return user == null ? null : user['id'];
    } catch (error, stacktrace) {
      print("GameKey.getUserId() caused following error: '$error'");
      print("$stacktrace");
      return null;
    }
  }

  /**
   * Autor: Nane Kratzke
   * Lists all users registered with the gamekey service.
   */
  Future<List<Map>> _listUsers() async {
    if (!_available) return new Future.value([]);
    try {
      final answer = await HttpRequest.request("${this._uri.resolve("/users")}",
          method: 'GET');
      return JSON.decode(answer.responseText);
    } catch (error, stacktrace) {
      print("GameKey.listUsers() caused following error: '$error'");
      print("$stacktrace");
      return null;
    }
  }

  /**
   * Autor: Nane Kratzke
   * Stores an arbitrary state encoded as map for a user with identifier [uid]
   * for this game.
   */
  Future<bool> _storeState(String uid, Map state) async {
    if (!_available) return new Future.value(false);
    try {
      final answer = await HttpRequest.request(
          "${this._uri.resolve("/gamestate/$_gid/$uid")}",
          method: 'POST',
          sendData: _parameter(
              {'secret': "$_secret", 'state': "${JSON.encode(state)}",}),
          requestHeaders: {
            'content-type': 'application/x-www-form-urlencoded',
            'charset': 'UTF-8'
          });
      return answer.status == 200 ? true : throw answer.responseText;
    } catch (error, stacktrace) {
      print("GameKey.storeState() caused following error: '$error'");
      print("$stacktrace");
      return false;
    }
  }

  /**
   * Autor: Nane Kratzke
   * Retrieves all states stored for this game.
   */
  Future<List<Map>> _getStates() async {
    if (!_available) return new Future.value([]);
    try {
      final uri = this
          ._uri
          .resolve("/gamestate/$_gid/$_userID")
          .resolveUri(new Uri(queryParameters: {'secret': "$_secret"}));
      final answer = await HttpRequest.request("$uri", method: 'GET');
      return JSON.decode(answer.responseText);
    } catch (error, stacktrace) {
      print("GameKey.getStates() caused following error: '$error'");
      print("$stacktrace");
      return null;
    }
  }

  /**
   * adds a score to GamekeyServer
   */
  Future<bool> _addScore(String name, int score) async {
    return await _storeState(_userID, {'name': '$name', 'score': score});
  }

  /**
   * Autor: Nane Kratzke, modified by Niklas Klatt
   * return a sorted list of the top ten highscores.3
   */
  Future<List> getTop10() async {
    final states = await _getStates();
    var ret = [];
    ret = states
        .map((entry) => {
              'name': "${entry['state']['name']}",
              'score': entry['state']['score']
            })
        .toList();
    ret.sort((a, b) => b['score'] - a['score']);
    if (ret.length > 10) ret = ret.sublist(0, 10);
    return ret;
  }
}
