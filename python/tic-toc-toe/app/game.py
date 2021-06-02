import logging
import os
import random
import re
import sys
import tkinter as tk
from itertools import chain
from tkinter import messagebox


class Gameplace:
    def __init__(self, height, width) -> None:
        self.height = height
        self.width = width
        self.window = tk.Tk()
        self.place = []

    def createplace(self):
        self.window.title("Tic toc toe")
        self.window.geometry(f"{self.width}x{self.height}")

    def menu(self):

        menu = tk.Menu(self.window)
        submenu = tk.Menu(menu)
        submenu.add_command(label="На двоих")
        submenu.add_command(label="Против AI")
        menu.add_cascade(label="Начать", menu=submenu)

        self.window.config(menu=menu)
        menu.add_command(
            label="Просмотреть лог побед", command=lambda: Menu.readlog(self)
        )
        menu.add_command(label="Очистить лог побед", command=lambda: Menu.dellog(self))
        menu.add_command(label="Выход", command=lambda: Menu.exit(self))

    def draw(self):
        for row in range(3):
            line = []
            for col in range(3):
                button = tk.Button(
                    self.window,
                    text=" ",
                    width=4,
                    height=2,
                    font=("Verdana", 30, "bold"),
                    background="lavender",
                    command=lambda row=row, col=col: self.event(row, col),
                )
                button.grid(row=row, column=col, sticky="nsew")
                line.append(button)
            self.place.append(line)

    def event(self, row, col):
        if self.place[row][col]["text"] == " ":
            self.place[row][col]["text"] = "X"

    def show(self):
        self.window.mainloop()


class Menu:
    """class Menu"""

    def readlog(self):
        """returne logfile"""
        try:
            with open("xolog.log", "r") as file:
                logs = file.read()
                messagebox.showinfo("История", logs)
        except FileNotFoundError:
            messagebox.showinfo("История", "Пока пусто")

    def dellog(self):
        """delete logfile"""
        if os.path.exists("xolog.log"):
            os.remove("xolog.log")
            messagebox.showinfo("Info", "Файл 'xolog.log' удален")
        else:
            messagebox.showinfo("Info", "Файл 'xolog.log' не найден или не существует ")

    def exit(self):
        """exit game"""
        sys.exit()


class XO:
    def __init__(self) -> None:
        self.place = None
        self.AI = "X"
        self.PLAYER = "O"
        self.oponent = None

    def oponent_ai(self):
        """initiated oponent == ai"""
        move = self.ai_moving(self.place)
        self.place[move] = self.AI

    def oponent_human(self):
        """initiated oponent == humen"""
        self.take_input("X")


# ------------------------------------------------------------------
class Gamer:
    """class Gamer"""

    def __init__(self) -> None:
        self.name1 = input("Введите имя 1-го игрока: ")
        self.name2 = input("Введите имя 2-го игрока: ")

    def log_win(self, name):
        """write logfile of winners"""
        logging.basicConfig(
            format="%(asctime)s - %(message)s", level=logging.INFO, filename="xolog.log"
        )
        logger = logging.getLogger()
        logger.info(f"{name} победил!")


# ------------------GAME------------------------------------
def main():
    """running all processing of module"""
    game = XO()
    while True:
        game.newgame()


if __name__ == "__main__":
    main()
