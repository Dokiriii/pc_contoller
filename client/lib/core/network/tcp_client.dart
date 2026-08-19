// core/network/tcp_client.dart
import 'dart:io';


// Класс отвечает исключительно за TCP-соединение с сервером.
// Здесь не будет UI и логики кнопок.
// Его задача — подключиться, отправлять и получать данные.
class TcpClient {
  Socket? _socket;


  // Подключение к TCP-серверу.
  //
  // host — IP-адрес компьютера.
  // port — порт, на котором работает сервер.
  Future<void> connect(String host, int port) async {
    try {
      // Пытаемся установить TCP-соединение.
      _socket = await Socket.connect(host, port);

      print('[TCP] Подключение установлено');
      print('[TCP] Сервер: $host:$port');

    } catch (error) {
      // Если подключение не удалось, выводим ошибку.
      print('[TCP] Ошибка подключения: $error');

      // Передаём ошибку дальше.
      // Благодаря этому интерфейс сможет понять,
      // что подключиться не получилось.
      rethrow;
    }
  }

  // Отправляет строку на TCP-сервер.
  //
  // Каждая команда должна заканчиваться символом "\n".
  // Он используется сервером как граница между командами.
  void send(String message) {
    if (_socket == null) {
      print('[TCP] Невозможно отправить данные: нет подключения');
      return;
    }

    // Добавляем разделитель команды.
    final data = '$message\n';

    // Превращаем строку в UTF-8 байты
    // и отправляем их через TCP-сокет.
    _socket!.write(data);

    print('[TCP] Отправлено: $message');
  }


  // Проверяем, существует ли активное TCP-соединение.
  bool get isConnected {
    return _socket != null;
  }


  // Закрываем TCP-соединение.
  void disconnect() {
    _socket?.close();
    _socket = null;

    print('[TCP] Соединение закрыто');
  }
}