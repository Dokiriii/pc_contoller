# commands/mouse.py
import pyautogui
from commands.mouse_input import move_mouse as system_move_mouse


def move_mouse(data):
    dx = data.get("dx")
    dy = data.get("dy")

    if dx is None or dy is None:
        print("[Mouse] Не указаны dx или dy")
        return

    system_move_mouse(dx, dy)


def click_mouse(data):
    button = data.get("button")

    if button not in ("left", "right", "middle"):
        print(f"[Mouse] Неизвестная кнопка: {button}")
        return

    pyautogui.click(button=button)


def mouse_down(data):
    button = data.get("button")

    if button not in ("left", "right", "middle"):
        print(f"[Mouse] Неизвестная кнопка: {button}")
        return

    pyautogui.mouseDown(button=button)


def mouse_up(data):
    button = data.get("button")

    if button not in ("left", "right", "middle"):
        print(f"[Mouse] Неизвестная кнопка: {button}")
        return

    pyautogui.mouseUp(button=button)


def scroll_mouse(data):
    amount = data.get("amount")

    if amount is None:
        print("[Mouse] Не указано количество прокрутки")
        return

    if not isinstance(amount, (int, float)):
        print("[Mouse] amount должен быть числом")
        return

    pyautogui.scroll(amount)


mouse_actions = {
    "move": move_mouse,
    "click": click_mouse,
    "mouse_down": mouse_down,
    "mouse_up": mouse_up,
    "scroll": scroll_mouse
}
