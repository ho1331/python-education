import tkinter as tk
from tkinter import messagebox

from game import XO, Gameplace, Menu

window = Gameplace(600, 800)
window.createplace()
window.menu()
menu = Menu()


window.draw()


# Create parts of menu


if __name__ == "__main__":
    # ------------------GAME------------------------------------

    window.show()
