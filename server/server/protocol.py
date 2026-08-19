# server/protocol.py

import json


# Функция определения типа и назначения команды,
# используется в server.py
def parse_command(data):

    try:

        command = json.loads(data)

    except json.JSONDecodeError as error:

        raise ValueError(
            f"Некорректный JSON: {error}"
        )


    if not isinstance(command, dict):

        raise ValueError(
            "Команда должна быть JSON-объектом"
        )


    # Сначала проверяем наличие обязательных полей.

    if "type" not in command:

        raise ValueError(
            "Отсутствует поле 'type'"
        )


    if "action" not in command:

        raise ValueError(
            "Отсутствует поле 'action'"
        )


    # Только после проверки существования
    # проверяем тип этих полей.

    if not isinstance(command["type"], str):

        raise ValueError(
            "Поле 'type' должно быть строкой"
        )


    if not isinstance(command["action"], str):

        raise ValueError(
            "Поле 'action' должно быть строкой"
        )


    return command
