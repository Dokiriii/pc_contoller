# client.py
import socket
import json

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect(('127.0.0.1', 8080))


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
# {"type": "SYSTEM_COMMAND", "action": "close_conn"}

while True:
    user_input = input("Введите сообщение для сервера (или 'exit' для выхода): ")

    try:
        # Сначала превращаем введенную строку в реальный Python-словарь
        command_dict = json.loads(user_input)
        
        # Теперь упаковываем этот словарь в чистый JSON-формат для отправки
        message = json.dumps(command_dict, ensure_ascii=False) + "\n"
        client.send(message.encode('utf-8'))

        if command_dict.get("action") == "close_conn":
            print("[Client] Отправлена команда закрытия. Выходим...")
            break
        
    except json.JSONDecodeError:
        print("Ошибка: Вы ввели некорректный JSON! Попробуйте еще раз.")
