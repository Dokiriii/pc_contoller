import time
import pyautogui


for i in range(10):

    start_time = time.perf_counter()

    pyautogui.moveRel(1, 1)

    elapsed = time.perf_counter() - start_time

    print(f"moveRel: {elapsed:.4f} сек")