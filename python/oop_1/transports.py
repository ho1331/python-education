"""
Задание: https://classroom.google.com/c/Mjk0OTc3NDgyMzU1/a/MzM1MzAyOTU5NTg2/details
- practice creating classes from scratch and inheriting from other classes
- create class named Transport, think about attributes and methods, add them to the class
- think over and implement the class inheriting from the Transport class (at least 4),
- override methods and attributes for each class
"""
import datetime
from abc import ABC, abstractmethod


class Tuning(ABC):
    "abstract class"

    def __init__(self, system):
        self.system = system
        self._firm = ["alpine", "pioner", "sony", "jbl"]
        self._price = {"alpine": "2000", "pioner": "1100", "sony": "900", "jbl": "1250"}

    def __getitem__(self, system):
        """return value of price"""
        if system in self._price:
            return self._price[system]

    def __len__(self):
        """show len of firm"""
        return len(self._firm)

    def __bool__(self):
        """check is firm in price.keys"""
        count = 0
        for i in self._price:
            for j in self._firm:
                if i == j:
                    count += 1
        return count == len(self._firm)

    def __dir__(self):
        """show class methods"""
        return "firm", "weels"

    def __getattr__(self, attrname):
        """check is attrname in cls.atr"""
        return f"{attrname} - NOT FOUND"

    def firm(self):
        """show name of sys"""
        print(f"Your system is {self.system}")

    @abstractmethod
    def power(self):
        """abstract method"""
        ...


print(dir(Tuning))


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
        """print info"""
        print("The car has already started")

    def mileage(self):
        """show distance"""
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
        """show info"""
        super().run()
        print("Now you can drive")


class Audi(Volkswagen):
    """class Audi"""

    def __init__(self, model, year, segment, transmition: str) -> None:
        super().__init__(model, year, segment)
        self.transmition = transmition

    def mileage(self):
        """show distance"""
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
        """check a car"""
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
        """show info"""
        super().run()
        print(
            f"(more specifically) - to drive your own car of \
                the brand {self.__class__.__name__ +' '+self.model} "
        )


class Acoustic(Tuning):
    """ "class Acoustic. Define parametrs of cars acoustic"""

    # counter of obj
    __counter = 0

    def __init__(self, system):
        Acoustic.__counter += 1
        super().__init__(system)

    def firm(self):
        """show messege about sys"""
        super().firm()
        if self.system in self._firm:
            print("You have a good acoustic system")
        else:
            print(f"Your system could be better like {self._firm}")

    def power(self):
        """show info"""
        print("Please check your power")

    @property
    def cost(self):
        """getter"""
        my_system = self._price.get(self.system)
        if my_system:
            return f"Cost of your system about {my_system}"
        else:
            return f"Your system '{self.system}' is undefind"

    @cost.setter
    def cost(self, cost):
        """setter"""
        if cost > max([int(i) for i in self._price.values()]):
            self._price[self.system] = cost

    @classmethod
    def counter(cls):
        """show count of obj"""
        print(f"You created {Acoustic.__counter} objects")

    @staticmethod
    def much_price(price):
        """return much price"""
        return {
            price > 4000: "expensive",
            4000 >= price > 1000: "Normal",
            price <= 1000: "cheap",
        }[True]


my_acoustic = Acoustic("dff")
my_acoustic2 = Acoustic("dfr")
my_acoustic.firm()
my_system = my_acoustic.cost
my_acoustic.cost = 5000
print(my_system)
print(my_acoustic._price)
print(my_acoustic.much_price(2000))
Acoustic.counter()

# check dunder
print(my_acoustic.system2)
print(my_acoustic["alpine"])
print(len(my_acoustic))
print(bool(my_acoustic))


# mers = Audi("A4", 2012, "premium", "avtomat")
# mers.mileage()
# mers.run()
# print(mers.count_of_transport)


# seat = Seat("Leon", 2009, "B")
# seat.mileage()
# seat.run()
# print(seat.count_of_transport)

# seat2 = Seat("Ibiza", 2006, "C")
# seat2.mileage()
# seat2.run()
# seat2.check_auto()
# print(seat.count_of_transport)
