# serve/protocol.py

# Функция оразделения типа и назначения команды, используется в server.py
def parse_command(data):
    if ":" not in data:
        raise ValueError("В команде отсутствует разделитель ':'")

    command_type, command_data = data.split(":", 1)

    if not command_type:
        raise ValueError("Не указан тип команды")

    if not command_data:
        raise ValueError("Отсутствуют данные команды")

    return command_type, command_data