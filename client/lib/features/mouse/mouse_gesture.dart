// features/mouse/mouse_gesture.dart

import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/commands/command_sender.dart';


class MouseGesture {

  final CommandSender commandSender;


  MouseGesture({
    required this.commandSender,
  });


  // ============================================================
  // НАСТРОЙКИ МЫШИ
  // ============================================================
  //
  // Чувствительность обычного движения.
  //
  // Чем больше значение,
  // тем дальше перемещается курсор
  // при том же движении пальца.
  //
  // Было:
  //
  //     1.0
  //
  // Сейчас:
  //
  //     1.5
  //
  // ============================================================

  static const double mouseSensitivity = 1.6;


  // ============================================================
  // ЧАСТОТА ОТПРАВКИ ДВИЖЕНИЯ
  // ============================================================
  //
  // Было:
  //
  //     16 ms ≈ 60 раз/сек
  //
  // Сейчас:
  //
  //     12 ms ≈ 83 раза/сек
  //
  // Движение при этом всё равно накапливается
  // между отправками.
  //
  // ============================================================

  static const Duration moveInterval =
      Duration(milliseconds: 12);


  // ============================================================
  // ЧУВСТВИТЕЛЬНОСТЬ СКРОЛЛА
  // ============================================================
  //
  // Было:
  //
  //     1.0
  //
  // Сейчас:
  //
  //     0.5
  //
  // Поэтому один и тот же жест пальцем
  // будет прокручивать примерно в два раза меньше.
  //
  // ============================================================

  static const double scrollSensitivity = 0.3;


  // ============================================================
  // ДВИЖЕНИЕ МЫШИ
  // ============================================================

  double _dx = 0;
  double _dy = 0;

  Timer? _moveTimer;


  // ============================================================
  // СКРОЛЛ
  // ============================================================

  double _scroll = 0;

  Timer? _scrollTimer;


  // ============================================================
  // АКТИВНЫЕ ПАЛЬЦЫ
  // ============================================================

  final Map<int, Offset> _pointers = {};


  // ============================================================
  // СОСТОЯНИЕ ТАПА
  // ============================================================

  bool _hasFirstTap = false;

  DateTime? _firstTapTime;

  Offset? _firstTapPosition;

  String? _firstTapButton;

  Timer? _doubleTapTimer;


  // ============================================================
  // DRAG
  // ============================================================

  Timer? _dragTimer;

  Offset? _dragStartPosition;

  String? _dragButton;

  bool _isDragging = false;


  // ============================================================
  // НАСТРОЙКИ ЖЕСТОВ
  // ============================================================

  static const Duration doubleTapTimeout =
      Duration(milliseconds: 250);


  static const Duration dragHoldDuration =
      Duration(milliseconds: 200);


  static const double dragMovementThreshold = 10;


  // ============================================================
  // НАСТРОЙКИ ОБЛАСТИ ПКМ
  // ============================================================

  static const double rightButtonWidthFactor = 0.5;

  static const double rightButtonHeightFactor = 0.45;


  // ============================================================
  // ЗАПУСК
  // ============================================================

  void init() {

    // Движение мыши отправляется примерно 83 раза в секунду.
    //
    // Между отправками dx/dy накапливаются.
    // Поэтому мы не теряем мелкие движения пальца.

    _moveTimer = Timer.periodic(
      moveInterval,
      (_) {
        _sendMovement();
      },
    );


    // Скролл оставляем примерно 30 раз в секунду.
    //
    // Его частоту пока не увеличиваем.
    // Нам достаточно уменьшить его чувствительность.

    _scrollTimer = Timer.periodic(
      const Duration(milliseconds: 33),
      (_) {
        _sendScroll();
      },
    );
  }


  // ============================================================
  // ОТПРАВКА ДВИЖЕНИЯ
  // ============================================================

  void _sendMovement() {

    if (_dx == 0 && _dy == 0) {
      return;
    }


    commandSender.moveMouse(

      _dx * mouseSensitivity,

      _dy * mouseSensitivity,
    );


    _dx = 0;

    _dy = 0;
  }


  // ============================================================
  // ОТПРАВКА СКРОЛЛА
  // ============================================================

  void _sendScroll() {

    if (_scroll == 0) {
      return;
    }


    commandSender.scrollMouse(
      _scroll * scrollSensitivity,
    );


    _scroll = 0;
  }


  // ============================================================
  // ОПРЕДЕЛЕНИЕ КНОПКИ
  // ============================================================

  String _getMouseButton(
    Offset position,
    Size size,
  ) {

    final rightButtonWidth =
        size.width * rightButtonWidthFactor;


    final rightButtonHeight =
        size.height * rightButtonHeightFactor;


    final rightButtonLeft =
        size.width - rightButtonWidth;


    final rightButtonTop =
        size.height - rightButtonHeight;


    final isInsideRightButton =
        position.dx >= rightButtonLeft &&
        position.dy >= rightButtonTop;


    if (isInsideRightButton) {
      return 'right';
    }


    return 'left';
  }


  // ============================================================
  // POINTER DOWN
  // ============================================================

