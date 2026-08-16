# server/router.py
# Имортируем хэндлеры
from core.command_handler import (
    keyboard_handler,
    mouse_handler,
    text_handler,
    system_handler
)

# Принадлежность хэндлеров к типам команд
routes = {
    "KEY": keyboard_handler,
    "MOUSE": mouse_handler,
    "TEXT": text_handler,
    "SYSTEM_COMMAND": system_handler
}

# Функция перенаправления команды
def route_command(command, context):
    command_type = command.get("type")

    handler = routes.get(command_type)

    if handler is None:
        print(f"Неизвестный тип команды: {command_type}")
        return False

    return handler(command, context)