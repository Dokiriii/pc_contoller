# commands_system.py

# Функция закрытия соединения
def close_connections(context):
    print("[System] Закрытие соединений...")

    context.client_socket.close()
    context.server_socket.close()

    return True