  void handlePointerDown(
    PointerDownEvent event,
    Size size,
  ) {

    final pointerId = event.pointer;

    final position = event.localPosition;


    _pointers[pointerId] = position;


    // ==========================================================
    // ДВА ПАЛЬЦА
    // ==========================================================

    if (_pointers.length == 2) {

      _cancelDragWaiting();

      _cancelFirstTap();

      return;
    }


    if (_pointers.length != 1) {
      return;
    }


    // ==========================================================
    // ВТОРОЙ ПОСЛЕДОВАТЕЛЬНЫЙ ТАП
    // ==========================================================

    if (_hasFirstTap &&
        _firstTapTime != null) {

      final elapsed =
          DateTime.now().difference(
        _firstTapTime!,
      );


      if (elapsed <= doubleTapTimeout) {

        _doubleTapTimer?.cancel();


        if (_firstTapPosition != null &&
            _firstTapButton != null) {

          commandSender.mouseClick(
            _firstTapButton!,
          );
        }


        _hasFirstTap = false;

        _firstTapTime = null;

        _firstTapPosition = null;

        _firstTapButton = null;


        _dragStartPosition = position;


        _dragButton = _getMouseButton(
          position,
          size,
        );


        _dragTimer?.cancel();


        _dragTimer = Timer(
          dragHoldDuration,
          () {

            if (_pointers.length == 1 &&
                _dragStartPosition != null &&
                !_isDragging) {

              _isDragging = true;


              commandSender.mouseDown(
                _dragButton!,
              );
            }
          },
        );


        return;
      }
    }


    // ==========================================================
    // НОВЫЙ ПЕРВЫЙ ТАП
    // ==========================================================

    _cancelDragWaiting();


    _hasFirstTap = true;

    _firstTapTime = DateTime.now();

    _firstTapPosition = position;


    _firstTapButton = _getMouseButton(
      position,
      size,
    );


    _doubleTapTimer?.cancel();


    _doubleTapTimer = Timer(
      doubleTapTimeout,
      () {

        if (!_hasFirstTap) {
          return;
        }


        if (_firstTapButton != null) {

          commandSender.mouseClick(
            _firstTapButton!,
          );
        }


        _cancelFirstTap();
      },
    );
  }


  // ============================================================
  // POINTER MOVE
  // ============================================================

  void handlePointerMove(
    PointerMoveEvent event,
  ) {

    final pointerId = event.pointer;


    _pointers[pointerId] =
        event.localPosition;


    // ==========================================================
    // БОЛЬШЕ ДВУХ ПАЛЬЦЕВ
    // ==========================================================

    if (_pointers.length > 2) {
      return;
    }


    // ==========================================================
    // DRAG
    // ==========================================================

    if (_isDragging) {

      _dx += event.delta.dx;

      _dy += event.delta.dy;

      return;
    }


    // ==========================================================
    // ДВА ПАЛЬЦА → СКРОЛЛ
    // ==========================================================

    if (_pointers.length == 2) {

      _scroll += -event.delta.dy;

      return;
    }


    // ==========================================================
    // ОЖИДАНИЕ DRAG
    // ==========================================================

    if (_dragStartPosition != null) {

      final distance =
          (event.localPosition -
                  _dragStartPosition!)
              .distance;


      if (distance > dragMovementThreshold) {

        _cancelDragWaiting();


        _dx += event.delta.dx;

        _dy += event.delta.dy;
      }


      return;
    }


    // ==========================================================
    // ОДИН ПАЛЕЦ → ДВИЖЕНИЕ
    // ==========================================================

    if (_pointers.length == 1) {

      if (_hasFirstTap) {

        _cancelFirstTap();
      }


      _dx += event.delta.dx;

      _dy += event.delta.dy;
    }
  }


  // ============================================================
  // POINTER UP
  // ============================================================

  void handlePointerUp(
    PointerUpEvent event,
  ) {

    _pointers.remove(event.pointer);


    // ==========================================================
    // DRAG
    // ==========================================================

    if (_isDragging) {

      if (_dragButton != null) {

        commandSender.mouseUp(
          _dragButton!,
        );
      }


      _isDragging = false;

      _dragButton = null;

      _dragStartPosition = null;

      _cancelDragWaiting();


      return;
    }


    // ==========================================================
    // ВТОРОЙ ТАП ОТПУСТИЛИ ДО DRAG
    // ==========================================================

    if (_dragStartPosition != null) {

      final button = _dragButton;


      _cancelDragWaiting();


      if (button != null) {

        commandSender.mouseClick(
          button,
        );
      }


      return;
    }


    // ==========================================================
    // ВСЕ ПАЛЬЦЫ УШЛИ
    // ==========================================================

    if (_pointers.isEmpty) {

      _cancelDragWaiting();
    }
  }


  // ============================================================
  // POINTER CANCEL
  // ============================================================

  void handlePointerCancel(
    PointerCancelEvent event,
  ) {

    _pointers.remove(event.pointer);


    if (_isDragging &&
        _dragButton != null) {

      commandSender.mouseUp(
        _dragButton!,
      );
    }


    _isDragging = false;


    _cancelFirstTap();

    _cancelDragWaiting();


    if (_pointers.length < 2) {
      _scroll = 0;
    }
  }


  // ============================================================
  // ОТМЕНА ПЕРВОГО ТАПА
  // ============================================================

  void _cancelFirstTap() {

    _hasFirstTap = false;

    _firstTapTime = null;

    _firstTapPosition = null;

    _firstTapButton = null;

    _doubleTapTimer?.cancel();
  }


  // ============================================================
  // ОТМЕНА ОЖИДАНИЯ DRAG
  // ============================================================

  void _cancelDragWaiting() {

    _dragTimer?.cancel();

    _dragStartPosition = null;

    _dragButton = null;
  }


  // ============================================================
  // ОЧИСТКА
  // ============================================================

  void dispose() {

    _moveTimer?.cancel();

    _scrollTimer?.cancel();

    _doubleTapTimer?.cancel();

    _dragTimer?.cancel();


    if (_isDragging &&
        _dragButton != null) {

      commandSender.mouseUp(
        _dragButton!,
      );
    }


    _pointers.clear();
  }
}