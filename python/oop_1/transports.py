"""
Задание: https://classroom.google.com/c/Mjk0OTc3NDgyMzU1/a/MzM1MzAyOTU5NTg2/details
- попрактиковаться в создании классов с нуля и наследовании от других классов
- создать класс Transport, подумать об атрибутах и методах, дополнить класс ими
- подумать и реализовать класс наследники класса Transport(минимум 4),
- переопределить методы и атрибуты для каждого класса
"""
import datetime


class Transport:
    """class Transport"""

    def __init__(self, model: str, year: int, segment: str) -> None:
        self.model = model
        self.year = year
        self.segment = segment
        self.average_distans_peryear = 6356
        self.today = datetime.datetime.today().year

    def run(self):
        print("Машина завелась")

    def mileage(self):
        print(
            f"Ваш {self.model} проехал около \
                {self.average_distans_peryear * (self.today - self.year)} км"
        )


class Mersedes(Transport):
    """class Mersedes"""

    def __init__(self, model, year, segment, doors: int) -> None:
        super().__init__(model, year, segment)
        self.doors = doors


class Volkswagen(Transport):
    """class Volkswagen"""

    def run(self):
        super().run()
        print("Теперь можно ехать")


class Audi(Volkswagen):
    """class Audi"""

    def __init__(self, model, year, segment, transmition: str) -> None:
        super().__init__(model, year, segment)
        self.transmition = transmition

    def mileage(self):
        print(
            f"Ваш {self.model} проехал около \
                {self.average_distans_peryear * (self.today - self.year)} км. \n \
                Cегмент: {self.segment}, коробка {self.transmition}"
        )


class Seat(Volkswagen):
    """class Seat"""

    def run(self):
        super().run()
        print(
            f"А точнее ехать на своей тачке марки {self.__class__.__name__ +' '+self.model} "
        )


# for teacher
# mers = Audi("A4", 2012, "premium", "avtomat")
# mers.mileage()
# mers.run()

# seat = Seat("Leon", 2009, "premium")
# seat.mileage()
# seat.run()
