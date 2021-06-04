"""Game Tic Toc Toe"""
import tkinter as tk

import logicgame


class Game:
    """
    class Game

    methods:
        menu,draw,update_status,event,ai_turn,write_log,play_with_ai,play_with_human
    """

    def __init__(self, height, width) -> None:
        self.place = []
        self.counter = 0
        self.log = logicgame.Loging()
        self.process = logicgame.Gameprocesse()
        self.frame = logicgame.Window(height, width)
        self.withAI = False
        self.start = False
        self.name1 = "Игрок_1"
        self.name2 = "Игрок_2"

    def menu(self):
        """create windows menu"""

        menu = tk.Menu(self.frame.window)
        submenu = tk.Menu(menu)
        submenu.add_command(label="На двоих", command=lambda: self.play_with_human())
        submenu.add_command(label="Против AI", command=lambda: self.play_with_ai())
        menu.add_cascade(label="Начать", menu=submenu)

        self.frame.window.config(menu=menu)
        menu.add_command(
            label="Просмотреть лог побед", command=lambda: logicgame.Menu.readlog()
        )
        menu.add_command(
            label="Очистить лог побед", command=lambda: logicgame.Menu.dellog()
        )
        menu.add_command(label="Выход", command=lambda: logicgame.Menu.exit())

    def draw(self):
        """create gameplace"""
        for row in range(3):
            line = []
            for col in range(3):
                button = tk.Button(
                    self.frame.window,
                    text=" ",
                    width=4,
                    height=2,
                    bd=5,
                    font=("Verdana", 30, "bold"),
                    background="lavender",
                    activebackground="yellow",
                    command=lambda row=row, col=col: self.event(self.place, row, col),
                )
                button.grid(row=row, column=col, sticky="nsew")
                line.append(button)
            self.place.append(line)

    def update_status(self):
        """choose next stepplayer"""
        if self.counter % 2 == 0:
            self.frame.text_place.set(f"Ходит {self.name1}")
        else:
            self.frame.text_place.set(f"Ходит {self.name2}")

    def event(self, place, row, col):
        """check processe on gameplace"""
        if self.start is True:
            if self.withAI is False:
                if self.process.show_winner(place, self.counter, self.start):
                    return
                if self.counter % 2 == 0:
                    if place[row][col]["text"] == " ":
                        place[row][col]["text"] = "X"
                    self.counter += 1
                    if self.process.show_winner(place, self.counter, self.start):
                        self.write_log()
                    self.update_status()
                else:
                    if self.counter % 2 != 0:
                        if place[row][col]["text"] == " ":
                            place[row][col]["text"] = "O"
                        self.counter += 1
                        if self.process.show_winner(place, self.counter, self.start):
                            self.write_log()
                        self.update_status()

            else:
                if self.process.show_winner(place, self.counter, self.start):
                    return
                if self.counter % 2 != 0:
                    if place[row][col]["text"] == " ":
                        place[row][col]["text"] = "O"
                    self.counter += 1
                    if self.process.show_winner(place, self.counter, self.start):
                        self.write_log()
                    self.update_status()
                    self.frame.window.update()
                    if self.withAI is True:
                        self.ai_turn()
                        self.update_status()

    def ai_turn(self):
        """return ai move"""
        move = self.process.ai_moving(self.place)
        for i, value in enumerate(self.place):
            for j, val in enumerate(value):
                if val == move:
                    self.place[i][j]["text"] = "X"
        self.counter += 1
        if self.process.show_winner(self.place, self.counter, self.start):
            self.write_log()
        self.update_status()

    def write_log(self):
        """write log with winner name"""
        winner = self.process.check_win(self.place)
        if winner == "X":
            return self.log.log_win(self.name1)
        else:
            return self.log.log_win(self.name2)

    def play_with_ai(self):
        """cgoose game with ai"""
        self.start = True
        self.withAI = True
        self.process.new_game(self.place)
        self.counter = 0
        self.update_status()
        self.frame.window.update()
        self.ai_turn()

    def play_with_human(self):
        """cgoose game for two players"""
        self.start = True
        self.withAI = False
        self.process.new_game(self.place)
        self.counter = 0
        self.update_status()


if __name__ == "__main__":
    # ------------------GAME------------------------------------
    window = Game(440, 460)
    window.frame.createplace()
    window.menu()

    window.draw()

    window.frame.show()
