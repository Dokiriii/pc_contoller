// features/control/control_screen.dart

import 'package:flutter/material.dart';

import '../../core/connection/connection_manager.dart';

import '../keyboard/keyboard_screen.dart';
import '../keyboard/typing_keyboard_screen.dart';
import '../keyboard/special_keyboard_screen.dart';

import '../mouse/mouse_screen.dart';

import '../connection/connection_screen.dart';


// ================================================================
// ГЛАВНОЕ ОКНО УПРАВЛЕНИЯ КОМПЬЮТЕРОМ
// ================================================================
//
// Здесь объединены:
//
// - мышь;
// - выдвижная мобильная клавиатура;
// - печатная мобильная клавиатура;
// - специальная мобильная клавиатура;
// - полноценный экран клавиатуры;
// - подключение;
// - отключение сервера.
//
// MouseScreen отвечает только за мышь.
//
// TypingKeyboardScreen отвечает за обычную
// мобильную печатную клавиатуру.
//
// SpecialKeyboardScreen отвечает за специальные
// символы и цифры.
//
// ControlScreen только объединяет эти элементы.
// ================================================================

class ControlScreen extends StatefulWidget {

  final ConnectionManager connectionManager;


  const ControlScreen({
    super.key,
    required this.connectionManager,
  });


  @override
  State<ControlScreen> createState() =>
      _ControlScreenState();
}


