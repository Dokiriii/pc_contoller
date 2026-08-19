import os
import re
import signal
import socket
import subprocess
import sys
import threading
import tkinter as tk

from tkinter import ttk


# ================================================================
# НАСТРОЙКИ СЕРВЕРА
# ================================================================

TCP_PORT = 8080
UDP_PORT = 8081


# ================================================================
# SERVER GUI
# ================================================================

class ServerGUI:

    def __init__(self, root):

        self.root = root

        self.root.title(
            "PC Controller Server"
        )

        self.root.geometry(
            "850x650"
        )

        self.root.minsize(
            700,
            500
        )


        # --------------------------------------------------------
        # Процесс сервера.
        # --------------------------------------------------------

        self.server_process = None


        # --------------------------------------------------------
        # Список подключённых клиентов.
        #
        # Формат:
        #
        # {
        #     ("192.168.1.10", 52341),
        #     ...
        # }
        # --------------------------------------------------------

        self.connected_clients = set()


        # --------------------------------------------------------
        # Настраиваем закрытие окна.
        # --------------------------------------------------------

        self.root.protocol(
            "WM_DELETE_WINDOW",
            self._on_close
        )


        # --------------------------------------------------------
        # Создаём интерфейс.
        # --------------------------------------------------------

        self._build_ui()


        # --------------------------------------------------------
        # Показываем IP компьютера.
        # --------------------------------------------------------

        self._update_network_info()


        # --------------------------------------------------------
        # Начальное состояние.
        # --------------------------------------------------------

        self._set_server_status(
            "Остановлен"
        )


    # ============================================================
    # СОЗДАНИЕ UI
    # ============================================================

    def _build_ui(self):

        # ========================================================
        # ГЛАВНЫЙ КОНТЕЙНЕР
        # ========================================================

        main_frame = ttk.Frame(
            self.root,
            padding=12
        )

        main_frame.pack(
            fill="both",
            expand=True
        )


        # ========================================================
        # ЗАГОЛОВОК
        # ========================================================

        title_label = ttk.Label(

            main_frame,

            text="PC Controller Server",

            font=(
                "TkDefaultFont",
                18,
                "bold"
            )
        )

        title_label.pack(
            anchor="w",
            pady=(0, 12)
        )


        # ========================================================
        # ИНФОРМАЦИЯ О СЕРВЕРЕ
        # ========================================================

        info_frame = ttk.LabelFrame(

            main_frame,

            text="Сервер",

            padding=10
        )

        info_frame.pack(
            fill="x",
            pady=(0, 10)
        )


        # --------------------------------------------------------
        # СТАТУС
        # --------------------------------------------------------

        ttk.Label(
            info_frame,
            text="Статус:"
        ).grid(
            row=0,
            column=0,
            sticky="w",
            padx=(0, 10),
            pady=3
        )


        self.status_label = ttk.Label(

            info_frame,

            text="Остановлен",

            font=(
                "TkDefaultFont",
                10,
                "bold"
            )
        )

        self.status_label.grid(
            row=0,
            column=1,
            sticky="w",
            pady=3
        )


        # --------------------------------------------------------
        # IP
        # --------------------------------------------------------

        ttk.Label(
            info_frame,
            text="IP:"
        ).grid(
            row=1,
            column=0,
            sticky="w",
            padx=(0, 10),
            pady=3
        )


        self.ip_label = ttk.Label(
            info_frame,
            text="Определение..."
        )

        self.ip_label.grid(
            row=1,
            column=1,
            sticky="w",
            pady=3
        )


        # --------------------------------------------------------
        # TCP
        # --------------------------------------------------------

        ttk.Label(
            info_frame,
            text="TCP порт:"
        ).grid(
            row=2,
            column=0,
            sticky="w",
            padx=(0, 10),
            pady=3
        )


        ttk.Label(
            info_frame,
            text=str(TCP_PORT)
        ).grid(
            row=2,
            column=1,
            sticky="w",
            pady=3
        )


        # --------------------------------------------------------
        # UDP
        # --------------------------------------------------------

        ttk.Label(
            info_frame,
            text="UDP порт:"
        ).grid(
            row=3,
            column=0,
            sticky="w",
            padx=(0, 10),
            pady=3
        )


        ttk.Label(
            info_frame,
            text=str(UDP_PORT)
        ).grid(
            row=3,
            column=1,
            sticky="w",
            pady=3
        )


        # ========================================================
        # КНОПКИ
        # ========================================================

        buttons_frame = ttk.Frame(
            info_frame
        )

        buttons_frame.grid(
            row=0,
            column=2,
            rowspan=4,
            padx=(30, 0)
        )


        self.start_button = ttk.Button(

            buttons_frame,

            text="Запустить сервер",

            command=self.start_server
        )

        self.start_button.pack(
            side="left",
            padx=4
        )


        self.stop_button = ttk.Button(

            buttons_frame,

            text="Остановить сервер",

            command=self.stop_server,

            state="disabled"
        )

        self.stop_button.pack(
            side="left",
            padx=4
        )


        # ========================================================
        # ПОДКЛЮЧЕНИЯ
        # ========================================================

        clients_frame = ttk.LabelFrame(

            main_frame,

            text="Подключённые клиенты",

            padding=8
        )

        clients_frame.pack(
            fill="x",
            pady=(0, 10)
        )


        self.clients_list = tk.Listbox(

            clients_frame,

            height=5,

            borderwidth=0,

            highlightthickness=0
        )

        self.clients_list.pack(
            fill="x",
            expand=True
        )


        # ========================================================
        # КОНСОЛЬ
        # ========================================================

        console_frame = ttk.LabelFrame(

            main_frame,

            text="Консоль сервера",

            padding=8
        )

        console_frame.pack(
            fill="both",
            expand=True
        )


        console_container = ttk.Frame(
            console_frame
        )

        console_container.pack(
            fill="both",
            expand=True
        )


        self.console = tk.Text(

            console_container,

            wrap="word",

            state="disabled",

            bg="#111111",

            fg="#dddddd",

            insertbackground="white",

            borderwidth=0,

            padx=8,

            pady=8
        )

        self.console.pack(
            side="left",
            fill="both",
            expand=True
        )


        scrollbar = ttk.Scrollbar(

            console_container,

            orient="vertical",

            command=self.console.yview
        )

        scrollbar.pack(
            side="right",
            fill="y"
        )


        self.console.configure(
            yscrollcommand=scrollbar.set
        )


    # ============================================================
    # ОПРЕДЕЛЕНИЕ IP
    # ============================================================

    def _get_local_ip(self):

        try:

            # Создаём UDP-сокет.
            #
            # Соединяться реально ни с кем не нужно.
            # Это просто позволяет ОС выбрать
            # подходящий сетевой интерфейс.

            sock = socket.socket(
                socket.AF_INET,
                socket.SOCK_DGRAM
            )


            sock.connect(
                ("8.8.8.8", 80)
            )


            ip = sock.getsockname()[0]


            sock.close()


            return ip


        except OSError:

            return "Не удалось определить"


    # ============================================================
    # ОБНОВЛЕНИЕ IP
    # ============================================================

    def _update_network_info(self):

        ip = self._get_local_ip()

        self.ip_label.configure(
            text=ip
        )


    # ============================================================
    # СТАТУС
    # ============================================================

    def _set_server_status(
        self,
        status
    ):

        self.status_label.configure(
            text=status
        )


    # ============================================================
    # ДОБАВЛЕНИЕ ЛОГА
    # ============================================================

    def _append_log(
        self,
        message
    ):

        # Tkinter должен изменяться
        # только из главного потока.
        #
        # Поэтому если сообщение пришло
        # из потока чтения stdout,
        # возвращаем выполнение в GUI-поток.

        self.root.after(
            0,
            self._append_log_safe,
            message
        )


    def _append_log_safe(
        self,
        message
    ):

        self.console.configure(
            state="normal"
        )


        self.console.insert(
            "end",
            message + "\n"
        )


        self.console.see(
            "end"
        )


        self.console.configure(
            state="disabled"
        )


        # Обновляем список клиентов.

        self._process_server_message(
            message
        )


    # ============================================================
    # АНАЛИЗ СООБЩЕНИЯ СЕРВЕРА
    # ============================================================

    def _process_server_message(
        self,
        message
    ):

        # --------------------------------------------------------
        # Клиент подключился.
        #
        # Пример:
        #
        # Клиент подключился: ('192.168.1.20', 52341)
        # --------------------------------------------------------

        connect_match = re.search(

            r"Клиент подключился:\s*"
            r"\('([^']+)',\s*(\d+)\)",

            message
        )


        if connect_match:

            ip = connect_match.group(1)

            port = int(
                connect_match.group(2)
            )


            self.connected_clients.add(
                (ip, port)
            )


            self._refresh_clients()


        # --------------------------------------------------------
        # Клиент отключился.
        #
        # Пример:
        #
        # Клиент отключился: ('192.168.1.20', 52341)
        # --------------------------------------------------------

        disconnect_match = re.search(

            r"Клиент отключился:\s*"
            r"\('([^']+)',\s*(\d+)\)",

            message
        )


        if disconnect_match:

            ip = disconnect_match.group(1)

            port = int(
                disconnect_match.group(2)
            )


            self.connected_clients.discard(
                (ip, port)
            )


            self._refresh_clients()


    # ============================================================
    # ОБНОВЛЕНИЕ СПИСКА КЛИЕНТОВ
    # ============================================================

    def _refresh_clients(self):

        self.clients_list.delete(
            0,
            "end"
        )


        if not self.connected_clients:

            self.clients_list.insert(
                "end",
                "Нет подключённых клиентов"
            )

            return


        for ip, port in sorted(
            self.connected_clients
        ):

            self.clients_list.insert(

                "end",

                f"● {ip}:{port}"
            )


    # ============================================================
    # ЗАПУСК СЕРВЕРА
    # ============================================================

    def start_server(self):

        # Сервер уже работает.

        if (
            self.server_process is not None
            and self.server_process.poll() is None
        ):

            return


        self._clear_clients()


        self._append_log(
            "Запуск сервера..."
        )


        # --------------------------------------------------------
        # Запускаем main.py.
        #
        # Используем тот же Python,
        # которым запущен GUI.
        #
        # Поэтому будет использоваться
        # текущий .venv.
        # --------------------------------------------------------

        main_file = os.path.abspath(
            os.path.join(
                os.path.dirname(__file__),
                "..",
                "main.py"
            )
        )


        try:

            self.server_process = subprocess.Popen(

                [
                    sys.executable,
                    "-u",
                    main_file
                ],

                stdout=subprocess.PIPE,

                stderr=subprocess.STDOUT,

                text=True,

                encoding="utf-8",

                bufsize=1
            )


        except OSError as error:

            self._append_log(
                f"Ошибка запуска сервера: {error}"
            )

            self.server_process = None

            return


        self._set_server_status(
            "Запущен"
        )


        self.start_button.configure(
            state="disabled"
        )


        self.stop_button.configure(
            state="normal"
        )


        # --------------------------------------------------------
        # Поток чтения stdout.
        # --------------------------------------------------------

        threading.Thread(

            target=self._read_server_output,

            daemon=True

        ).start()


        # --------------------------------------------------------
        # Поток ожидания завершения.
        # --------------------------------------------------------

        threading.Thread(

            target=self._wait_server_process,

            daemon=True

        ).start()


    # ============================================================
    # ЧТЕНИЕ КОНСОЛИ СЕРВЕРА
    # ============================================================

    def _read_server_output(self):

        process = self.server_process


        if process is None:
            return


        if process.stdout is None:
            return


        try:

            for line in process.stdout:

                line = line.rstrip()

                if line:

                    self._append_log(
                        line
                    )


        except Exception as error:

            self._append_log(
                f"Ошибка чтения консоли: {error}"
            )


    # ============================================================
    # ОЖИДАНИЕ ЗАВЕРШЕНИЯ
    # ============================================================

    def _wait_server_process(self):

        process = self.server_process


        if process is None:
            return


        return_code = process.wait()


        self.root.after(
            0,
            self._server_finished,
            return_code
        )


    def _server_finished(
        self,
        return_code
    ):

        self._set_server_status(
            "Остановлен"
        )


        self.start_button.configure(
            state="normal"
        )


        self.stop_button.configure(
            state="disabled"
        )


        self._clear_clients()


        if return_code != 0:

            self._append_log(

                f"Сервер завершился "
                f"с кодом {return_code}"
            )


        else:

            self._append_log(
                "Сервер остановлен."
            )


        self.server_process = None


    # ============================================================
    # ОСТАНОВКА СЕРВЕРА
    # ============================================================

    def stop_server(self):

        process = self.server_process


        if process is None:
            return


        if process.poll() is not None:
            return


        self._append_log(
            "Остановка сервера..."
        )


        try:

            # ----------------------------------------------------
            # Linux:
            #
            # Отправляем SIGINT.
            #
            # Это аналог Ctrl+C.
            #
            # Благодаря этому существующий
            # KeyboardInterrupt в server.py
            # сможет корректно закрыть TCP/UDP.
            # ----------------------------------------------------

            process.send_signal(
                signal.SIGINT
            )


        except OSError as error:

            self._append_log(
                f"Ошибка остановки: {error}"
            )


    # ============================================================
    # ОЧИСТКА КЛИЕНТОВ
    # ============================================================

    def _clear_clients(self):

        self.connected_clients.clear()

        self._refresh_clients()


    # ============================================================
    # ЗАКРЫТИЕ GUI
    # ============================================================

    def _on_close(self):

        process = self.server_process


        if (
            process is not None
            and process.poll() is None
        ):

            try:

                process.send_signal(
                    signal.SIGINT
                )


            except OSError:
                pass


        self.root.destroy()


# ================================================================
# ТОЧКА ВХОДА GUI
# ================================================================

def main():

    root = tk.Tk()

    ServerGUI(
        root
    )

    root.mainloop()


if __name__ == "__main__":

    main()