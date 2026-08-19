// core/commands/command_sender.dart
import 'dart:convert';

import '../network/tcp_client.dart';
import '../network/udp_client.dart';


// Класс отвечает за формирование и отправку команд.
//
// UI не должен самостоятельно создавать JSON.
// Он обращается к методам этого класса,
// а CommandSender уже превращает команду в JSON
// и передает её в TcpClient.
class CommandSender {
  final TcpClient _tcpClient;
  final UdpClient _udpClient;


  CommandSender(
    this._tcpClient,
    this._udpClient,
  );


  // Отправляет команду нажатия клавиши.
  void pressKey(String key) {
    final command = {
      'type': 'KEY',
      'action': 'press',
      'data': key,
    };

    _send(command);
  }


  // Отправляет комбинацию клавиш.
  //
  // Например:
  // ['alt', 'tab']
  void hotkey(List<String> keys) {
    final command = {
      'type': 'KEY',
      'action': 'hotkey',
      'data': keys,
    };

    _send(command);
  }


  // ============================================================
  // ВВОД ГОТОВОГО ТЕКСТА
  // ============================================================
  //
  // Используется для символов, которые зависят от раскладки.
  //
  // Например:
  // ','
  // '.'
  // '{'
  // '}'
  //
  // В отличие от KEY, здесь отправляется
  // непосредственно нужный символ.
  //
  void text(String text) {
    final command = {
      'type': 'TEXT',
      'action': 'write',
      'data': text,
    };

    _send(command);
  }


  // Отправляет команду зажатия клавиши.
  void keyDown(String key) {
    final command = {
      'type': 'KEY',
      'action': 'key_down',
      'data': key,
    };

    _send(command);
  }


  // Отправляет команду отпускания клавиши.
  void keyUp(String key) {
    final command = {
      'type': 'KEY',
      'action': 'key_up',
      'data': key,
    };

    _send(command);
  }


  // Превращает Python-подобный Map в JSON
  // и передает его TCP-клиенту.
  void _send(Map<String, dynamic> command) {
    final jsonCommand = jsonEncode(command);

    _tcpClient.send(jsonCommand);
  }


  // Отправляет относительное перемещение мыши.
  //
  // Движение мыши отправляется через UDP,
  // потому что для него важнее актуальность данных,
  // чем гарантированная доставка каждого пакета.
  void moveMouse(double dx, double dy) {
    final command = {
      'type': 'MOUSE',
      'action': 'move',
      'data': {
        'dx': dx,
        'dy': dy,
      },
    };

    final jsonCommand = jsonEncode(command);

    _udpClient.send(jsonCommand);
  }


  // Отправляет команду нажатия кнопки мыши.
  void mouseClick(String button) {
    final command = {
      'type': 'MOUSE',
      'action': 'click',
      'data': {
        'button': button,
      },
    };

    _send(command);
  }


   // Отправляет команду зажатия кнопки мыши.
   //
   // Например:
   // 'left'
   // 'right'
   // 'middle'
   void mouseDown(String button) {
     final command = {
       'type': 'MOUSE',
       'action': 'mouse_down',
       'data': {
         'button': button,
       },
     };

     _send(command);
   }


   // Отправляет команду отпускания кнопки мыши.
   //
   // Например:
   // 'left'
   // 'right'
   // 'middle'
   void mouseUp(String button) {
     final command = {
       'type': 'MOUSE',
       'action': 'mouse_up',
       'data': {
         'button': button,
       },
     };

     _send(command);
   }


  void scrollMouse(double amount) {
    final command = {
      'type': 'MOUSE',
      'action': 'scroll',
      'data': {
        'amount': amount,
      },
    };

    final jsonCommand = jsonEncode(command);

    _udpClient.send(jsonCommand);
  }


  // Отправляет команду полного завершения работы сервера.
  //
  // После получения этой команды сервер закрывает
  // TCP и UDP-соединения и завершает работу.
  void shutdownServer() {
    final command = {
      'type': 'SYSTEM_COMMAND',
      'action': 'shutdown',
    };

    _send(command);
  }


  // ============================================================
  // СМЕНА ЯЗЫКА
  // ============================================================
  //
  // Пока используем комбинацию Windows:
  //
  // Shift + Alt
  //
  // Linux пока специально не рассматриваем.

  void changeLanguage() {

    hotkey([
      'shift',
      'alt',
    ]);
  }
}