# server/udp_worker.py

import time

from server.protocol import parse_command
from server.router import route_command


# Обрабатывает UDP-команды.
#
# UDP используется только для команд,
# которым не требуется подтверждение доставки.
def udp_worker(
    udp_connection,
    context,
    stop_event
):

    packet_count = 0


    while not stop_event.is_set():

        try:

            # Получаем один UDP-пакет.
            raw_command, client_address = (
                udp_connection.receive()
            )

        except OSError:

            # Сокет был закрыт.
            break


        packet_count += 1


        # Выводим количество полученных пакетов
        # не после каждого пакета,
        # а после каждого сотого.
        if packet_count % 100 == 0:

            print(
                f"[UDP] Получено пакетов: "
                f"{packet_count}"
            )


        try:

            # Превращаем JSON-строку
            # в Python-словарь.
            command = parse_command(
                raw_command
            )

        except ValueError as error:

            print(
                f"[UDP] Ошибка команды: {error}"
            )

            continue


        # Отправляем команду в тот же роутер,
        # который используется TCP-соединением.
        #
        # Ответ клиенту здесь не отправляем,
        # потому что UDP используется
        # для движения мыши.

        start_time = time.perf_counter()


        route_command(
            command,
            context
        )


        elapsed = (
            time.perf_counter()
            - start_time
        )


        # Если обработка команды заняла
        # больше 10 миллисекунд,
        # выводим предупреждение.
        if elapsed > 0.01:

            print(
                f"[UDP] Обработка заняла "
                f"{elapsed:.4f} сек"
            )
