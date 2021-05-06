"""
Задание: https://classroom.google.com/c/Mjk0OTc3NDgyMzU1/a/MzM1MzAyOTU5NTg2/details
- practice creating classes from scratch and inheriting from other classes
- create class named Transport, think about attributes and methods, add them to the class
- think over and implement the class inheriting from the Transport class (at least 4),
- override methods and attributes for each class
"""
import datetime


class Transport:
    """class Transport"""

    # count of all avto
    count_of_transport = 0

    def __init__(self, model: str, year: int, segment: str) -> None:
        self.model = model
        self.year = year
        self.segment = segment
        self.average_distans_peryear = 6356
        self.today = datetime.datetime.today().year
        Transport.count_of_transport += 1

    def run(self):
        print("The car has already started")

    def mileage(self):
        print(
            f"Your {self.model} has been driven about \
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
        print("Now you can drive")


class Audi(Volkswagen):
    """class Audi"""

    def __init__(self, model, year, segment, transmition: str) -> None:
        super().__init__(model, year, segment)
        self.transmition = transmition

    def mileage(self):
        print(
            f"Yours {self.model} has been driven about \
                {self.average_distans_peryear * (self.today - self.year)} км. \n \
                Segment: {self.segment}, transmission {self.transmition}"
        )


class Inspection(Transport):
    """
    class Inspection
    checks the condition of the transport
    """

    def check_auto(self):
        a = self.average_distans_peryear * (self.today - self.year)
        if a > 80000:
            print(
                """U must CO-2 routine maintenance, and then CO-1 \
                maintenance no more than once every 8 thousand kilometers)"""
            )
        else:
            print("Don't worry, all is well.")


class Seat(Volkswagen, Inspection):
    """class Seat"""

    def run(self):
        super().run()
        print(
            f"(more specifically) - to drive your own car of the brand {self.__class__.__name__ +' '+self.model} "
        )


# for teacher
mers = Audi("A4", 2012, "premium", "avtomat")
mers.mileage()
mers.run()
print(mers.count_of_transport)


seat = Seat("Leon", 2009, "B")
seat.mileage()
seat.run()
print(seat.count_of_transport)

seat2 = Seat("Ibiza", 2006, "C")
seat2.mileage()
seat2.run()
seat2.check_auto()
print(seat.count_of_transport)