class _ControlScreenState
    extends State<ControlScreen> {


  // ==============================================================
  // СОСТОЯНИЕ ВЫДВИЖНОЙ КЛАВИАТУРЫ
  // ==============================================================
  //
  // false:
  //     клавиатура полностью скрыта.
  //
  // true:
  //     клавиатура открыта.
  //
  // ==============================================================

  bool _isKeyboardVisible = false;


  // ==============================================================
  // ТИП МОБИЛЬНОЙ КЛАВИАТУРЫ
  // ==============================================================
  //
  // false:
  //     печатная клавиатура.
  //
  // true:
  //     специальная клавиатура.
  //
  // ==============================================================

  bool _isSpecialKeyboard = false;


  // ==============================================================
  // ПОЛНОРАЗМЕРНАЯ КЛАВИАТУРА
  // ==============================================================

  void _openKeyboard() {

    Navigator.push(

      context,

      MaterialPageRoute(

        builder: (_) => KeyboardScreen(

          commandSender:
              widget.connectionManager
                  .commandSender,
        ),
      ),
    );
  }


  // ==============================================================
  // ОТКРЫТИЕ ЭКРАНА ПОДКЛЮЧЕНИЯ
  // ==============================================================

  void _openConnection() {

    widget.connectionManager.disconnect();


    Navigator.pushReplacement(

      context,

      MaterialPageRoute(

        builder: (_) =>
            ConnectionScreen(

          connectionManager:
              widget.connectionManager,
        ),
      ),
    );
  }


  // ==============================================================
  // ПОЛНОЕ ОТКЛЮЧЕНИЕ СЕРВЕРА
  // ==============================================================

  void _shutdownServer() {

    widget.connectionManager.shutdownServer();


    ScaffoldMessenger.of(context)

      ..hideCurrentSnackBar()

      ..showSnackBar(

        const SnackBar(

          content:
              Text(
            'Сервер отключён',
          ),

          behavior:
              SnackBarBehavior.floating,
        ),
      );


    Navigator.pushReplacement(

      context,

      MaterialPageRoute(

        builder: (_) =>
            ConnectionScreen(

          connectionManager:
              widget.connectionManager,
        ),
      ),
    );
  }


  // ==============================================================
  // ОТКРЫТИЕ / ЗАКРЫТИЕ МОБИЛЬНОЙ КЛАВИАТУРЫ
  // ==============================================================

  void _toggleTypingKeyboard() {

    setState(() {

      _isKeyboardVisible =
          !_isKeyboardVisible;
    });
  }


  // ==============================================================
  // ПЕРЕКЛЮЧЕНИЕ НА СПЕЦИАЛЬНУЮ КЛАВИАТУРУ
  // ==============================================================
  //
  // Вызывается кнопкой 123 на печатной клавиатуре.
  //
  // Важно:
  //
  // Клавиатура НЕ закрывается.
  //
  // Мы просто меняем содержимое выдвижной панели.
  //
  // ==============================================================

  void _openSpecialKeyboard() {

    setState(() {

      _isSpecialKeyboard = true;
    });
  }


  // ==============================================================
  // ПЕРЕКЛЮЧЕНИЕ НА ПЕЧАТНУЮ КЛАВИАТУРУ
  // ==============================================================
  //
  // Вызывается кнопкой 123 на специальной клавиатуре.
  //
  // ==============================================================

  void _openTypingKeyboard() {

    setState(() {

      _isSpecialKeyboard = false;
    });
  }


  // ==============================================================
  // UI
  // ==============================================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      // ==========================================================
      // APP BAR
      // ==========================================================

      appBar: AppBar(

        title:
            const Text(
          'Управление компьютером',
        ),


        actions: [

          // ------------------------------------------------------
          // ПОЛНАЯ КЛАВИАТУРА
          // ------------------------------------------------------

          IconButton(

            tooltip:
                'Клавиатура',

            onPressed:
                _openKeyboard,

            icon:
                const Icon(
              Icons.keyboard,
            ),
          ),


          // ------------------------------------------------------
          // ПОДКЛЮЧЕНИЕ
          // ------------------------------------------------------

          IconButton(

            tooltip:
                'Подключение',

            onPressed:
                _openConnection,

            icon:
                const Icon(
              Icons.link_off,
            ),
          ),


          // ------------------------------------------------------
          // ОСТАНОВКА СЕРВЕРА
          // ------------------------------------------------------

          IconButton(

            tooltip:
                'Остановить сервер',

            onPressed:
                _shutdownServer,

            icon:
                const Icon(
              Icons.power_settings_new,
            ),
          ),
        ],
      ),


      // ==========================================================
      // ОСНОВНОЕ ОКНО
      // ==========================================================

      body:
          Padding(

        padding:
            const EdgeInsets.all(12),


        child:
            ClipRRect(

          borderRadius:
              BorderRadius.circular(16),


          child:
              LayoutBuilder(

            builder:
                (
                  context,
                  constraints,
                ) {

              // --------------------------------------------------
              // Высота мобильной клавиатуры.
              //
              // Берём 48% реальной области управления.
              // --------------------------------------------------

              final keyboardHeight =
                  constraints.maxHeight * 0.48;


              return Stack(

                clipBehavior:
                    Clip.none,


                children: [

                  // ==================================================
                  // МЫШЬ
                  // ==================================================

                  Positioned.fill(

                    child:
                        MouseScreen(

                      commandSender:
                          widget.connectionManager
                              .commandSender,
                    ),
                  ),


                  // ==================================================
                  // ВЫДВИЖНАЯ КЛАВИАТУРА
                  // ==================================================
                  //
                  // Внутри этого места отображается либо:
                  //
                  // TypingKeyboardScreen
                  //
                  // либо:
                  //
                  // SpecialKeyboardScreen
                  //
                  // ==================================================

                  AnimatedPositioned(

                    duration:
                        const Duration(
                      milliseconds: 280,
                    ),


                    curve:
                        Curves.easeOutCubic,


                    left:
                        0,

                    right:
                        0,


                    bottom:
                        _isKeyboardVisible
                            ? 0
                            : -keyboardHeight,


                    height:
                        keyboardHeight,


                    child:
                        Material(

                      color:
                          Colors.transparent,


                      child:

                          // ------------------------------------------------
                          // СПЕЦИАЛЬНАЯ КЛАВИАТУРА
                          // ------------------------------------------------

                          _isSpecialKeyboard

                              ? SpecialKeyboardScreen(

                                  commandSender:
                                      widget.connectionManager
                                          .commandSender,


                                  // Кнопка 123 возвращает
                                  // обычную печатную клавиатуру.

                                  onTypingKeyboard:
                                      _openTypingKeyboard,
                                )


                              // ------------------------------------------------
                              // ОБЫЧНАЯ ПЕЧАТНАЯ КЛАВИАТУРА
                              // ------------------------------------------------

                              : TypingKeyboardScreen(

                                  commandSender:
                                      widget.connectionManager
                                          .commandSender,


                                  // Кнопка 123 открывает
                                  // специальную клавиатуру.

                                  onSpecialKeyboard:
                                      _openSpecialKeyboard,
                                ),
                    ),
                  ),


                  // ==================================================
                  // КНОПКА ОТКРЫТИЯ / ЗАКРЫТИЯ
                  // ==================================================
                  //
                  // Кнопка находится по центру правой стороны.
                  //
                  // Поднята на 10 пикселей относительно центра,
                  // чтобы не залезать на верхнюю границу клавиатуры.
                  //
                  // ==================================================

                  Positioned(

                    right:
                        0,


                    top:
                        ((constraints.maxHeight - 58) / 2) - 10,


                    child:
                        GestureDetector(

                      behavior:
                          HitTestBehavior.opaque,


                      onTap:
                          _toggleTypingKeyboard,


                      child:
                          AnimatedContainer(

                        duration:
                            const Duration(
                          milliseconds: 200,
                        ),


                        width:
                            42,

                        height:
                            58,


                        decoration:
                            BoxDecoration(

                          color:
                              Colors.black.withValues(
                            alpha: 0.78,
                          ),


                          borderRadius:
                              const BorderRadius.horizontal(

                            left:
                                Radius.circular(12),
                          ),


                          border:
                              Border.all(

                            color:
                                Colors.white.withValues(
                              alpha: 0.14,
                            ),

                            width:
                                1,
                          ),
                        ),


                        child:
                            Center(

                          child:
                              AnimatedSwitcher(

                            duration:
                                const Duration(
                              milliseconds: 180,
                            ),


                            transitionBuilder:
                                (
                                  child,
                                  animation,
                                ) {

                              return FadeTransition(

                                opacity:
                                    animation,

                                child:
                                    child,
                              );
                            },


                            child:
                                Icon(

                              _isKeyboardVisible

                                  ? Icons
                                      .keyboard_arrow_down

                                  : Icons
                                      .keyboard_arrow_up,


                              key:
                                  ValueKey(
                                _isKeyboardVisible,
                              ),


                              size:
                                  30,


                              color:
                                  Colors.white.withValues(
                                alpha: 0.75,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}