""" Hangman """
import tkinter as tk
from itertools import chain
from tkinter import messagebox

import game_func as gf

# create a settings of window wrapper
HEIGHT, WIDTH = 600, 800
window = tk.Tk()
window.title("Hangman")
window.geometry(f"{WIDTH}x{HEIGHT}")
canvas = tk.Canvas(window, width=WIDTH, height=HEIGHT)
canvas.pack()

words = [
    "азарт",
    "акула",
    "автор",
    "атака",
    "башня",
    "бетон",
    "весна",
    "виски",
    "гараж",
    "дятел",
    "диван",
    "жетон",
    "жираф",
    "зажим",
]
used_words = []


def start_game():
    """Main function"""
    window.update_idletasks()
    # environment variables
    var_imshow_letter = tk.StringVar()
    var_mistakes_else = tk.StringVar()

    show_words = tk.Label(window, textvariable=var_imshow_letter, font="Courier 30")
    show_words.place(x=20, y=20)

    show_info = tk.Label(
        window, textvariable=var_mistakes_else, font="Courier 16", fg="red"
    )
    show_info.place(x=10, y=HEIGHT - 100)

    secret_word = gf.is_word_infile(words, messagebox, window)

    imshow_letter = ["__ "] * (len(secret_word) - 2)
    imshow_letter = list(chain(secret_word[0], imshow_letter, secret_word[-1]))

    var_imshow_letter.set("".join(imshow_letter))

    used_letters = []
    mistakes_else = [7]

    var_mistakes_else.set(
        f"Осталось попыток {mistakes_else[0]}, Неверно: {' '.join(used_letters)}"
    )

    canvas.delete("all")

    def key_press(arg):
        """
        the function reads data from the keyboard,
        processes it, and outputs the result.
        Contains functions: check_letter(),status()
        """

        letter = arg.char.lower()
        print(secret_word)

        # Check input letter, processes the result of the check
        gf.check_letter(
            letter,
            secret_word,
            imshow_letter,
            var_imshow_letter,
            used_letters,
            mistakes_else,
            canvas,
            messagebox,
        )

        var_mistakes_else.set(
            f"Осталось попыток {mistakes_else[0]}, Неверно: {' '.join(used_letters)}"
        )

        # Monitores the gameplay
        gf.status(
            imshow_letter, canvas, show_words, show_info, mistakes_else, messagebox
        )

    # write used_word to file
    gf.write_to_file(words, secret_word)
    # binds keyboard events to key_press агтс
    window.bind("<KeyPress>", key_press)


# Create parts of menu
menu = tk.Menu(window)
window.config(menu=menu)
menu.add_command(label="Начать", command=lambda: start_game())
menu.add_command(
    label="Посмотреть прошлые слова", command=lambda: gf.show_words(messagebox)
)
menu.add_command(label="Выйти", command=lambda: window.quit())


if __name__ == "__main__":
    window.mainloop()
