import socket


# Класс отвечает исключительно за UDP-соединение.
#
# В отличие от TCP здесь нет accept() и постоянного
# соединения с конкретным клиентом.
# Сервер просто получает отдельные UDP-пакеты.
class UdpConnection:

    def __init__(self, host="0.0.0.0", port=8081):
        self.host = host
        self.port = port

        # Создаём UDP-сокет.
        self.socket = socket.socket(
            socket.AF_INET,
            socket.SOCK_DGRAM
        )


    # Запускает UDP-сервер.
    def start(self):

        self.socket.bind(
            (self.host, self.port)
        )

        print(
            f"[UDP] Сервер запущен "
            f"на {self.host}:{self.port}"
        )


    # Ожидает следующий UDP-пакет.
    def receive(self):

        data, client_address = (
            self.socket.recvfrom(65535)
        )

        return (
            data.decode("utf-8"),
            client_address
        )


    # Закрывает UDP-сокет.
    def close(self):

        self.socket.close()

        print("[UDP] Сервер остановлен")