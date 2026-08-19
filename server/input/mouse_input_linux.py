# commands/mouse_input_linux.py

import ctypes


# Загружаем библиотеку XTEST.
lib_xtst = ctypes.CDLL(
    "libXtst.so.6"
)


# Загружаем библиотеку X11.
lib_x11 = ctypes.CDLL(
    "libX11.so.6"
)


# ---------------------------------------------------------
# X11
# ---------------------------------------------------------

lib_x11.XOpenDisplay.argtypes = [
    ctypes.c_char_p,
]

lib_x11.XOpenDisplay.restype = ctypes.c_void_p


display = lib_x11.XOpenDisplay(None)


if not display:
    raise RuntimeError(
        "Не удалось подключиться к X11"
    )


# ---------------------------------------------------------
# Движение мыши
# ---------------------------------------------------------

lib_xtst.XTestFakeRelativeMotionEvent.argtypes = [
    ctypes.c_void_p,
    ctypes.c_int,
    ctypes.c_int,
    ctypes.c_ulong,
    ctypes.c_uint,
]

lib_xtst.XTestFakeRelativeMotionEvent.restype = ctypes.c_int


# ---------------------------------------------------------
# Кнопки мыши / scroll
# ---------------------------------------------------------

lib_xtst.XTestFakeButtonEvent.argtypes = [
    ctypes.c_void_p,
    ctypes.c_uint,
    ctypes.c_int,
    ctypes.c_ulong,
]

lib_xtst.XTestFakeButtonEvent.restype = ctypes.c_int


# ---------------------------------------------------------
# Flush
# ---------------------------------------------------------

lib_x11.XFlush.argtypes = [
    ctypes.c_void_p,
]

lib_x11.XFlush.restype = ctypes.c_int


# ---------------------------------------------------------
# Движение мыши
# ---------------------------------------------------------

def move_mouse(dx, dy):

    result = lib_xtst.XTestFakeRelativeMotionEvent(
        display,
        int(dx),
        int(dy),
        0,
        0,
    )


    if result == 0:
        raise RuntimeError(
            "X11 не принял событие движения мыши"
        )


    lib_x11.XFlush(display)


# ---------------------------------------------------------
# Прокрутка мыши
# ---------------------------------------------------------

def scroll_mouse(amount):

    amount = int(amount)


    if amount == 0:
        return


    # Определяем направление прокрутки.
    #
    # 4 = вверх
    # 5 = вниз
    button = 4 if amount > 0 else 5


    # Количество шагов прокрутки.
    steps = abs(amount)


    for _ in range(steps):

        # Нажатие виртуальной кнопки scroll.
        result = lib_xtst.XTestFakeButtonEvent(
            display,
            button,
            1,
            0,
        )


        if result == 0:
            raise RuntimeError(
                "X11 не принял событие прокрутки"
            )


        # Отпускание виртуальной кнопки scroll.
        result = lib_xtst.XTestFakeButtonEvent(
            display,
            button,
            0,
            0,
        )


        if result == 0:
            raise RuntimeError(
                "X11 не принял событие прокрутки"
            )


    lib_x11.XFlush(display)