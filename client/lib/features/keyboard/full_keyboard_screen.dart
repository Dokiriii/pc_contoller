// features/keyboard/full_keyboard_screen.dart

import 'package:flutter/material.dart';

import '../../core/commands/command_sender.dart';
import 'keyboard_key.dart';
import 'keyboard_layout.dart';


// ================================================================
// ПОЛНАЯ КЛАВИАТУРА
// ================================================================
//
// Полноценная компьютерная клавиатура.
//
// Предназначена в первую очередь для горизонтальной ориентации.
//
// Здесь находятся:
// - F1-F12
// - ESC
// - TAB
// - CAPS
// - SHIFT
// - CTRL
// - ALT
// - WIN
// - MENU
// - все символы
// - SPACE
// - ENTER
// - BACKSPACE
//
// Логика отправки команд находится в CommandSender.
class FullKeyboardScreen extends StatelessWidget {

  final CommandSender commandSender;


  const FullKeyboardScreen({
    super.key,
    required this.commandSender,
  });


  @override
  Widget build(BuildContext context) {

    return OrientationBuilder(

      builder: (context, orientation) {

        // ========================================================
        // ВЕРТИКАЛЬНАЯ ОРИЕНТАЦИЯ
        // ========================================================

        if (orientation == Orientation.portrait) {

          return Center(

            child: Column(

              mainAxisAlignment:
                  MainAxisAlignment.center,

              children: [

                Icon(
                  Icons.screen_rotation,
                  size: 56,

                  color:
                      Colors.white.withValues(
                    alpha: 0.35,
                  ),
                ),


                const SizedBox(
                  height: 16,
                ),


                Text(
                  'Поверните устройство\nгоризонтально',

                  textAlign:
                      TextAlign.center,

                  style: TextStyle(
                    fontSize: 18,

                    color:
                        Colors.white.withValues(
                      alpha: 0.55,
                    ),
                  ),
                ),
              ],
            ),
          );
        }


        // ========================================================
        // ГОРИЗОНТАЛЬНАЯ ОРИЕНТАЦИЯ
        // ========================================================

        return LayoutBuilder(

          builder: (
            context,
            constraints,
          ) {

            const verticalPadding = 3.0;

            const rowCount = 6;


            final availableHeight =
                constraints.maxHeight
                - 12
                - (verticalPadding * 2 * rowCount);


            final keyHeight =
                (availableHeight / rowCount)
                    .clamp(32.0, 52.0);


            return Padding(

              padding:
                  const EdgeInsets.symmetric(
                horizontal: 6,
                vertical: 6,
              ),

              child: Column(

                children: [

                  // ==================================================
                  // F1-F12
                  // ==================================================

                  Expanded(

                    child: Padding(

                      padding:
                          const EdgeInsets.symmetric(
                        vertical:
                            verticalPadding,
                      ),

                      child:
                          _buildKeyRow(
                        fullFunctionRow,
                        keyHeight,
                      ),
                    ),
                  ),


                  // ==================================================
                  // ЦИФРЫ
                  // ==================================================

                  Expanded(

                    child: Padding(

                      padding:
                          const EdgeInsets.symmetric(
                        vertical:
                            verticalPadding,
                      ),

                      child:
                          _buildKeyRow(
                        fullNumberRow,
                        keyHeight,
                      ),
                    ),
                  ),


                  // ==================================================
                  // QWERTY
                  // ==================================================

                  Expanded(

                    child: Padding(

                      padding:
                          const EdgeInsets.symmetric(
                        vertical:
                            verticalPadding,
                      ),

                      child:
                          _buildKeyRow(
                        fullTopRow,
                        keyHeight,
                      ),
                    ),
                  ),


                  // ==================================================
                  // ASDF
                  // ==================================================

                  Expanded(

                    child: Padding(

                      padding:
                          const EdgeInsets.symmetric(
                        vertical:
                            verticalPadding,
                      ),

                      child:
                          _buildKeyRow(
                        fullMiddleRow,
                        keyHeight,
                      ),
                    ),
                  ),


                  // ==================================================
                  // ZXCV
                  // ==================================================

                  Expanded(

                    child: Padding(

                      padding:
                          const EdgeInsets.symmetric(
                        vertical:
                            verticalPadding,
                      ),

                      child:
                          _buildKeyRow(
                        fullBottomRow,
                        keyHeight,
                      ),
                    ),
                  ),


                  // ==================================================
                  // CTRL / ALT / WIN / SPACE
                  // ==================================================

                  Expanded(

                    child: Padding(

                      padding:
                          const EdgeInsets.symmetric(
                        vertical:
                            verticalPadding,
                      ),

                      child:
                          _buildKeyRow(
                        fullControlRow,
                        keyHeight,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }


  // ============================================================
  // РЯД КЛАВИШ
  // ============================================================

  Widget _buildKeyRow(
    List<KeyboardKey> keys,
    double keyHeight,
  ) {

    return Row(

      children:
          keys.map((keyboardKey) {

        return Expanded(

          flex:
              _getKeyFlex(
            keyboardKey,
          ),

          child: Padding(

            padding:
                const EdgeInsets.symmetric(
              horizontal: 2,
            ),

            child:
                _buildKey(
              keyboardKey,
              keyHeight,
            ),
          ),
        );

      }).toList(),
    );
  }


  // ============================================================
  // РАЗМЕР КЛАВИШИ
  // ============================================================

  int _getKeyFlex(
    KeyboardKey keyboardKey,
  ) {

    switch (keyboardKey.key) {

      // --------------------------------------------------------
      // SPACE
      // --------------------------------------------------------

      case 'space':
        return 5;


      // --------------------------------------------------------
      // БОЛЬШИЕ КЛАВИШИ
      // --------------------------------------------------------

      case 'backspace':
        return 2;

      case 'enter':
        return 2;

      case 'shift':
        return 2;

      case 'capslock':
        return 2;

      case 'tab':
        return 2;


      // --------------------------------------------------------
      // ОСТАЛЬНЫЕ
      // --------------------------------------------------------

      default:
        return 1;
    }
  }


  // ============================================================
  // ОДНА КЛАВИША
  // ============================================================

  Widget _buildKey(
    KeyboardKey keyboardKey,
    double keyHeight,
  ) {

    return _KeyboardKeyWidget(

      height:
          keyHeight,

      // Основная надпись.
      //
      // Например:
      // Q
      // [
      // 1
      // ;
      label:
          keyboardKey.label,

      // Русская буква.
      //
      // Например:
      // Q → Й
      // [ → Х
      // ; → Ж
      secondaryLabel:
          keyboardKey.secondaryLabel,

      // Символ при нажатии Shift.
      //
      // Например:
      // 1 → !
      // [ → {
      // ; → :
      // ' → "
      // , → <
      // . → >
      shiftLabel:
          keyboardKey.shiftLabel,


      // ----------------------------------------------------------
      // НАЖАТИЕ
      // ----------------------------------------------------------

      onDown: () {

        commandSender.keyDown(
          keyboardKey.key,
        );
      },


      // ----------------------------------------------------------
      // ОТПУСКАНИЕ
      // ----------------------------------------------------------

      onUp: () {

        commandSender.keyUp(
          keyboardKey.key,
        );
      },


      // ----------------------------------------------------------
      // ОТМЕНА
      // ----------------------------------------------------------

      onCancel: () {

        commandSender.keyUp(
          keyboardKey.key,
        );
      },
    );
  }
}


// ================================================================
// ВИЗУАЛЬНАЯ КЛАВИША
// ================================================================
//
// Отдельный StatefulWidget нужен только для визуального состояния.
//
// Он не знает ничего о backend.
// Он только показывает,
// что клавиша сейчас нажата.
class _KeyboardKeyWidget
    extends StatefulWidget {

  final double height;

  final String label;

  final String? secondaryLabel;

  final String? shiftLabel;

  final VoidCallback onDown;

  final VoidCallback onUp;

  final VoidCallback onCancel;


  const _KeyboardKeyWidget({

    required this.height,

    required this.label,

    required this.secondaryLabel,

    required this.shiftLabel,

    required this.onDown,

    required this.onUp,

    required this.onCancel,
  });


  @override
  State<_KeyboardKeyWidget> createState() =>
      _KeyboardKeyWidgetState();
}


class _KeyboardKeyWidgetState
    extends State<_KeyboardKeyWidget> {

  bool _isPressed = false;


  // ============================================================
  // НАЖАТИЕ
  // ============================================================

  void _handleDown() {

    setState(() {
      _isPressed = true;
    });

    widget.onDown();
  }


  // ============================================================
  // ОТПУСКАНИЕ
  // ============================================================

  void _handleUp() {

    setState(() {
      _isPressed = false;
    });

    widget.onUp();
  }


  // ============================================================
  // ОТМЕНА
  // ============================================================

  void _handleCancel() {

    setState(() {
      _isPressed = false;
    });

    widget.onCancel();
  }


  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {

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
          milliseconds: 80,
        ),


        height:
            widget.height,


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


        alignment:
            Alignment.center,


        child: Stack(

          children: [

            // ==========================================================
            // ОСНОВНАЯ НАДПИСЬ
            // ==========================================================

            Align(

              alignment:
                  Alignment.center,

              child: Text(

                widget.label,

                style: TextStyle(

                  fontSize:
                      widget.label.length > 4
                          ? 10
                          : 12,

                  fontWeight:
                      FontWeight.w600,

                  color:
                      Colors.white.withValues(
                    alpha:
                        _isPressed
                            ? 0.95
                            : 0.70,
                  ),
                ),
              ),
            ),


            // ==========================================================
            // СИМВОЛ SHIFT
            // ==========================================================
            //
            // Например:
            //
            // !
            // 1
            //
            // {
            // [
            //
            // ==========================================================

            if (widget.shiftLabel != null)

              Positioned(

                left: 6,

                top: 4,

                child: Text(

                  widget.shiftLabel!,

                  style: TextStyle(

                    fontSize: 11,

                    fontWeight:
                        FontWeight.w500,

                    color:
                        Colors.white.withValues(
                      alpha:
                          _isPressed
                              ? 0.65
                              : 0.42,
                    ),
                  ),
                ),
              ),


            // ==========================================================
            // РУССКАЯ БУКВА
            // ==========================================================
            //
            // Например:
            //
            // Q
            //    Й
            //
            // ==========================================================

            if (widget.secondaryLabel != null)

              Positioned(

                right: 6,

                bottom: 4,

                child: Text(

                  widget.secondaryLabel!,

                  style: TextStyle(

                    fontSize: 11,

                    fontWeight:
                        FontWeight.w500,

                    color:
                        Colors.white.withValues(
                      alpha:
                          _isPressed
                              ? 0.65
                              : 0.42,
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