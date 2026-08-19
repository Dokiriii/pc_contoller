// core/network/udp_client.dart
import 'dart:convert';
import 'dart:io';


// Класс отвечает за отправку UDP-пакетов.
//
// В отличие от TcpClient здесь нет постоянного соединения.
// UDP позволяет отправлять отдельные пакеты непосредственно
// на IP-адрес и порт сервера.
class UdpClient {
  RawDatagramSocket? _socket;

  InternetAddress? _serverAddress;
  int? _serverPort;


  // Создаёт UDP-сокет и запоминает адрес сервера.
  Future<void> connect(String host, int port) async {
    try {
      _serverAddress = InternetAddress(host);
      _serverPort = port;

      // Создаём UDP-сокет.
      _socket = await RawDatagramSocket.bind(
        InternetAddress.anyIPv4,
        0,
      );

      print('[UDP] Сокет создан');
      print('[UDP] Сервер: $host:$port');

    } catch (error) {
      print('[UDP] Ошибка создания сокета: $error');

      rethrow;
    }
  }


  // Отправляет строку через UDP.
  void send(String message) {
    if (_socket == null ||
        _serverAddress == null ||
        _serverPort == null) {

      print('[UDP] Невозможно отправить данные: нет подключения');

      return;
    }

    final data = utf8.encode(message);

    _socket!.send(
      data,
      _serverAddress!,
      _serverPort!,
    );
  }


  // Проверяем, создан ли UDP-сокет.
  bool get isConnected {
    return _socket != null;
  }


  // Закрываем UDP-сокет.
  void disconnect() {
    _socket?.close();

    _socket = null;
    _serverAddress = null;
    _serverPort = null;

    print('[UDP] Сокет закрыт');
  }
}