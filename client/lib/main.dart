// main.dart

// main.dart

import 'package:flutter/material.dart';

import 'core/connection/connection_manager.dart';
import 'features/connection/connection_screen.dart';


void main() {
  // Точка входа в приложение.
  runApp(const PCControllerApp());
}


// Основной класс приложения.
//
// Здесь находятся только глобальные настройки приложения.
// Логики подключения или управления здесь нет.
class PCControllerApp extends StatefulWidget {

  const PCControllerApp({
    super.key,
  });


  @override
  State<PCControllerApp> createState() =>
      _PCControllerAppState();
}


class _PCControllerAppState extends State<PCControllerApp> {

  // ============================================================
  // BACKEND
  // ============================================================

  // ConnectionManager существует всё время,
  // пока работает приложение.
  //
  // Поэтому переход между экранами
  // не уничтожает TCP и UDP соединения.
  late final ConnectionManager _connectionManager;


  @override
  void initState() {
    super.initState();

    _connectionManager = ConnectionManager();
  }


  @override
  void dispose() {

    // Когда полностью закрывается приложение,
    // закрываем соединения.
    _connectionManager.disconnect();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      // Убираем стандартную надпись Debug.
      debugShowCheckedModeBanner: false,

      // Название приложения.
      title: 'PC Controller',

      // ========================================================
      // ТЕМА
      // ========================================================

      theme: ThemeData(

        // Используем тёмную тему.
        brightness: Brightness.dark,

        // Основной цвет интерфейса.
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),

        // Используем Material 3.
        useMaterial3: true,
      ),

      // Первым открывается экран подключения.
      home: ConnectionScreen(
        connectionManager: _connectionManager,
      ),
    );
  }
}