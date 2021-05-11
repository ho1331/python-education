from abc import abstractmethod
from datetime import datetime


class Restaurant:
    _budget = 0
    __isOpen = None
    menu = {"Цезарь": 120, "Оливье": 80}

    def __init__(self):
        self.staff = 0
        self.hall = Hall().check_ftable()
        self.customer = {}
        self.worktime = datetime.now().hour

    def refresh_budget(self):
        pass

    @property
    def check_isOpen(self):
        if 8 <= self.worktime <= 20:
            Restaurant.__isOpen = True
        else:
            Restaurant.__isOpen = False
        return Restaurant.__isOpen

    def table_free(self):
        pass


class Hall:
    __freeTables = 60

    def check_ftable(self):
        pass


class Staff:
    _staff = {}
    income = 0
    outcome = 0

    @abstractmethod
    def __init__(self):
        raise NotImplementedError("Необходимо переопределить метод")

    @abstractmethod
    def get_salary(self):
        raise NotImplementedError("Необходимо переопределить метод")


class Managmant(Staff):
    def __init__(self, name):
        self.name = name


class ServiceStaff(Staff):
    def __init__(self, name):
        self.name = name
        # oblect Restaurant
        Restaurant.staff += 1


class Accountent(Managmant):
    salary = 0

    def __getBudget(self):
        pass

    def setBudget(self):
        pass


class Barman(ServiceStaff):
    salary = 0

    def pay_off(self):
        pass

    def __getproduct(self):
        pass

    def get_order(self):
        pass

    def bring_order(self):
        pass

    def makedrink(self):
        pass


class Cook(ServiceStaff):
    salary = 0
    _ingridients = {}

    def __getproduct(self):
        pass

    def get_order(self):
        pass

    def to_cook(self):
        pass

    def bring_order(self):
        pass


class Waiter(ServiceStaff):
    salary = 4200

    def pay_off(self):
        pass

    def get_order(self):
        pass

    def bring_order(self):
        pass


class Store:
    product = {}

    def check_product(self):
        pass


class Customer:
    __count = 0

    def __init__(self, name, adress=""):
        self.name = name
        self.adress = adress
        self.order = Order(self.name, self.adress)
        Customer.__count += 1

    @property
    def get_count(self):
        return Customer.__count

    def is_delivery(self):
        if len(self.adress) > 0:
            return True

    def pay_off(self):
        return self.order.choise[1]

    def get_order(self):
        my_choise = self.order.cust_order
        self.order.cust_order = my_choise
        return self.order.choise


class Order:
    def __init__(self, name, adress):
        self.name = name
        self.adress = adress
        self.choise = None

    @property
    def cust_order(self):
        return input(f"Выберете блюдо из меню\n {menu} : ").lower()

    @cust_order.setter
    def cust_order(self, choise):
        for i in menu.items():
            if choise.capitalize() == i[0]:
                self.choise = i


# Restaurant
restaurant = Restaurant()
# открыт ли ресторан
# print(restaurant.check_isOpen)
# меню
menu = restaurant.menu
# Customer
cust1 = Customer("John")
# заказ
order = cust1.get_order()
pay = cust1.pay_off()
