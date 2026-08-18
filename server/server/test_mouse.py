import time
import pyautogui


for i in range(10):

    start_time = time.perf_counter()

    pyautogui.moveTo(
        pyautogui.position().x + 1,
        pyautogui.position().y + 1,
        duration=0
    )

    elapsed = time.perf_counter() - start_time

    print(f"moveTo: {elapsed:.4f} сек")