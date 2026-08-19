// features/keyboard/typing_keyboard_screen.dart

import 'package:flutter/material.dart';

import '../../core/commands/command_sender.dart';
import 'keyboard_key.dart';
import 'keyboard_layout.dart';


// ================================================================
// ПЕЧАТНАЯ КЛАВИАТУРА
// ================================================================
//
// SHIFT работает следующим образом:
//
// 1. Один тап по SHIFT:
//
//    SHIFT включается.
//    Следующая физическая клавиша будет с Shift.
//    После буквы/символа SHIFT автоматически отпускается.
//
//
// 2. Два тапа по SHIFT:
//
//    SHIFT фиксируется.
//
//    Можно вводить:
//
//    HELLO WORLD
//
//    сколько угодно.
//
//
// 3. Повторный тап по зафиксированному SHIFT:
//
//    SHIFT выключается.
//
//
// ЦИФРЫ:
//
//    1 2 3 4 5 6 7 8 9 0
//
// отправляются через TEXT.
//
// Поэтому цифры:
//
// - не зажимают Shift;
// - не используют физическую клавишу;
// - не зависят от раскладки компьютера.
// ================================================================


class TypingKeyboardScreen extends StatefulWidget {

  final CommandSender commandSender;

  final VoidCallback onSpecialKeyboard;


  const TypingKeyboardScreen({
    super.key,
    required this.commandSender,
    required this.onSpecialKeyboard,
  });


  @override
  State<TypingKeyboardScreen> createState() =>
      _TypingKeyboardScreenState();
}


