""" Hangman """
import tkinter as tk
from tkinter import messagebox

from hangman import Hangman, shows_words, update

# create a settings of window wrapper
HEIGHT, WIDTH = 600, 800
window = tk.Tk()
window.title("Hangman")
window.geometry(f"{WIDTH}x{HEIGHT}")

canvas = tk.Canvas(window, width=WIDTH, height=HEIGHT)
canvas.pack()

words = [
    "ананас",
    "акула",
    "автор",
    "оса",
    "мемориал",
    "башня",
    "бетон",
    "баскетбол",
    "веревка",
    "виски",
    "дерево",
    "гараж",
    "демократия",
    "пирамида",
    "диван",
    "жетон",
    "жираф",
    "зажим",
    "колонизация",
]


def start_game():
    """Main function"""

    try:
        hangman = Hangman(window, HEIGHT, words)
    except Exception:
        messagebox.showinfo("Победа", "Все слова отгаданы")
        window.quit()

    def key_press(arg):
        """
        the function reads data from the keyboard,
        processes it, and outputs the result.
        Contains functions: check_letter(),status()
        """

        letter = arg.char.lower()
        print(hangman.secret_word)

        # Check input letter, processes the result of the check
        hangman.check_letter(letter, canvas)

        # Monitores the gameplay
        hangman.status(canvas)

    # write used_word to file
    hangman.write_to_file()
    # binds keyboard events to key_press агтс
    window.bind("<KeyPress>", key_press)


# Create parts of menu
menu = tk.Menu(window)
window.config(menu=menu)
menu.add_command(label="Начать", command=lambda: [update(window, canvas), start_game()])
menu.add_command(label="Посмотреть прошлые слова", command=lambda: shows_words())
menu.add_command(label="Выйти", command=lambda: window.quit())


if __name__ == "__main__":
    window.mainloop()
