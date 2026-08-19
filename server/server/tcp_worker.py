# server/tcp_worker.py

from server.protocol import parse_command
from server.router import route_command


# Обрабатывает TCP-соединение с одним клиентом.
#
# Функция работает до тех пор,
# пока клиент не отключится
# или не будет получена команда shutdown.
#
# Возвращает:
#
# False → клиент отключился,
#         сервер должен продолжить работу.
#
# True → получена команда завершения сервера.
def tcp_worker(
    connection,
    context
):

    while True:

        # Вызываем метод получения и сборки команд из буфера сокета.
        commands = connection.receive_commands()


        # Если метод вернул None,
        # значит клиент физически разорвал соединение.
        if commands is None:

            print(
                f"Клиент отключился: "
                f"{context.client_address}"
            )

            return False


        # ОБРАБОТКА ПАКЕТА КОМАНД (Конструкция FOR-ELSE)
        #
        # Перебираем все готовые строковые команды,
        # которые удалось извлечь из буфера.
        for raw_command in commands:

            try:

                # Пытаемся распарсить сырую строку
                # в Python-словарь (JSON)
                command = parse_command(
                    raw_command
                )

            except ValueError as error:

                print(
                    f"Ошибка команды: {error}"
                )

                continue


            print("\nСЕРВЕР")

            print(
                f"Пришло от: "
                f"{context.client_address}"
            )

            print(
                f"Команда: {command}"
            )


            # Отправляем команду в роутер для исполнения.
            #
            # Команда возвращает результат
            # выполнения команды.
            result = route_command(
                command,
                context
            )


            # Отправляем результат выполнения
            # команды на клиент.
            connection.send_response({

                "type": "RESPONSE",

                "status": (
                    "ok"
                    if result.success
                    else "error"
                ),

                "message": result.message

            })


            # Если should_stop в результате выполнения
            # команды равен True, то сервер должен
            # полностью завершить работу.
            if result.should_stop:

                return True


        # Этот цикл продолжается до тех пор,
        # пока клиент не отключится
        # или не будет получена команда shutdown.

