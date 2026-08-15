# server/router.py
from core.command_handler import (
    keyboard_handler,
    mouse_handler,
    text_handler
)


routes = {
    "KEY": keyboard_handler,
    "MOUSE": mouse_handler,
    "TEXT": text_handler
}


def route_command(command_type, command_data):
    handler = routes.get(command_type)
    print(handler)

    if handler is None:
        print(f"Неизвестный тип команды: {command_type}")
        return

    handler(command_data)