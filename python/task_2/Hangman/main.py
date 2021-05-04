import random
import re
import tkinter as tk
from itertools import chain
from tkinter import messagebox

import game_func as gf

# создаем оболочку окна

HEIGHT, WIDTH = 600, 800
window = tk.Tk()
window.title("Hangman")
window.geometry(f"{WIDTH}x{HEIGHT}")
canvas = tk.Canvas(window, width=600, height=800)
canvas.pack()

words = ["помидор", "сноуборд", "пианино", "афиша", "автобус", "пустыня"]
used_words = []


def start_game():
    var_imshow_letter = tk.StringVar()
    var_mistakes_else = tk.StringVar()

    show_words = tk.Label(window, textvariable=var_imshow_letter)
    show_words.config(font=("Courier", 28))
    show_words.place(x=10, y=10)

    show_info = tk.Label(window, textvariable=var_mistakes_else)
    show_info.config(font=("Courier", 14))
    show_info.place(x=10, y=HEIGHT - 100)

    secret_word = gf.is_word_infile(words, messagebox, window)

    imshow_letter = ["__ "] * (len(secret_word) - 2)
    imshow_letter = list(chain(secret_word[0], imshow_letter, secret_word[-1]))

    var_imshow_letter.set("".join(imshow_letter))
    used_letters = []
    mistakes_else = 7

    def key_press(arg):

        letter = arg.char.lower()
        print(secret_word)

        # gf.check_letter(letter,secret_word,imshow_letter,var_imshow_letter,used_letters,mistakes_else,canvas)
        if (
            len(letter) == 1
            and letter.isalpha()
            and bool(re.search("[\u0400-\u04FF]", letter))
        ):
            if letter in secret_word:
                for pos, char in enumerate(secret_word):
                    if char == letter:
                        imshow_letter[pos] = letter

                var_imshow_letter.set("".join(imshow_letter))
            else:
                nonlocal mistakes_else
                mistakes_else -= 1

                if letter not in used_letters:
                    used_letters.append(letter)

                gf.draw(mistakes_else, canvas)

        else:
            print("Ввод некорректный, повторите попытку")

        gf.status(
            imshow_letter, canvas, show_words, show_info, mistakes_else, messagebox
        )

        var_mistakes_else.set(
            f"Осталось попыток {mistakes_else}, Неверно: {' '.join(used_letters)}"
        )

    gf.write_to_file(words, secret_word)
    window.bind("<KeyPress>", key_press)


# Create parts of menu
menu = tk.Menu(window)
window.config(menu=menu)
menu.add_command(label="Начать", command=lambda: start_game())
menu.add_command(label="Посмотреть прошлые слова")
menu.add_command(label="Выйти", command=lambda: window.quit())

window.mainloop()
