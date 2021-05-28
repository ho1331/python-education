import random
import re
import tkinter as tk
from itertools import chain
from tkinter import messagebox


class Hangman:
    """class Hangman"""

    def __init__(self, window, height, words):
        self.words = words
        self.var_imshow_letter = tk.StringVar()
        self.var_mistakes_else = tk.StringVar()

        self.show_words = tk.Label(
            window, textvariable=self.var_imshow_letter, font="Courier 30"
        )
        self.show_words.place(x=20, y=20)

        self.show_info = tk.Label(
            window, textvariable=self.var_mistakes_else, font="Courier 16", fg="red"
        )
        self.show_info.place(x=10, y=height - 100)
        self.used_letters = []
        self.mistakes_else = 7

        # в файле поставить проверку
        self.secret_word = random.choice(self.words)

        self.imshow_letter = ["__ "] * (len(self.secret_word) - 2)
        self.imshow_letter = list(
            chain(self.secret_word[0], self.imshow_letter, self.secret_word[-1])
        )
        self.var_imshow_letter.set("".join(self.imshow_letter))

        self.var_mistakes_else.set(
            f"Осталось попыток {self.mistakes_else}, Неверно: {''.join(self.used_letters)}"
        )

    def update_screen(self, canvas):
        """Update screen"""
        for i in [self.show_words, self.show_info]:
            i.destroy()
            canvas.delete("all")

    def status(self, canvas):
        """Monitores the gameplay
        if imshow_letter not empty - game continue"""

        if self.mistakes_else == 0:
            messagebox.showinfo("О нет :(", "Вы проиграли")
            self.update_screen(canvas)

        if "__ " in self.imshow_letter:
            return False
        else:
            messagebox.showinfo("Ура", "Вы выиграли")
            self.update_screen(canvas)

        return True

    def draw(self, canvas):
        """Draw picture if user took a mistake"""
        if self.mistakes_else == 6:
            global hang
            hang = tk.PhotoImage(file="./images/0.png")
            canvas.create_image(400, 300, image=hang)

        elif self.mistakes_else == 5:
            hang = tk.PhotoImage(file="./images/2.png")
            canvas.create_image(400, 300, image=hang)

        elif self.mistakes_else == 4:
            hang = tk.PhotoImage(file="./images/3.png")
            canvas.create_image(400, 300, image=hang)

        elif self.mistakes_else == 3:
            hang = tk.PhotoImage(file="./images/4.png")
            canvas.create_image(400, 300, image=hang)

        elif self.mistakes_else == 2:
            hang = tk.PhotoImage(file="./images/5.png")
            canvas.create_image(400, 300, image=hang)

        elif self.mistakes_else == 1:
            hang = tk.PhotoImage(file="./images/6.png")
            canvas.create_image(400, 300, image=hang)

    def write_to_file(self):
        """write used_word to file"""
        with open("used_words", "a") as uw:
            used_word = self.words.pop(self.words.index(self.secret_word))
            uw.write(f"{used_word}\n")

    def check_letter(self, letter, canvas):
        """Check input letter, if it incorrect - call drow func, else - replace letter to '_'"""
        if (
            len(letter) == 1
            and letter.isalpha()
            and bool(re.search("[\u0400-\u04FF]", letter))
        ):
            if letter in self.secret_word:
                for pos, char in enumerate(self.secret_word):
                    if char == letter:
                        self.imshow_letter[pos] = letter

                self.var_imshow_letter.set("".join(self.imshow_letter))
            else:
                self.mistakes_else -= 1

                if letter not in self.used_letters:
                    self.used_letters.append(letter)

                self.var_mistakes_else.set(
                    f"Осталось попыток {self.mistakes_else}, Неверно: {' '.join(self.used_letters)}"
                )
                self.draw(canvas)

        else:
            messagebox.showinfo("Упс..", "Ввод некорректный, повторите попытку")


def shows_words():
    """Output info - list of used words"""
    try:
        with open("used_words", "r") as uw:
            words_used = uw.read()
            messagebox.showinfo("Прошлые слова", words_used)
    except Exception:
        messagebox.showinfo("Прошлые слова", "Пока пусто")


def update(window, canvas):
    for widgets in window.winfo_children():
        if isinstance(widgets, tk.Label):
            widgets.destroy()
    canvas.delete("all")
