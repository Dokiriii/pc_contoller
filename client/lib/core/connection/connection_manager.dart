// core/connection/connection_manager.dart

import '../commands/command_sender.dart';
import '../network/tcp_client.dart';
import '../network/udp_client.dart';


// Класс отвечает за управление подключением к серверу.
//
// Здесь находится логика подключения и отключения TCP и UDP.
// UI не должен самостоятельно управлять TcpClient и UdpClient.
//
// ConnectionManager связывает:
// TCP-клиент
// UDP-клиент
// CommandSender
class ConnectionManager {

  // Объект, который отвечает за TCP-соединение.
  final TcpClient tcpClient = TcpClient();

  // Объект, который отвечает за UDP-соединение.
  final UdpClient udpClient = UdpClient();

  // Объект отвечает за создание и отправку команд.
  late final CommandSender commandSender;


  // Создаём ConnectionManager.
  ConnectionManager() {

    commandSender = CommandSender(
      tcpClient,
      udpClient,
    );
  }


  // ============================================================
  // ПОДКЛЮЧЕНИЕ
  // ============================================================

  // Подключается к серверу по TCP и UDP.
  //
  // host — IP-адрес компьютера.
  // port — TCP-порт сервера.
  //
  // UDP использует отдельный порт 8081.
  Future<void> connect(
    String host,
    int port,
  ) async {

    try {

      // Сначала устанавливаем TCP-соединение.
      await tcpClient.connect(
        host,
        port,
      );


      // После успешного TCP-соединения
      // создаём UDP-сокет.
      await udpClient.connect(
        host,
        8081,
      );


      print('[Connection] TCP и UDP подключены');

    } catch (error) {

      // Если UDP или TCP подключение завершилось ошибкой,
      // закрываем всё, что успело подключиться.
      disconnect();

      print(
        '[Connection] Ошибка подключения: $error',
      );

      // Передаём ошибку обратно экрану.
      rethrow;
    }
  }


  // ============================================================
  // ОТКЛЮЧЕНИЕ
  // ============================================================

  // Закрывает TCP и UDP соединения.
  void disconnect() {

    // Закрываем TCP-соединение.
    tcpClient.disconnect();

    // Закрываем UDP-сокет.
    udpClient.disconnect();

    print('[Connection] Соединение отключено');
  }

  // ============================================================
  // ПОЛНОЕ ОТКЛЮЧЕНИЕ СЕРВЕРА
  // ============================================================

  // Отправляет серверу команду полного завершения работы.
  //
  // Это отличается от обычного disconnect().
  //
  // disconnect() просто разрывает соединение с сервером.
  //
  // shutdownServer() просит сам Python-сервер
  // завершить свою работу.
  void shutdownServer() {

    if (!isConnected) {
      return;
    }

    commandSender.shutdownServer();

    // После отправки команды закрываем соединения клиента.
    disconnect();
  }


  // ============================================================
  // СОСТОЯНИЕ
  // ============================================================

  // Проверяем, установлены ли оба соединения.
  bool get isConnected {

    return tcpClient.isConnected &&
        udpClient.isConnected;
  }
}

