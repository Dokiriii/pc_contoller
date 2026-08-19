// features/connection/connection_screen.dart

import 'package:flutter/material.dart';

import '../../core/connection/connection_manager.dart';
import '../control/control_screen.dart';


// Экран подключения к компьютеру.
//
// Этот экран отвечает только за UI подключения.
// Вся сетевая логика находится в ConnectionManager.
class ConnectionScreen extends StatefulWidget {

  final ConnectionManager connectionManager;


  const ConnectionScreen({
    super.key,
    required this.connectionManager,
  });


  @override
  State<ConnectionScreen> createState() =>
      _ConnectionScreenState();
}


class _ConnectionScreenState extends State<ConnectionScreen> {

  // ============================================================
  // BACKEND
  // ============================================================

  // Управляет TCP, UDP и CommandSender.
  late final ConnectionManager _connectionManager;


  // ============================================================
  // ПОЛЯ ВВОДА
  // ============================================================

  // IP-адрес компьютера.
  final TextEditingController _ipController =
      TextEditingController();


  // TCP-порт.
  final TextEditingController _portController =
      TextEditingController(
        text: '8080',
      );


  // ============================================================
  // СОСТОЯНИЕ
  // ============================================================

  bool _isConnecting = false;


  // ============================================================
  // ПОДКЛЮЧЕНИЕ
  // ============================================================

  Future<void> _connect() async {

    final ip = _ipController.text.trim();

    final port =
        int.tryParse(
          _portController.text.trim(),
        );


    // Проверяем IP.
    if (ip.isEmpty) {

      _showMessage(
        'Введите IP-адрес компьютера',
      );

      return;
    }


    // Проверяем порт.
    if (port == null) {

      _showMessage(
        'Некорректный порт',
      );

      return;
    }


    setState(() {
      _isConnecting = true;
    });


    try {

      await _connectionManager.connect(
        ip,
        port,
      );


      if (!mounted) {
        return;
      }


      // После успешного подключения
      // переходим в главное окно управления.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => ControlScreen(
            connectionManager: _connectionManager,
          ),
        ),
      );

    } catch (error) {

      if (!mounted) {
        return;
      }


      _showMessage(
        'Не удалось подключиться к серверу',
      );

    } finally {

      if (mounted) {

        setState(() {
          _isConnecting = false;
        });
      }
    }
  }


  // ============================================================
  // УВЕДОМЛЕНИЕ
  // ============================================================

  void _showMessage(String message) {

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),

          behavior: SnackBarBehavior.floating,

          duration: const Duration(
            seconds: 3,
          ),
        ),
      );
  }


  // ============================================================
  // ИНИЦИАЛИЗАЦИЯ
  // ============================================================

  @override
  void initState() {
    super.initState();

    // Получаем ConnectionManager,
    // который был создан уровнем выше.
    _connectionManager = widget.connectionManager;
  }


  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {

    _ipController.dispose();

    _portController.dispose();

    super.dispose();
  }


  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          'PC Controller',
        ),
      ),


      body: Center(

        child: SingleChildScrollView(

          padding: const EdgeInsets.all(24),

          child: ConstrainedBox(

            constraints: const BoxConstraints(
              maxWidth: 450,
            ),

            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.stretch,

              children: [

                // ==================================================
                // ЗАГОЛОВОК
                // ==================================================

                const Icon(
                  Icons.computer,
                  size: 72,
                ),


                const SizedBox(
                  height: 20,
                ),


                const Text(
                  'Подключение к компьютеру',

                  textAlign: TextAlign.center,

                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),


                const SizedBox(
                  height: 8,
                ),


                Text(
                  'Введите данные сервера',

                  textAlign: TextAlign.center,

                  style: TextStyle(
                    color: Colors.grey.shade400,
                  ),
                ),


                const SizedBox(
                  height: 32,
                ),


                // ==================================================
                // IP
                // ==================================================

                TextField(

                  controller: _ipController,

                  keyboardType:
                      TextInputType.number,

                  decoration:
                      const InputDecoration(

                    labelText:
                        'IP-адрес',

                    hintText:
                        'Например: 192.168.0.100',

                    prefixIcon:
                        Icon(Icons.wifi),

                    border:
                        OutlineInputBorder(),
                  ),
                ),


                const SizedBox(
                  height: 16,
                ),


                // ==================================================
                // ПОРТ
                // ==================================================

                TextField(

                  controller: _portController,

                  keyboardType:
                      TextInputType.number,

                  decoration:
                      const InputDecoration(

                    labelText:
                        'TCP-порт',

                    hintText:
                        '8080',

                    prefixIcon:
                        Icon(Icons.settings_ethernet),

                    border:
                        OutlineInputBorder(),
                  ),
                ),


                const SizedBox(
                  height: 24,
                ),


                // ==================================================
                // КНОПКА
                // ==================================================

                SizedBox(

                  height: 52,

                  child: FilledButton(

                    onPressed:
                        _isConnecting
                            ? null
                            : _connect,

                    child:
                        _isConnecting

                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child:
                                    CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )

                            : const Text(
                                'Подключиться',
                              ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}