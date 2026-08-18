import time

from commands.mouse_input_windows import move_mouse


for i in range(20):

    start_time = time.perf_counter()

    move_mouse(1, 1)

    elapsed = time.perf_counter() - start_time

    print(
        f"SendInput: {elapsed:.6f} сек"
    )