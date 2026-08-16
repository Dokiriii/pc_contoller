# commands/keyboard.py
import pyautogui

def press_key(key):
    pyautogui.press(key)


def press_hotkey(keys):
    pyautogui.hotkey(*keys)


def key_down(key):
    pyautogui.keyDown(key)


def key_up(key):
    pyautogui.keyUp(key)

keyboard_actions = {
    "press": press_key,
    "hotkey": press_hotkey,
    "key_down": key_down,
    "key_up": key_up
}