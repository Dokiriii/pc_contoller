import ctypes
from ctypes import wintypes


# Тип события.
INPUT_MOUSE = 0


# Флаг относительного движения мыши.
MOUSEEVENTF_MOVE = 0x0001


# Структура MOUSEINPUT из WinAPI.
#
# dx и dy здесь означают относительное
# изменение положения мыши.
class MOUSEINPUT(ctypes.Structure):
    _fields_ = [
        ("dx", wintypes.LONG),
        ("dy", wintypes.LONG),
        ("mouseData", wintypes.DWORD),
        ("dwFlags", wintypes.DWORD),
        ("time", wintypes.DWORD),
        ("dwExtraInfo", ctypes.POINTER(wintypes.ULONG)),
    ]


# Общая структура INPUT.
#
# Для нас используется только mouse.
class INPUT(ctypes.Structure):
    _fields_ = [
        ("type", wintypes.DWORD),
        ("mi", MOUSEINPUT),
    ]


# Получаем функцию SendInput из user32.dll.
SendInput = ctypes.windll.user32.SendInput


# Настраиваем типы аргументов функции.
SendInput.argtypes = (
    wintypes.UINT,
    ctypes.POINTER(INPUT),
    ctypes.c_int,
)


# SendInput возвращает количество
# успешно отправленных событий.
SendInput.restype = wintypes.UINT


def move_mouse(dx, dy):
    # Создаём событие движения мыши.
    mouse_input = MOUSEINPUT(
        dx=int(dx),
        dy=int(dy),
        mouseData=0,
        dwFlags=MOUSEEVENTF_MOVE,
        time=0,
        dwExtraInfo=None,
    )


    # Оборачиваем событие в INPUT.
    input_event = INPUT(
        type=INPUT_MOUSE,
        mi=mouse_input,
    )


    # Отправляем событие непосредственно
    # в системный поток ввода Windows.
    result = SendInput(
        1,
        ctypes.byref(input_event),
        ctypes.sizeof(INPUT),
    )


    # Если Windows не принял событие,
    # сообщаем об ошибке.
    if result != 1:
        raise ctypes.WinError()