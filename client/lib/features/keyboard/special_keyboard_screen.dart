// features/keyboard/special_keyboard_screen.dart

import 'package:flutter/material.dart';

import '../../core/commands/command_sender.dart';
import 'keyboard_layout.dart';


// ================================================================
// КЛАВИАТУРА СПЕЦИАЛЬНЫХ СИМВОЛОВ
// ================================================================
//
// Структура:
//
// ЦИФРЫ
//
// 1 2 3 4 5 6 7 8 9 0
//
// ~ ` ^ = [ ] { } | \
//
// @ # $ _ & % - + ( ) /
//
// SHIFT | * " ' : ; ! ? | BACKSPACE
//
// 123 | 🌐 | SPACE | ENTER
//
// ================================================================

class SpecialKeyboardScreen extends StatelessWidget {

  final CommandSender commandSender;


  final VoidCallback onTypingKeyboard;


  const SpecialKeyboardScreen({
    super.key,
    required this.commandSender,
    required this.onTypingKeyboard,
  });


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

                        Expanded(

                          child:
                              _buildNumberRow(),
                        ),


                        // ========================================
                        // СПЕЦИАЛЬНЫЕ СИМВОЛЫ
                        // ========================================

                        Expanded(

                          child:
                              _buildTextRow(
                            [
                              '~',
                              '`',
                              '^',
                              '=',
                              '[',
                              ']',
                              '{',
                              '}',
                              '|',
                              '\\',
                            ],
                          ),
                        ),


                        // ========================================
                        // СПЕЦИАЛЬНЫЕ СИМВОЛЫ
                        // ========================================

                        Expanded(

                          child:
                              _buildTextRow(
                            [
                              '@',
                              '#',
                              r'$',
                              '_',
                              '&',
                              '%',
                              '-',
                              '+',
                              '(',
                              ')',
                              '/',
                            ],
                          ),
                        ),


                        // ========================================
                        // SHIFT + СИМВОЛЫ + BACKSPACE
                        // ========================================

                        Expanded(

                          child:
                              _buildBottomSymbolRow(),
                        ),


                        // ========================================
                        // 123 + ЯЗЫК + SPACE + ENTER
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
  // ЦИФРЫ
  // ==============================================================
  //
  // Используем typingNumberRow из keyboard_layout.dart.
  //
  // ВАЖНО:
  //
  // Цифры отправляются через TEXT, а не через keyDown/keyUp.
  //
  // Поэтому:
  //
  // 1. раскладка компьютера не имеет значения;
  // 2. состояние SHIFT не имеет значения;
  // 3. CAPS LOCK не имеет значения;
  // 4. цифры всегда будут введены именно как цифры.
  //
  // ==============================================================

