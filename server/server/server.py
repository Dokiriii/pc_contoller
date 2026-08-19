# server/server.py

import socket
import threading


from server.tcp_connection import (
    Connection,
    ConnectionContext
)

from server.udp_connection import (
    UdpConnection
)

from server.udp_worker import (
    udp_worker
)

from server.tcp_worker import (
    tcp_worker
)

from server.server_context import (
    ServerContext
)


# ============================================================
# НАСТРОЙКИ СЕРВЕРА
# ============================================================

TCP_HOST = "0.0.0.0"
TCP_PORT = 8080

UDP_HOST = "0.0.0.0"
UDP_PORT = 8081


# ============================================================
# ЗАПУСК СЕРВЕРА
# ============================================================

def start_server():

    # Создаём TCP-сокет.
    tcpserver = socket.socket(
        socket.AF_INET,
        socket.SOCK_STREAM
    )


    # Устанавливаем адрес и порт для сервера.
    #
    # 0.0.0.0 означает, что сервер принимает подключения
    # через все сетевые интерфейсы компьютера.
    server_address = (
        TCP_HOST,
        TCP_PORT
    )


    tcpserver.bind(
        server_address
    )


    tcpserver.listen(1024)


    print(
        "Сервер запущен. "
        "Ожидание подключения..."
    )


    # ==========================================================
    # UDP
    # ==========================================================

    # Создаём UDP-соединение.
    #
    # UDP используется для передачи движения мыши.
    # Для него используется отдельный порт.
    udp_connection = UdpConnection(
        host=UDP_HOST,
        port=UDP_PORT
    )


    udp_connection.start()


    # ==========================================================
    # СОСТОЯНИЕ СЕРВЕРА
    # ==========================================================

    # Событие используется для полного
    # завершения работы сервера.
    stop_event = threading.Event()


    server_context = ServerContext(
        server_socket=tcpserver,
        stop_event=stop_event,
        udp_connection=udp_connection
    )


    # ==========================================================
    # UDP WORKER
    # ==========================================================

    # UDP работает независимо от TCP-клиента.
    #
    # Поэтому запускаем его только один раз
    # при запуске сервера.
    udp_thread = threading.Thread(
        target=udp_worker,
        args=(
            udp_connection,
            server_context,
            stop_event
        ),
        daemon=True
    )


    udp_thread.start()


    # ==========================================================
    # TCP
    # ==========================================================

    try:

        # Сервер продолжает ждать клиентов,
        # пока не будет установлено stop_event.
        while not stop_event.is_set():

            # Ожидаем подключения клиента.
            client_socket, client_address = (
                tcpserver.accept()
            )


            print(
                f"Клиент подключился: "
                f"{client_address}"
            )


            # --------------------------------------------------
            # Контекст конкретного клиента.
            # --------------------------------------------------

            connection_context = ConnectionContext(
                server_socket=tcpserver,
                client_socket=client_socket,
                client_address=client_address
            )


            connection = Connection(
                connection_context
            )


            # --------------------------------------------------
            # Обрабатываем TCP-соединение.
            # --------------------------------------------------
            #
            # False → клиент просто отключился.
            #
            # True → была получена команда shutdown.
            should_stop = tcp_worker(
                connection,
                connection_context
            )


            # --------------------------------------------------
            # Закрываем соединение с текущим клиентом.
            # --------------------------------------------------

            connection.close()


            # --------------------------------------------------
            # Проверяем причину завершения TCP worker.
            # --------------------------------------------------

            if should_stop:

                print(
                    "Получена команда "
                    "завершения сервера."
                )


                stop_event.set()

                break


            # --------------------------------------------------
            # Клиент просто отключился.
            #
            # Сервер НЕ завершается.
            #
            # Возвращаемся к accept()
            # и ждём следующего клиента.
            # --------------------------------------------------

            print(
                "Ожидание нового подключения..."
            )


    except KeyboardInterrupt:

        print(
            "\nСервер остановлен "
            "с клавиатуры."
        )


    finally:

        # ======================================================
        # ПОЛНОЕ ЗАВЕРШЕНИЕ СЕРВЕРА
        # ======================================================

        stop_event.set()


        # Закрываем UDP-сокет.
        udp_connection.close()


        # Закрываем TCP-сервер.
        tcpserver.close()


        print(
            "Сервер полностью остановлен."
        )

