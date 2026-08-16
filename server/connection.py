# server/connection.py
import socket
from dataclasses import dataclass

# Создается класс для хранения соктов и другой информации о сервере и клиенте
@dataclass
class ConnectionContext:
    server_socket: socket.socket
    client_socket: socket.socket
    client_address: tuple

# Класс который хранит логику получения данных из сокета и её валидации
class Connection:
    def __init__(self, context: ConnectionContext):
        self.context = context
        self.buffer = ""

    def receive_commands(self):
        # Получаем данные из сокета
        data = self.context.client_socket.recv(1024)

        if not data:
            return None

        # Декодируем данные
        try:
            decoded_data = data.decode("utf-8")
        except UnicodeDecodeError:
            print("Ошибка: получены некорректные UTF-8 данные")
            return []

        # Добавляем данные в буфер. Он нужен для случаев, когда из TCP будут приходить
        # не полные или разорванные команды. Определяет программа целостность команды с помощью
        # символа "\n". Если его нет, программа не проходит в цикл while и возвращает пустой
        # спсиок модулю сервера, где он проходит цикл for без возврата данных и попадает в else,
        # где выполнение возвращается к началу цикла и снова ожидает прихода новой команды от
        # сокета клиента.
        self.buffer += decoded_data
        commands = []

        # Если в буффере есть символ "\n", то он разделает команды и возваращет их модулю сервера.
        while "\n" in self.buffer:
            command, self.buffer = self.buffer.split("\n", 1)

            if command:
                commands.append(command)

        return commands

    def close(self):
        self.context.client_socket.close()
        self.context.server_socket.close()