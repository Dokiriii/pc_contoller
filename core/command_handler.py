# core/command_handler.py
from commands.system import close_connections


system_commands = {
    "close_conn": close_connections
}


def keyboard_handler(command, context):
    print(f"[Keyboard] Получена команда: {command}")


def mouse_handler(command, context):
    print(f"[Mouse] Получена команда: {command}")


def text_handler(command, context):
    print(f"[Text] Получена команда: {command}")


def system_handler(command, context):
    print(f"[System] Получена команда: {command}")

    command_action = command.get("action")

    handler = system_commands.get(command_action)

    if handler is None:
        print(f"Неизвестная системная команда: {command_action}")
        return False

    return handler(context)