class _TypingKeyboardScreenState
    extends State<TypingKeyboardScreen> {


  // ==============================================================
  // СОСТОЯНИЕ SHIFT
  // ==============================================================

  // SHIFT сейчас зажат на компьютере.

  bool _isShiftActive = false;


  // SHIFT зафиксирован двойным нажатием.

  bool _isShiftLocked = false;


  // ==============================================================
  // ПЕРЕКЛЮЧЕНИЕ SHIFT
  // ==============================================================

  void _toggleShift() {

    // ------------------------------------------------------------
    // SHIFT выключен.
    //
    // Включаем его для следующей физической клавиши.
    // ------------------------------------------------------------

    if (!_isShiftActive) {

      setState(() {

        _isShiftActive = true;

        _isShiftLocked = false;
      });


      widget.commandSender.keyDown(
        'shift',
      );

      return;
    }


    // ------------------------------------------------------------
    // SHIFT уже активен.
    //
    // Второе нажатие фиксирует его.
    // ------------------------------------------------------------

    if (!_isShiftLocked) {

      setState(() {

        _isShiftLocked = true;
      });

      return;
    }


    // ------------------------------------------------------------
    // SHIFT уже зафиксирован.
    //
    // Следующее нажатие выключает его.
    // ------------------------------------------------------------

    setState(() {

      _isShiftActive = false;

      _isShiftLocked = false;
    });


    widget.commandSender.keyUp(
      'shift',
    );
  }


  // ==============================================================
  // АВТОМАТИЧЕСКОЕ ОТПУСКАНИЕ SHIFT
  // ==============================================================

  void _releaseShiftAfterLetter() {

    // SHIFT выключен.

    if (!_isShiftActive) {
      return;
    }


    // SHIFT зафиксирован.
    //
    // В этом режиме отпускать его нельзя.

    if (_isShiftLocked) {
      return;
    }


    setState(() {

      _isShiftActive = false;
    });


    widget.commandSender.keyUp(
      'shift',
    );
  }


  // ==============================================================
  // НАЖАТИЕ ФИЗИЧЕСКОЙ КЛАВИШИ
  // ==============================================================

  void _handleKeyDown(
    KeyboardKey keyboardKey,
  ) {

    widget.commandSender.keyDown(
      keyboardKey.key,
    );
  }


  // ==============================================================
  // ОТПУСКАНИЕ ФИЗИЧЕСКОЙ КЛАВИШИ
  // ==============================================================

  void _handleKeyUp(
    KeyboardKey keyboardKey,
  ) {

    widget.commandSender.keyUp(
      keyboardKey.key,
    );


    // ------------------------------------------------------------
    // Только после буквенной/символьной физической клавиши
    // проверяем автоматическое отпускание SHIFT.
    //
    // ЦИФРЫ сюда вообще не попадают.
    // ------------------------------------------------------------

    if (_isLetterKey(keyboardKey)) {

      _releaseShiftAfterLetter();
    }
  }


  // ==============================================================
  // ПРОВЕРКА БУКВЫ
  // ==============================================================

  bool _isLetterKey(
    KeyboardKey keyboardKey,
  ) {

    return keyboardKey.secondaryLabel != null;
  }


  // ==============================================================
  // BUILD
  // ==============================================================

  @override
  Widget build(BuildContext context) {

    return SafeArea(

      child: OrientationBuilder(

        builder: (
          context,
          orientation,
        ) {

          final isPortrait =
              orientation == Orientation.portrait;


          return LayoutBuilder(

            builder: (
              context,
              constraints,
            ) {

              final keyboardHeight =
                  isPortrait
                      ? constraints.maxHeight * 0.48
                      : constraints.maxHeight;


              return Align(

                alignment:
                    isPortrait
                        ? Alignment.bottomCenter
                        : Alignment.center,


                child: SizedBox(

                  width:
                      double.infinity,

                  height:
                      keyboardHeight,


                  child: Padding(

                    padding:
                        EdgeInsets.symmetric(

                      horizontal:
                          isPortrait
                              ? 4
                              : 8,

                      vertical: 6,
                    ),


                    child: Column(

                      children: [

                        // ========================================
                        // ЦИФРЫ
                        // ========================================
                        //
                        // ВАЖНО:
                        //
                        // sendAsText = true
                        //
                        // Поэтому цифры отправляются
                        // через commandSender.text().
                        //

                        Expanded(

                          child:
                              _buildKeyRow(

                            typingNumberRow,

                            sendAsText:
                                true,
                          ),
                        ),


                        // ========================================
                        // ЙЦУКЕН
                        // ========================================

                        Expanded(

                          child:
                              _buildKeyRow(

                            typingTopRow,

                            sendAsText:
                                false,
                          ),
                        ),


                        // ========================================
                        // ФЫВАПРО
                        // ========================================

                        Expanded(

                          child:
                              _buildKeyRow(

                            typingMiddleRow,

                            sendAsText:
                                false,
                          ),
                        ),


                        // ========================================
                        // SHIFT + ЯЧСМИТЬБЮ + BACKSPACE
                        // ========================================

                        Expanded(

                          child:
                              _buildBottomLetterRow(),
                        ),


                        // ========================================
                        // 123 + 🌐 + , + SPACE + . + ENTER
                        // ========================================

                        Expanded(

                          child:
                              _buildBottomSystemRow(),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }


  // ==============================================================
  // ОБЫЧНЫЙ РЯД
  // ==============================================================
  //
  // sendAsText:
  //
  // true
  //     клавиши отправляются через TEXT
  //
  // false
  //     клавиши отправляются как физические клавиши
  //
  // ==============================================================

  Widget _buildKeyRow(
    List<KeyboardKey> keys, {

    bool sendAsText = false,
  }) {

    return Padding(

      padding:
          const EdgeInsets.symmetric(
        vertical: 2,
      ),


      child: Row(

        children:
            keys.map((keyboardKey) {

          return Expanded(

            child: Padding(

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 2,
              ),


              child:
                  _buildKey(

                keyboardKey,

                sendAsText:
                    sendAsText,
              ),
            ),
          );

        }).toList(),
      ),
    );
  }


  // ==============================================================
  // НИЖНИЙ БУКВЕННЫЙ РЯД
  // ==============================================================
  //
  // SHIFT | Я | Ч | С | М | И | Т | Ь | Б | Ю | BACKSPACE
  //
  // ==============================================================

  Widget _buildBottomLetterRow() {

    return Padding(

      padding:
          const EdgeInsets.symmetric(
        vertical: 2,
      ),


      child: Row(

        children: [

          // ------------------------------------------------------
          // SHIFT
          // ------------------------------------------------------

          Expanded(

            flex: 1,

            child: Padding(

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 2,
              ),


              child:
                  _buildShiftKey(),
            ),
          ),


          // ------------------------------------------------------
          // БУКВЫ
          // ------------------------------------------------------

          ...typingBottomLetterRow.map(
            (keyboardKey) {

              return Expanded(

                flex: 1,

                child: Padding(

                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 2,
                  ),


                  child:
                      _buildKey(
                    keyboardKey,
                  ),
                ),
              );
            },
          ),


          // ------------------------------------------------------
          // BACKSPACE
          // ------------------------------------------------------

          Expanded(

            flex: 13 ~/ 10,

            child: Padding(

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 2,
              ),


              child:
                  _buildKey(

                const KeyboardKey(
                  key: 'backspace',
                  label: '⌫',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  // ==============================================================
  // КЛАВИША SHIFT
  // ==============================================================

  Widget _buildShiftKey() {

    return _TypingKeyWidget(

      label:
          'SHIFT',

      secondaryLabel:
          null,

      tertiaryLabel:
          null,


      isActive:
          _isShiftActive,


      // ----------------------------------------------------------
      // SHIFT — переключатель.
      // ----------------------------------------------------------

      onDown: () {

        _toggleShift();
      },


      // ----------------------------------------------------------
      // Ничего не делаем при отпускании пальца.
      // ----------------------------------------------------------

      onUp: () {},

      onCancel: () {},
    );
  }


  // ==============================================================
  // НИЖНИЙ СИСТЕМНЫЙ РЯД
  // ==============================================================

  Widget _buildBottomSystemRow() {

    return Padding(

      padding:
          const EdgeInsets.symmetric(
        vertical: 2,
      ),


      child: Row(

        children: [

          // ------------------------------------------------------
          // 123
          // ------------------------------------------------------

          Expanded(

            flex: 1,

            child: Padding(

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 2,
              ),


              child:
                  _buildSpecialKey(

                label:
                    '123',


                onDown: () {

                  widget.onSpecialKeyboard();
                },
              ),
            ),
          ),


          // ------------------------------------------------------
          // СМЕНА ЯЗЫКА
          // ------------------------------------------------------

          Expanded(

            flex: 1,

            child: Padding(

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 2,
              ),


              child:
                  _buildSpecialKey(

                label:
                    '🌐',


                onDown: () {

                  widget.commandSender
                      .changeLanguage();
                },
              ),
            ),
          ),


          // ------------------------------------------------------
          // ЗАПЯТАЯ
          // ------------------------------------------------------

          Expanded(

            flex: 1,

            child: Padding(

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 2,
              ),


              child:
                  _buildSpecialKey(

                label:
                    ',',


                onDown: () {

                  widget.commandSender
                      .text(',');
                },
              ),
            ),
          ),


          // ------------------------------------------------------
          // ПРОБЕЛ
          // ------------------------------------------------------

          Expanded(

            flex: 3,

            child: Padding(

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 2,
              ),


              child:
                  _buildKey(

                const KeyboardKey(
                  key: 'space',
                  label: 'SPACE',
                ),
              ),
            ),
          ),


          // ------------------------------------------------------
          // ТОЧКА
          // ------------------------------------------------------

          Expanded(

            flex: 1,

            child: Padding(

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 2,
              ),


              child:
                  _buildSpecialKey(

                label:
                    '.',


                onDown: () {

                  widget.commandSender
                      .text('.');
                },
              ),
            ),
          ),


          // ------------------------------------------------------
          // ENTER
          // ------------------------------------------------------

          Expanded(

            flex: 13 ~/ 10,

            child: Padding(

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 2,
              ),


              child:
                  _buildKey(

                const KeyboardKey(
                  key: 'enter',
                  label: '↵',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  // ==============================================================
  // ОБЫЧНАЯ КЛАВИША
  // ==============================================================
  //
  // sendAsText = true
  //
  // Используется для цифр.
  //
  // sendAsText = false
  //
  // Используется для обычных физических клавиш.
  //
  // ==============================================================

  Widget _buildKey(
    KeyboardKey keyboardKey, {

    bool sendAsText = false,
  }) {

    // ============================================================
    // ТЕКСТОВАЯ КЛАВИША
    // ============================================================

    if (sendAsText) {

      return _TypingKeyWidget(

        label:
            keyboardKey.label,


        secondaryLabel:
            keyboardKey.secondaryLabel,


        tertiaryLabel:
            _getUpperSymbol(
              keyboardKey.key,
            ),


        isActive:
            false,


        // --------------------------------------------------------
        // Отправляем цифру как TEXT.
        // --------------------------------------------------------

        onDown: () {

          widget.commandSender.text(
            keyboardKey.key,
          );
        },


        // --------------------------------------------------------
        // Ничего не отправляем при отпускании.
        // --------------------------------------------------------

        onUp: () {},


        onCancel: () {},
      );
    }


    // ============================================================
    // ОБЫЧНАЯ ФИЗИЧЕСКАЯ КЛАВИША
    // ============================================================

    return _TypingKeyWidget(

      label:
          keyboardKey.label,


      secondaryLabel:
          keyboardKey.secondaryLabel,


      tertiaryLabel:
          _getUpperSymbol(
        keyboardKey.key,
      ),


      isActive:
          false,


      onDown: () {

        _handleKeyDown(
          keyboardKey,
        );
      },


      onUp: () {

        _handleKeyUp(
          keyboardKey,
        );
      },


      onCancel: () {

        widget.commandSender.keyUp(
          keyboardKey.key,
        );
      },
    );
  }


  // ==============================================================
  // ДОПОЛНИТЕЛЬНЫЙ СИМВОЛ
  // ==============================================================

  String? _getUpperSymbol(
    String key,
  ) {

    switch (key) {

      case '[':
        return '{';

      case ']':
        return '}';

      case ';':
        return ':';

      case '\'':
        return '"';

      case ',':
        return '<';

      case '.':
        return '>';

      default:
        return null;
    }
  }


  // ==============================================================
  // СПЕЦИАЛЬНАЯ КЛАВИША
  // ==============================================================

  Widget _buildSpecialKey({

    required String label,

    required VoidCallback onDown,
  }) {

    return _TypingKeyWidget(

      label:
          label,


      secondaryLabel:
          null,


      tertiaryLabel:
          null,


      isActive:
          false,


      onDown:
          onDown,


      onUp:
          () {},


      onCancel:
          () {},
    );
  }
}


// ==================================================================
// ВИДЖЕТ КЛАВИШИ
// ==================================================================

class _TypingKeyWidget
    extends StatefulWidget {

  final String label;

  final String? secondaryLabel;

  final String? tertiaryLabel;

  final bool isActive;

  final VoidCallback onDown;

  final VoidCallback onUp;

  final VoidCallback onCancel;


  const _TypingKeyWidget({

    required this.label,

    required this.secondaryLabel,

    required this.tertiaryLabel,

    required this.isActive,

    required this.onDown,

    required this.onUp,

    required this.onCancel,
  });


  @override
  State<_TypingKeyWidget> createState() =>
      _TypingKeyWidgetState();
}


class _TypingKeyWidgetState
    extends State<_TypingKeyWidget> {

  bool _isPressed = false;


  // ==============================================================
  // НАЖАТИЕ
  // ==============================================================

  void _handleDown() {

    setState(() {

      _isPressed = true;
    });


    widget.onDown();
  }


  // ==============================================================
  // ОТПУСКАНИЕ
  // ==============================================================

  void _handleUp() {

    setState(() {

      _isPressed = false;
    });


    widget.onUp();
  }


  // ==============================================================
  // ОТМЕНА
  // ==============================================================

  void _handleCancel() {

    setState(() {

      _isPressed = false;
    });


    widget.onCancel();
  }


  // ==============================================================
  // UI
  // ==============================================================

  @override
  Widget build(BuildContext context) {

    // ------------------------------------------------------------
    // Клавиша активна если:
    //
    // 1. палец сейчас находится на ней;
    //
    // ИЛИ
    //
    // 2. родитель сообщил, что она активна.
    // ------------------------------------------------------------

    final isActive =
        _isPressed ||
        widget.isActive;


    return Listener(

      behavior:
          HitTestBehavior.opaque,


      // ----------------------------------------------------------
      // Палец коснулся клавиши.
      // ----------------------------------------------------------

      onPointerDown: (_) {

        _handleDown();
      },


      // ----------------------------------------------------------
      // Палец отпустил клавишу.
      // ----------------------------------------------------------

      onPointerUp: (_) {

        _handleUp();
      },


      // ----------------------------------------------------------
      // Касание отменено.
      // ----------------------------------------------------------

      onPointerCancel: (_) {

        _handleCancel();
      },


      child: AnimatedContainer(

        duration:
            const Duration(
          milliseconds: 70,
        ),


        decoration:
            BoxDecoration(

          color:
              isActive
                  ? Colors.white.withValues(
                      alpha: 0.12,
                    )
                  : Colors.white.withValues(
                      alpha: 0.04,
                    ),


          border:
              Border.all(

            color:
                isActive
                    ? Colors.white.withValues(
                        alpha: 0.30,
                      )
                    : Colors.white.withValues(
                        alpha: 0.10,
                      ),

            width: 1,
          ),


          borderRadius:
              BorderRadius.circular(7),
        ),


        child: Stack(

          children: [

            // ====================================================
            // ОСНОВНАЯ НАДПИСЬ
            // ====================================================

            Align(

              alignment:
                  Alignment.center,


              child: Text(

                widget.label,


                style: TextStyle(

                  fontSize:
                      16,


                  fontWeight:
                      FontWeight.w600,


                  color:
                      Colors.white.withValues(

                    alpha:
                        isActive
                            ? 0.95
                            : 0.78,
                  ),
                ),
              ),
            ),


            // ====================================================
            // ВЕРХНИЙ РЕГИСТР
            // ====================================================

            if (widget.tertiaryLabel != null)

              Positioned(

                left: 6,

                top: 4,


                child: Text(

                  widget.tertiaryLabel!,


                  style: TextStyle(

                    fontSize:
                        13,


                    fontWeight:
                        FontWeight.w500,


                    color:
                        Colors.white.withValues(

                      alpha:
                          isActive
                              ? 0.65
                              : 0.42,
                    ),
                  ),
                ),
              ),


            // ====================================================
            // РУССКАЯ БУКВА
            // ====================================================

            if (widget.secondaryLabel != null)

              Positioned(

                right: 6,

                bottom: 4,


                child: Text(

                  widget.secondaryLabel!,


                  style: TextStyle(

                    fontSize:
                        14,


                    fontWeight:
                        FontWeight.w500,


                    color:
                        Colors.white.withValues(

                      alpha:
                          isActive
                              ? 0.70
                              : 0.48,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}