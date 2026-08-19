# server/server_context.py

import socket
import threading

from dataclasses import dataclass


# Класс хранит общее состояние сервера.
#
# В отличие от ConnectionContext,
# который относится к конкретному клиенту,
# ServerContext существует всё время работы сервера.
@dataclass
class ServerContext:

    # Основной TCP-сокет сервера.
    server_socket: socket.socket

    # Событие полного завершения сервера.
    #
    # Пока оно не установлено,
    # сервер продолжает работать.
    stop_event: threading.Event

    # UDP-соединение сервера.
    udp_connection: object

