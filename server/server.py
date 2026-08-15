# server.py
# Импортируем модуль socket для работы с сокетами
import socket

# Создаем TCP-серверный сокет
tcpserver = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

# Устанавливаем адрес и порт для сервера
server_address = ('127.0.0.1', 8080)
tcpserver.bind(server_address)

# Начинаем прослушивание входящих соединений
tcpserver.listen(1024)
# Принимаем входящее соединение от клиента
client_socket, client_address = tcpserver.accept()
# Инициализируем буфер для хранения данных
buffer = ""

#========= Функция для определения типа команды и данных команды ==============
def types_finder(data):
    type_of_command, command_data = data.split(":", 1)
    return type_of_command, command_data

#==========================================================================================
#===================Основной цикл обработки данных от клиента==============================
#==========================================================================================
while True:
    # Получаем данные от клиента
    data = client_socket.recv(1024)

    if not data:
        break
    # Декодируем данные из байтов в строку UTF-8 и добавляем их в буфер
    utf_8_data = data.decode('utf-8')
    buffer += utf_8_data

    # Ищем символ новой строки в буфере
    startdec = buffer.find("\n")

    # Если символ новой строки найден, обрабатываем данные до него
    while startdec != -1:
        pr_data = buffer[:startdec]
        buffer = buffer[startdec + 1:]
        
        # Определяем тип команды и данные команды с помощью функции types_finder
        type_of_command, command_data = types_finder(pr_data)
        # Выводим информацию о полученных данных
        print(f"Пришло от {client_address} \n Тип команды: {type_of_command} \n Данные команды: {command_data}")
        # Если полученные данные равны "exit", закрываем соединение и сервер
        if pr_data.lower() == "exit":
            client_socket.close()
            tcpserver.close()
            break
        # Ищем следующий символ новой строки в буфере
        startdec = buffer.find("\n")
