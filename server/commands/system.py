# commands_system.py
from core.command_result import CommandResult

# Функция закрытия соединения
def shutdown_server(context):
    print("[System] Закрытие соединений...")
    return CommandResult(
        success=True,
        should_stop=True
    )