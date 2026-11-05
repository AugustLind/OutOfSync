part of '../main.dart';

class NetworkManager {
  static const int broadcastPort = 8888;
  static const int gamePort = 8889;
  UDP? _udp;
  Timer? _broadcastTimer;
  ServerSocket? _serverSocket;
  Socket? _clientSocket;
  final Function(Map<String, dynamic>) onMessageReceived;
  final Function(String) onPlayerJoined;
  final Function(String) onPlayerLeft;
  String? _localIP;

  NetworkManager({
    required this.onMessageReceived,
    required this.onPlayerJoined,
    required this.onPlayerLeft,
  });

  Future<void> initialize() async {
    _localIP = await NetworkInfo().getWifiIP();
  }

  Future<void> startHosting(String gameCode) async {
    await _startBroadcasting(gameCode);
    await _startGameServer();
  }

  Future<void> _startBroadcasting(String gameCode) async {
    _udp = await UDP.bind(Endpoint.broadcast(port: Port(broadcastPort)));
    _broadcastTimer?.cancel();
    _broadcastTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_udp != null) {
        final message = jsonEncode({
          'type': 'game_broadcast',
          'code': gameCode,
          'host_ip': _localIP,
        });
        _udp!.send(message.codeUnits, Endpoint.broadcast(port: Port(broadcastPort)));
      }
    });
  }

  Future<void> _startGameServer() async {
    _serverSocket = await ServerSocket.bind(_localIP!, gamePort);
    _serverSocket!.listen((socket) {
      socket.listen((data) {
        final message = String.fromCharCodes(data);
        try {
          final decoded = jsonDecode(message);
          onMessageReceived(decoded);
        } catch (e) {
          print('Error decoding message: $e');
        }
      });
    });
  }

  Future<List<GameInfo>> discoverGames() async {
    final games = <GameInfo>[];
    final udp = await UDP.bind(Endpoint.loopback(port: Port(broadcastPort)));
    
    final completer = Completer<List<GameInfo>>();
    Timer(const Duration(seconds: 3), () {
      udp.close();
      completer.complete(games);
    });

    udp.asStream().listen((datagram) {
      try {
        final message = String.fromCharCodes(datagram!.data);
        final decoded = jsonDecode(message);
        if (decoded['type'] == 'game_broadcast') {
          final gameInfo = GameInfo(
            code: decoded['code'],
            hostIP: decoded['host_ip'],
          );
          if (!games.any((g) => g.code == gameInfo.code)) {
            games.add(gameInfo);
          }
        }
      } catch (e) {
        print('Error parsing broadcast: $e');
      }
    });

    return completer.future;
  }

  Future<void> joinGame(String hostIP) async {
    try {
      _clientSocket = await Socket.connect(hostIP, gamePort);
      _clientSocket!.listen((data) {
        final message = String.fromCharCodes(data);
        try {
          final decoded = jsonDecode(message);
          onMessageReceived(decoded);
        } catch (e) {
          print('Error decoding message: $e');
        }
      });
    } catch (e) {
      print('Error joining game: $e');
    }
  }

  void sendMessage(Map<String, dynamic> message) {
    final encoded = jsonEncode(message);
    if (_clientSocket != null) {
      _clientSocket!.add(encoded.codeUnits);
    } else if (_serverSocket != null) {
      // Broadcast to all connected clients (simplified)
    }
  }

  void dispose() {
    _broadcastTimer?.cancel();
    _udp?.close();
    _serverSocket?.close();
    _clientSocket?.destroy();
  }
}
