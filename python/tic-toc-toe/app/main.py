import tkinter as tk
from tkinter import messagebox

import game

window = game.Gameplace(600, 800)
window.frame.createplace()
window.frame.menu()
menu = game.Menu()

window.update_status()
window.draw()


# Create parts of menu


if __name__ == "__main__":
    # ------------------GAME------------------------------------

    window.frame.show()