  Widget _buildNumberRow() {

    return Padding(

      padding:
          const EdgeInsets.symmetric(
        vertical: 2,
      ),


      child: Row(

        children:
            typingNumberRow.map((keyboardKey) {

          return Expanded(

            child: Padding(

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 2,
              ),


              child:
                  _buildTextKey(
                keyboardKey.label,
              ),
            ),
          );

        }).toList(),
      ),
    );
  }


  // ==============================================================
  // РЯД СПЕЦИАЛЬНЫХ СИМВОЛОВ
  // ==============================================================
  //
  // Каждый символ отправляется напрямую через TEXT.
  //
  // ==============================================================

  Widget _buildTextRow(
    List<String> symbols,
  ) {

    return Padding(

      padding:
          const EdgeInsets.symmetric(
        vertical: 2,
      ),


      child: Row(

        children:
            symbols.map((symbol) {

          return Expanded(

            child: Padding(

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 2,
              ),


              child:
                  _buildTextKey(
                symbol,
              ),
            ),
          );

        }).toList(),
      ),
    );
  }


  // ==============================================================
  // НИЖНИЙ СИМВОЛЬНЫЙ РЯД
  // ==============================================================
  //
  // SHIFT | * | " | ' | : | ; | ! | ? | BACKSPACE
  //
  // ==============================================================

  Widget _buildBottomSymbolRow() {

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
                  _buildKey(
                'shift',
                'SHIFT',
              ),
            ),
          ),


          // ------------------------------------------------------
          // СИМВОЛЫ
          // ------------------------------------------------------

          ...[
            '*',
            '"',
            '\'',
            ':',
            ';',
            '!',
            '?',
          ].map((symbol) {

            return Expanded(

              flex: 1,

              child: Padding(

                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 2,
                ),


                child:
                    _buildTextKey(
                  symbol,
                ),
              ),
            );
          }),


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
                'backspace',
                '⌫',
              ),
            ),
          ),
        ],
      ),
    );
  }


  // ==============================================================
  // НИЖНИЙ СИСТЕМНЫЙ РЯД
  // ==============================================================
  //
  // 123 | 🌐 | SPACE | ENTER
  //
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
                '123',

                () {

                  onTypingKeyboard();
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
                '🌐',

                () {

                  commandSender.changeLanguage();
                },
              ),
            ),
          ),


          // ------------------------------------------------------
          // SPACE
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
                'space',
                'SPACE',
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
                'enter',
                '↵',
              ),
            ),
          ),
        ],
      ),
    );
  }


  // ==============================================================
  // ОБЫЧНАЯ KEY-КЛАВИША
  // ==============================================================
  //
  // Используется для:
  //
  // SHIFT
  // BACKSPACE
  // SPACE
  // ENTER
  //
  // ==============================================================

  Widget _buildKey(
    String key,
    String label,
  ) {

    return _SpecialKeyWidget(

      label:
          label,


      onDown: () {

        commandSender.keyDown(
          key,
        );
      },


      onUp: () {

        commandSender.keyUp(
          key,
        );
      },


      onCancel: () {

        commandSender.keyUp(
          key,
        );
      },
    );
  }


  // ==============================================================
  // TEXT-КЛАВИША
  // ==============================================================
  //
  // Отправляет конкретный символ напрямую.
  //
  // Например:
  //
  // commandSender.text('5');
  // commandSender.text('@');
  //
  // Никаких keyDown/keyUp для этих символов нет.
  //
  // ==============================================================

  Widget _buildTextKey(
    String symbol,
  ) {

    return _SpecialKeyWidget(

      label:
          symbol,


      onDown: () {

        commandSender.text(
          symbol,
        );
      },


      onUp:
          () {},


      onCancel:
          () {},
    );
  }


  // ==============================================================
  // СПЕЦИАЛЬНАЯ КЛАВИША БЕЗ KEY
  // ==============================================================

  Widget _buildSpecialKey(
    String label,
    VoidCallback onDown,
  ) {

    return _SpecialKeyWidget(

      label:
          label,


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

class _SpecialKeyWidget
    extends StatefulWidget {

  final String label;

  final VoidCallback onDown;

  final VoidCallback onUp;

  final VoidCallback onCancel;


  const _SpecialKeyWidget({

    required this.label,

    required this.onDown,

    required this.onUp,

    required this.onCancel,
  });


  @override
  State<_SpecialKeyWidget> createState() =>
      _SpecialKeyWidgetState();
}


class _SpecialKeyWidgetState
    extends State<_SpecialKeyWidget> {

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

    return Listener(

      behavior:
          HitTestBehavior.opaque,


      onPointerDown: (_) {

        _handleDown();
      },


      onPointerUp: (_) {

        _handleUp();
      },


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
              _isPressed
                  ? Colors.white.withValues(
                      alpha: 0.12,
                    )
                  : Colors.white.withValues(
                      alpha: 0.04,
                    ),


          border:
              Border.all(

            color:
                _isPressed
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


        child:
            Center(

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
                    _isPressed
                        ? 0.95
                        : 0.78,
              ),
            ),
          ),
        ),
      ),
    );
  }
}