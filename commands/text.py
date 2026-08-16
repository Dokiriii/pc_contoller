# commands/text.py
import pyautogui
import pyperclip


def write_text(text):
    pyperclip.copy(text)
    pyautogui.hotkey("ctrl", "v")


text_actions = {
    "write": write_text
}
