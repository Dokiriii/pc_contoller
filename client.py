# client.py
import socket

client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
client.connect(('127.0.0.1', 8080))

client.send("Hello\nWorld\nTest\n".encode("utf-8"))

while True:
    message = input("Введите сообщение для сервера (или 'exit' для выхода): ")
    message += "\n"
    
    client.send(message.encode('utf-8'))

    if message.lower() == "exit\n":
        break

client.close()
