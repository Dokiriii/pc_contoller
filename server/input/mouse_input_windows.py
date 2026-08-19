# commands/mouse_input_windows.py

import ctypes
from ctypes import wintypes


# ---------------------------------------------------------
# Общие значения
# ---------------------------------------------------------

INPUT_MOUSE = 0


# Относительное движение мыши.
MOUSEEVENTF_MOVE = 0x0001


# Прокрутка колеса мыши.
MOUSEEVENTF_WHEEL = 0x0800


# Стандартное значение одного шага колеса Windows.
WHEEL_DELTA = 120


# ---------------------------------------------------------
# MOUSEINPUT
# ---------------------------------------------------------

class MOUSEINPUT(ctypes.Structure):

    _fields_ = [
        ("dx", wintypes.LONG),
        ("dy", wintypes.LONG),
        ("mouseData", wintypes.DWORD),
        ("dwFlags", wintypes.DWORD),
        ("time", wintypes.DWORD),
        ("dwExtraInfo", ctypes.POINTER(wintypes.ULONG)),
    ]


# ---------------------------------------------------------
# INPUT
# ---------------------------------------------------------

class INPUT(ctypes.Structure):

    _fields_ = [
        ("type", wintypes.DWORD),
        ("mi", MOUSEINPUT),
    ]


# ---------------------------------------------------------
# SendInput
# ---------------------------------------------------------

SendInput = ctypes.windll.user32.SendInput


SendInput.argtypes = (
    wintypes.UINT,
    ctypes.POINTER(INPUT),
    ctypes.c_int,
)


SendInput.restype = wintypes.UINT


# ---------------------------------------------------------
# Движение мыши
# ---------------------------------------------------------

def move_mouse(dx, dy):

    mouse_input = MOUSEINPUT(
        dx=int(dx),
        dy=int(dy),
        mouseData=0,
        dwFlags=MOUSEEVENTF_MOVE,
        time=0,
        dwExtraInfo=None,
    )


    input_event = INPUT(
        type=INPUT_MOUSE,
        mi=mouse_input,
    )


    result = SendInput(
        1,
        ctypes.byref(input_event),
        ctypes.sizeof(INPUT),
    )


    if result != 1:
        raise ctypes.WinError()


# ---------------------------------------------------------
# Прокрутка мыши
# ---------------------------------------------------------

def scroll_mouse(amount):

    amount = int(amount)


    if amount == 0:
        return


    mouse_data = amount * WHEEL_DELTA


    mouse_input = MOUSEINPUT(
        dx=0,
        dy=0,
        mouseData=mouse_data,
        dwFlags=MOUSEEVENTF_WHEEL,
        time=0,
        dwExtraInfo=None,
    )


    input_event = INPUT(
        type=INPUT_MOUSE,
        mi=mouse_input,
    )


    result = SendInput(
        1,
        ctypes.byref(input_event),
        ctypes.sizeof(INPUT),
    )


    if result != 1:
        raise ctypes.WinError()