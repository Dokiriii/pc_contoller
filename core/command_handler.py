# core/command_handler.py
from commands.keyboard import keyboard_actions
from commands.text import text_actions
from commands.mouse import mouse_actions
from commands.system import shutdown_server


system_commands = {
    "shutdown": shutdown_server
    }


from core.command_result import CommandResult


def keyboard_handler(command, context):
    action = command.get("action")
    data = command.get("data")

    handler = keyboard_actions.get(action)

    if handler is None:
        return CommandResult(
            success=False,
            message=f"Неизвестное действие клавиатуры: {action}"
        )

    if data is None:
        return CommandResult(
            success=False,
            message=f"Не указаны данные для действия: {action}"
        )

    if action == "hotkey" and not isinstance(data, list):
        return CommandResult(
            success=False,
            message="Для hotkey data должна быть списком"
        )

    handler(data)

    return CommandResult(success=True)

def text_handler(command, context):
    action = command.get("action")
    data = command.get("data")

    handler = text_actions.get(action)

    if handler is None:
        return CommandResult(
            success=False,
            message="Неизвестное действие ввода текста: {action}"
        )

    if data is None:
        return CommandResult(
            success=False,
            message=f"Не указаны данные для действия: {action}"
        )

    handler(data)

    return CommandResult(success=True)


def mouse_handler(command, context):
    action = command.get("action")
    data = command.get("data")

    handler = mouse_actions.get(action)

    if handler is None:
        return CommandResult(
            success=False,
            message=f"Неизвестное действие мыши: {action}"
        )

    if data is None:
        return CommandResult(
            success=False,
            message=f"Не указаны данные для действия: {action}"
        )

    handler(data)

    return CommandResult(success=True)


def system_handler(command, context):
    action = command.get("action")

    handler = system_commands.get(action)

    if handler is None:
        return CommandResult(
            success=False,
            message=f"Неизвестная системная команда: {action}"
        )

    return handler(context)
