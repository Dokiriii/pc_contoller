// features/keyboard/keyboard_screen.dart

import 'package:flutter/material.dart';

import '../../core/commands/command_sender.dart';

import 'full_keyboard_screen.dart';


// ================================================================
// ЭКРАН ПОЛНОЙ КЛАВИАТУРЫ
// ================================================================
//
// Этот экран предназначен только для полноценной компьютерной
// клавиатуры.
//
// Печатная мобильная клавиатура здесь НЕ используется.
//
// Специальная клавиатура также НЕ переключается отсюда.
//
// Структура:
//
//     KeyboardScreen
//           ↓
//     FullKeyboardScreen
//
// Мобильная клавиатура и специальные символы используются
// отдельно в ControlScreen.
// ================================================================

class KeyboardScreen extends StatelessWidget {

  final CommandSender commandSender;


  const KeyboardScreen({
    super.key,
    required this.commandSender,
  });


  @override
  Widget build(BuildContext context) {

    return Scaffold(

      // ==========================================================
      // APP BAR
      // ==========================================================

      appBar: AppBar(

        title:
            const Text(
          'Полная клавиатура',
        ),
      ),


      // ==========================================================
      // ПОЛНАЯ КЛАВИАТУРА
      // ==========================================================

      body:
          FullKeyboardScreen(

        commandSender:
            commandSender,
      ),
    );
  }
}