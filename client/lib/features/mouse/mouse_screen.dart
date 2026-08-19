// features/mouse/mouse_screen.dart

import 'package:flutter/material.dart';

import '../../core/commands/command_sender.dart';
import 'mouse_gesture.dart';


// Область управления мышью.
//
// Этот виджет используется внутри ControlScreen.
//
// Здесь находится UI мыши.
// Логика жестов находится в MouseGesture.
class MouseScreen extends StatefulWidget {

  final CommandSender commandSender;


  const MouseScreen({
    super.key,
    required this.commandSender,
  });


  @override
  State<MouseScreen> createState() =>
      _MouseScreenState();
}


class _MouseScreenState extends State<MouseScreen> {

  // Объект отвечает за обработку жестов мыши.
  late final MouseGesture _mouseGesture;


  @override
  void initState() {
    super.initState();


    _mouseGesture = MouseGesture(
      commandSender: widget.commandSender,
    );


    _mouseGesture.init();
  }


  @override
  void dispose() {

    _mouseGesture.dispose();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        // ========================================================
        // ТАЧПАД
        // ========================================================

        Expanded(

          child: LayoutBuilder(
            builder: (context, constraints) {

              final size = Size(
                constraints.maxWidth,
                constraints.maxHeight,
              );


              return ClipRRect(

                borderRadius:
                    BorderRadius.circular(16),

                child: Stack(
                  children: [

                    // ==================================================
                    // ФОН ТАЧПАДА
                    // ==================================================

                    Container(
                      width: double.infinity,
                      height: double.infinity,

                      color: Colors.grey.shade900,
                    ),


                    // ==================================================
                    // СЕТКА
                    // ==================================================

                    CustomPaint(
                      size: Size.infinite,

                      painter: _MouseGridPainter(),
                    ),


                    // ==================================================
                    // ОБЛАСТЬ ОБРАБОТКИ ЖЕСТОВ
                    // ==================================================

                    Listener(

                      // Разрешаем получать касания
                      // по всей области тачпада.
                      behavior:
                          HitTestBehavior.opaque,


                      // ------------------------------------------------
                      // Палец появился.
                      // ------------------------------------------------

                      onPointerDown: (event) {

                        _mouseGesture.handlePointerDown(
                          event,
                          size,
                        );
                      },


                      // ------------------------------------------------
                      // Палец двигается.
                      // ------------------------------------------------

                      onPointerMove: (event) {

                        _mouseGesture.handlePointerMove(
                          event,
                        );
                      },


                      // ------------------------------------------------
                      // Палец отпущен.
                      // ------------------------------------------------

                      onPointerUp: (event) {

                        _mouseGesture.handlePointerUp(
                          event,
                        );
                      },


                      // ------------------------------------------------
                      // Жест отменён Flutter.
                      // ------------------------------------------------

                      onPointerCancel: (event) {

                        _mouseGesture.handlePointerCancel(
                          event,
                        );
                      },


                      child: const SizedBox.expand(),
                    ),


                    // ==================================================
                    // ОБЛАСТЬ ПКМ
                    // ==================================================
                    //
                    // Размер:
                    // 50% ширины
                    // 45% высоты
                    //
                    // Прижата к правому и нижнему краю.
                    //
                    // Это одновременно:
                    // 1. визуальная разметка;
                    // 2. реальная зона ПКМ.

                    IgnorePointer(
                      child: Align(
                        alignment: Alignment.bottomRight,

                        child: FractionallySizedBox(

                          widthFactor: 0.5,

                          heightFactor: 0.45,

                          child: Container(

                            decoration:
                                BoxDecoration(

                              border:
                                  Border.all(
                                color:
                                    Colors.white.withValues(
                                  alpha: 0.16,
                                ),

                                width: 1,
                              ),
                            ),

                            alignment:
                                Alignment.bottomCenter,

                            padding:
                                const EdgeInsets.only(
                              bottom: 8,
                            ),

                            child: Text(
                              'ПКМ',

                              style: TextStyle(
                                color:
                                    Colors.white.withValues(
                                  alpha: 0.30,
                                ),

                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),


                    // ==================================================
                    // НАДПИСЬ ЛКМ
                    // ==================================================
                    //
                    // Вся остальная область является зоной ЛКМ.

                    Align(

                      alignment:
                          const Alignment(
                        -0.5,
                        1.0,
                      ),

                      child: Padding(

                        padding:
                            const EdgeInsets.only(
                          bottom: 8,
                        ),

                        child: Text(
                          'ЛКМ',

                          style: TextStyle(
                            color:
                                Colors.white.withValues(
                              alpha: 0.30,
                            ),

                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),


                    // ==================================================
                    // ЦЕНТР ТАЧПАДА
                    // ==================================================

                    const Center(

                      child: IgnorePointer(

                        child: Icon(
                          Icons.mouse_outlined,

                          size: 42,

                          color: Colors.white24,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}


// ================================================================
// СЕТКА ТАЧПАДА
// ================================================================
//
// Painter отвечает только за визуальное оформление.
//
// Он ничего не знает о мыши,
// не обрабатывает касания
// и не связан с backend.
class _MouseGridPainter extends CustomPainter {

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {

    const gridSize = 40.0;


    final paint = Paint()
      ..color = Colors.white.withValues(
        alpha: 0.06,
      )
      ..strokeWidth = 1;


    // Вертикальные линии.

    for (
      double x = 0;
      x <= size.width;
      x += gridSize
    ) {

      canvas.drawLine(
        Offset(x, 0),
        Offset(x, size.height),
        paint,
      );
    }


    // Горизонтальные линии.

    for (
      double y = 0;
      y <= size.height;
      y += gridSize
    ) {

      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        paint,
      );
    }
  }


  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {

    return false;
  }
}

