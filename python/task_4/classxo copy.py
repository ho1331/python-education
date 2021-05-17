"""class of game XO"""
import logging
import os
import sys


class Menu:
    """class Menu"""

    def menu(self):
        """Show console menu"""
        print("-------------------------------Menu----------------------------------")
        menu = [
            "1.Играть",
            "2.Просмотреть лог побед",
            "3.Очистить лог побед",
            "4.Выход",
        ]

        for i in menu:
            print(f"{i}", end="  ")
        print()

    def readlog(self):
        """returne logfile"""
        try:
            with open("xolog.log", "r") as file:
                lines = file.readlines()
                for i in lines:
                    print(i)
        except:
            print("Not exist")

    def dellog(self):
        """delete logfile"""
        if os.path.exists("xolog.log"):
            os.remove("xolog.log")
        else:
            print("Not found")

    def exit(self):
        """exit game"""
        sys.exit()


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


class XO:
    """
    Class XO
    It's main class
    """

    def __init__(self) -> None:
        self.place = list(range(9))
        # create menu
        self.menu = Menu()

    def key_event(self):
        """check path of menu"""
        event = int(input("Select menu item: "))
        if event == 1:
            self.gamer = Gamer()
            self.game_processing()
        elif event == 2:
            self.menu.readlog()
        elif event == 3:
            self.menu.dellog()
        elif event == 4:
            self.menu.exit()

    def draw(self):
        """draw gameplace"""
        for i in range(3):
            print(self.place[0 + i * 3], self.place[1 + i * 3], self.place[2 + i * 3])

    def take_input(self, playertype):
        """check input of players"""
        while True:
            answer = int(input(f"Поставьтe {playertype}:"))
            if isinstance(answer, int):
                if answer in range(9):
                    if str(self.place[answer]) not in "XO":
                        self.place[answer] = playertype
                        break
                    else:
                        print("Занято")
                else:
                    print("Некорректный ввод. Введите число от 0 до 8")
            else:
                print("Введите цифру!")

    def check_win(self):
        """check is player win"""
        # win combinations
        combinates = (
            (0, 1, 2),
            (3, 4, 5),
            (6, 7, 8),
            (0, 3, 6),
            (1, 4, 7),
            (2, 5, 8),
            (0, 4, 8),
            (2, 4, 6),
        )
        # if tuple of combinations are same - player will win
        for i in combinates:
            if self.place[i[0]] == self.place[i[1]] == self.place[i[2]]:
                return self.place[i[0]]
        return False

    def newgame(self):
        """start game"""
        if self.place != list(range(9)):
            choise = input("Сыграть снова? (д/н)  ").lower()
            if choise in ["y", "д"]:
                self.place = list(range(9))
                self.game_processing()
            else:
                self.menu.exit()
        else:
            self.key_event()
            return True

    def game_processing(self):
        """
        processing of game
        1. show gameplace
        2. check whose typing (with take_input func)
        3. check is player win (with check_win func)
        4. write logfile of winners (with log_win func)
        """
        # number of moves
        counter = 0
        while True:
            self.draw()
            if counter % 2 == 0:
                print(f"{self.gamer.name1} ходит")
                self.take_input("X")  # X =playertype
            else:
                print(f"{self.gamer.name2} ходит")
                self.take_input("O")
            counter += 1

            if counter > 4:
                winner = self.check_win()
                if winner:
                    playerwin = {
                        winner == "X": self.gamer.name1,
                        winner == "O": self.gamer.name2,
                    }[True]
                    print(f"{playerwin} победил!!!!!")
                    self.gamer.log_win(playerwin)
                    self.draw()
                    break
            if counter == 9:
                print("Ничья!")
                self.draw()
                break


#########game##############
def main():
    """running all processing of module"""
    game = XO()
    game.menu.menu()
    while True:
        game.newgame()


if __name__ == "__main__":
    main()
