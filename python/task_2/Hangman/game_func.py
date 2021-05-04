import random
import re
import tkinter as tk


def update_screen(canvas, show_words, show_info):
    for i in [show_words, show_info]:
        i.destroy()
        canvas.delete("all")


def status(imshow_letter, canvas, show_words, show_info, mistakes_else, messagebox):
    if mistakes_else == 0:
        messagebox.showinfo("О нет :(", "Вы проиграли")
        update_screen(canvas, show_words, show_info)

    if "__ " in imshow_letter:
        return False
    else:
        messagebox.showinfo("Ура", "Вы выиграли")
        update_screen(canvas, show_words, show_info)

    return True


def draw(mistakes_else, canvas):
    if mistakes_else == 6:
        global hang
        hang = tk.PhotoImage(file="./images/0.png")
        canvas.create_image(400, 300, image=hang)

    elif mistakes_else == 5:
        hang = tk.PhotoImage(file="./images/2.png")
        canvas.create_image(400, 300, image=hang)

    elif mistakes_else == 4:
        hang = tk.PhotoImage(file="./images/3.png")
        canvas.create_image(400, 300, image=hang)

    elif mistakes_else == 3:
        hang = tk.PhotoImage(file="./images/4.png")
        canvas.create_image(400, 300, image=hang)

    elif mistakes_else == 2:
        hang = tk.PhotoImage(file="./images/5.png")
        canvas.create_image(400, 300, image=hang)

    elif mistakes_else == 1:
        hang = tk.PhotoImage(file="./images/6.png")
        canvas.create_image(400, 300, image=hang)


def write_to_file(words, secret_word):
    with open("used_words", "a") as uw:
        used_word = words.pop(words.index(secret_word))
        uw.write(f"{used_word}\n")


def is_word_infile(words, messagebox, window):
    try:
        secret_word = random.choice(words)
        return secret_word

    except Exception:
        messagebox.showinfo("Победа", "Все слова отгаданы")
        window.quit()


def show_words(messagebox):
    with open("used_words", "r") as uw:
        words_used = uw.read()
        messagebox.showinfo("Прошлые слова", words_used)


# def check_letter(letter,secret_word,imshow_letter,var_imshow_letter,used_letters,mistakes_else,canvas):
#     if (len(letter) == 1 and letter.isalpha()
#             and bool(re.search("[\u0400-\u04FF]", letter))
#         ):
#         if letter in secret_word:
#             for pos, char in enumerate(secret_word):
#                 if char == letter:
#                     imshow_letter[pos] = letter

#             var_imshow_letter.set("".join(imshow_letter))
#         else:
#             mistakes_else -= 1

#             if letter not in used_letters:
#                 used_letters.append(letter)

#             draw(mistakes_else, canvas)

#     else:
#         print("Ввод некорректный, повторите попытку")
