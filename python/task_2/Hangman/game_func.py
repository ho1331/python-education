""" Functions for main.py"""

import random
import re
import tkinter as tk


def update_screen(canvas, show_words, show_info):
    """Update screen"""
    for i in [show_words, show_info]:
        i.destroy()
        canvas.delete("all")


def status(imshow_letter, canvas, show_words, show_info, mistakes_else, messagebox):
    """Monitores the gameplay
    if imshow_letter not empty - game continue"""

    if mistakes_else[0] == 0:
        messagebox.showinfo("О нет :(", "Вы проиграли")
        update_screen(canvas, show_words, show_info)

    if "__ " in imshow_letter:
        return False
    else:
        messagebox.showinfo("Ура", "Вы выиграли")
        update_screen(canvas, show_words, show_info)

    return True


def draw(mistakes_else, canvas):
    """Draw picture if user took a mistake"""
    if mistakes_else[0] == 6:
        global hang
        hang = tk.PhotoImage(file="./images/0.png")
        canvas.create_image(400, 300, image=hang)

    elif mistakes_else[0] == 5:
        hang = tk.PhotoImage(file="./images/2.png")
        canvas.create_image(400, 300, image=hang)

    elif mistakes_else[0] == 4:
        hang = tk.PhotoImage(file="./images/3.png")
        canvas.create_image(400, 300, image=hang)

    elif mistakes_else[0] == 3:
        hang = tk.PhotoImage(file="./images/4.png")
        canvas.create_image(400, 300, image=hang)

    elif mistakes_else[0] == 2:
        hang = tk.PhotoImage(file="./images/5.png")
        canvas.create_image(400, 300, image=hang)

    elif mistakes_else[0] == 1:
        hang = tk.PhotoImage(file="./images/6.png")
        canvas.create_image(400, 300, image=hang)


def write_to_file(words, secret_word):
    """write used_word to file"""
    with open("used_words", "a") as used:
        used_word = words.pop(words.index(secret_word))
        used.write(f"{used_word}\n")


def is_word_infile(words, messagebox, window):
    """check the list of words"""
    try:
        secret_word = random.choice(words)
        return secret_word

    except Exception:
        messagebox.showinfo("Победа", "Все слова отгаданы")
        window.quit()


def show_words(messagebox):
    """Output info - list of used words"""
    with open("used_words", "r") as used:
        words_used = used.read()
        messagebox.showinfo("Прошлые слова", words_used)


def check_letter(
    letter,
    secret_word,
    imshow_letter,
    var_imshow_letter,
    used_letters,
    mistakes_else,
    canvas,
    messagebox,
):
    """Check input letter, if it incorrect - call drow func, else - replace letter to '_'"""
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
            mistakes_else[0] -= 1

            if letter not in used_letters:
                used_letters.append(letter)

            draw(mistakes_else, canvas)

    else:
        messagebox.showinfo("Упс..", "Ввод некорректный, повторите попытку")
