# server/tcp_connection.py

import socket
import json

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


        # Если метод вернул None,
        # значит клиент физически разорвал соединение.
        if not data:

            return None


        # Декодируем данные
        try:

            decoded_data = data.decode("utf-8")

        except UnicodeDecodeError as error:

            print(f"Ошибка UTF-8: {error}")

            self.buffer = ""

            return []


        # Добавляем данные в буфер.
        #
        # Он нужен для случаев, когда из recv()
        # будут приходить не полные или разорванные команды.
        #
        # Определяет программа целостность команды
        # с помощью символа "\n".
        self.buffer += decoded_data


        commands = []


        # Если в буффере есть символ "\n",
        # то он разделает команды и возваращет их серверу.
        while "\n" in self.buffer:

            command, self.buffer = self.buffer.split(
                "\n",
                1
            )


            if command:

                commands.append(command)


        return commands


    def send_response(self, response):

        message = json.dumps(
            response,
            ensure_ascii=False
        ) + "\n"


        self.context.client_socket.sendall(
            message.encode("utf-8")
        )


    def close(self):

        # Закрываем только TCP-соединение
        # с текущим клиентом.
        #
        # Серверный сокет НЕ закрываем.
        #
        # Это позволяет серверу после отключения
        # одного клиента ожидать подключения следующего.

        self.context.client_socket.close()

