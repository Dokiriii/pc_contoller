# server.py
# Импортируем модуль socket для работы с сокетами
import socket

from server.connection import Connection, ConnectionContext
from server.protocol import parse_command
from server.router import route_command


tcpserver = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

server_address = ("127.0.0.1", 8080)

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

        # Отправляем команду в роутер для исполнения. 
        # Роутер вернет True, если это команда закрытия сервера (SYSTEM_COMMAND)
        should_stop = route_command(command, context)

        if should_stop:
            break

    # Этот блок относится к циклу FOR. Он срабатывает ТОЛЬКО если цикл FOR
    # завершился штатно (перебрал все элементы) или если список commands был ПУСТЫМ [].
    # То есть, если НЕ сработал внутренний экстренный 'break' (не было команды закрытия).       
    else:
        continue
    # Сюда код попадает только в одном случае: если цикл FOR был прерван через 'break' 
    # (сработал флаг should_stop).
    break


connection.close()
