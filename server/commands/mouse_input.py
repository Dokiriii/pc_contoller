# commands/mouse_input.py
import platform


# Выбираем реализацию управления мышью
# в зависимости от операционной системы.
if platform.system() == "Windows":

    from commands.mouse_input_windows import move_mouse


elif platform.system() == "Linux":

    from commands.mouse_input_linux import move_mouse


else:

    raise RuntimeError(
        f"Неподдерживаемая операционная система: {platform.system()}"
    )
