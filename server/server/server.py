# server.py
# Импортируем модуль socket для работы с сокетами
import socket
import threading

from server.connection import Connection, ConnectionContext
from server.udp_connection import UdpConnection
from server.protocol import parse_command
from server.router import route_command

import time


tcpserver = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Создаём UDP-соединение.
#
# UDP используется для передачи движения мыши.
# Для него используется отдельный порт.
udp_connection = UdpConnection(
    host="0.0.0.0",
    port=8081
)

# Обрабатывает UDP-команды.
#
# UDP используется только для команд,
# которым не требуется подтверждение доставки.
def udp_worker(context):

    packet_count = 0

    while True:

        try:
            # Получаем один UDP-пакет.
            raw_command, client_address = udp_connection.receive()

        except OSError:
            # Сокет был закрыт.
            break

        packet_count += 1

        if packet_count % 100 == 0:
            print(f"[UDP] Получено пакетов: {packet_count}")

        try:
            # Превращаем JSON-строку в Python-словарь.
            command = parse_command(raw_command)

        except ValueError as error:
            print(f"[UDP] Ошибка команды: {error}")
            continue

        # Отправляем команду в тот же роутер,
        # который используется TCP-соединением.
        #
        # Ответ клиенту здесь не отправляем,
        # потому что UDP используется для движения мыши.

        start_time = time.perf_counter()

        route_command(command, context)

        elapsed = time.perf_counter() - start_time

        if elapsed > 0.01:
            print(f"[UDP] Обработка заняла {elapsed:.4f} сек")



udp_connection.start()

# Устанавливаем адрес и порт для сервера.
# 0.0.0.0 означает, что сервер принимает подключения
# через все сетевые интерфейсы компьютера.
server_address = ("0.0.0.0", 8080)

tcpserver.bind(server_address)
tcpserver.listen(1024)

print("Сервер запущен. Ожидание подключения...")

client_socket, client_address = tcpserver.accept()

print(f"Клиент подключился: {client_address}")


context = ConnectionContext(
    server_socket=tcpserver,
    client_socket=client_socket,
    client_address=client_address
)

connection = Connection(context)

# Запускаем отдельный поток для UDP.
#
# TCP продолжит работать в основном потоке,
# а UDP будет одновременно принимать пакеты
# в отдельном потоке.
udp_thread = threading.Thread(
    target=udp_worker,
    args=(context,),
    daemon=True
)

udp_thread.start()

while True:

    # Вызываем метод получения и сборки команд из буфера сокета
    commands = connection.receive_commands()

    # Если метод вернул None, значит клиент физически разорвал соединение
    if commands is None:
        print("Клиент отключился")
        break

    # ОБРАБОТКА ПАКЕТА КОМАНД (Конструкция FOR-ELSE)
    # Перебираем все готовые строковые команды, которые удалось извлечь из буфера
    for raw_command in commands:

        try:
            # Пытаемся распарсить сырую строку в Python-словарь (JSON)
            command = parse_command(raw_command)

        except ValueError as error:
            print(f"Ошибка команды: {error}")
            continue

        print(f"\nСЕРВЕР")
        print(f"Пришло от: {client_address}")
        print(f"Команда: {command}")

        # Отправляем команду в роутер для исполнения. Команда возвращает результат
        # выполнения команды.
        result = route_command(command, context)

        # Отправляем результат выполнения команды на клиент
        connection.send_response({
            "type": "RESPONSE",
            "status": "ok" if result.success else "error",
            "message": result.message
        })

        # Если should_stop в результате выполнения команды равен True, то программа завершает работу
        if result.should_stop:
            break

    # Этот блок относится к циклу FOR. Он срабатывает ТОЛЬКО если цикл FOR
    # завершился штатно (перебрал все элементы) или если список commands был ПУСТЫМ [].
    # То есть, если НЕ сработал внутренний экстренный 'break' (не было команды закрытия).       
    else:
        continue
    # Сюда код попадает только в одном случае: если цикл FOR был прерван через 'break' 
    # (сработал флаг should_stop).
    break


# Закрываем UDP-сокет.
udp_connection.close()

# Закрываем TCP-соединение.
connection.close()
