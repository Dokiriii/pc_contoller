# commands/mouse_input.py

import platform


system = platform.system()


if system == "Windows":

    from input.mouse_input_windows import (
        move_mouse,
        scroll_mouse,
    )


elif system == "Linux":

    from input.mouse_input_linux import (
        move_mouse,
        scroll_mouse,
    )


else:

    raise RuntimeError(
        f"Операционная система не поддерживается: {system}"
    )