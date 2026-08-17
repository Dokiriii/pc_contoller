# client.py
import socket
import json

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect(('127.0.0.1', 8080))

buffer = ""

# Функция получения ответа с сервера
def receive_responses():
    global buffer

    data = client.recv(1024)

    if not data:
        return None

    buffer += data.decode("utf-8")

    responses = []

    while "\n" in buffer:
        response, buffer = buffer.split("\n", 1)

        if response:
            responses.append(response)

    return responses


# ТЕСТ
import time
# 1. Формируем ПРАВИЛЬНУЮ цельную JSON-строку с разделителем \n в конце
raw_string = '{"type":"KEY","action":"press","data":"A"}\n'
# 2. Искусственно режем её на две части как обычный текст
part1 = raw_string[:23]  # Получится: '{"type":"KEY","action" '
part2 = raw_string[23:]  # Получится: ':"press","data":"A"}\n'
# 3. Отправляем первую часть (БЕЗ json.loads)
print(f"[Тест] Отправляем неполную часть: {part1}")
client.send(part1.encode('utf-8'))
# Задержка, чтобы сервер успел вызвать первый recv() и положить кусок в буфер
time.sleep(0.5)
# 4. Отправляем вторую часть, которая закроет строку символом \n
print(f"[Тест] Отправляем остаток строки: {part2}")
client.send(part2.encode('utf-8'))


# ТЕСТОВЫЕ ДАННЫЕ
# {"type":"KEY","action":"press","data":"A"}
# {"type":"MOUSE","action":"click","button":"left"}
# {"type":"TEXT","action":"write","data":"Привет: как дела?"}
# {"type":"KEY"

# КОМАНДА ВЫХОДА
# {"type": "SYSTEM_COMMAND", "action": "shutdown"}

while True:
    user_input = input("Введите сообщение для сервера: ")

    if user_input == "exit":
        exit_command = {
            "type": "SYSTEM_COMMAND",
            "action": "shutdown"
        }

        message = json.dumps(exit_command) + "\n"
        client.sendall(message.encode("utf-8"))

        print("[Client] Отправлена команда закрытия. Выходим...")
        break

    try:
        command_dict = json.loads(user_input)

    except json.JSONDecodeError:
        print("Ошибка: Вы ввели некорректный JSON!")
        continue

    message = json.dumps(
        command_dict,
        ensure_ascii=False
    ) + "\n"

    client.sendall(message.encode("utf-8"))

    responses = receive_responses()

    if responses is None:
        print("[Client] Сервер отключился")
        break

    for raw_response in responses:
        try:
            response = json.loads(raw_response)

        except json.JSONDecodeError:
            print(f"[Client] Получен некорректный ответ: {raw_response}")
            continue

        print(f"\n[Client] Ответ сервера: {response}")
