from abc import abstractmethod
from datetime import datetime
from typing import OrderedDict


class Restaurant:
    _budget = 100000
    __isOpen = None
    menu = {"Цезарь": 120, "Оливье": 80, "Виски": 100}

    def __init__(self):
        self.staff = {}
        self.hall = Hall()
        self.customer = 0
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

    def table_free(self, customer):
        """counts visitors and displays the number of free tables"""
        self.customer += customer
        self.hall.ftable = self.customer
        free = self.hall.ftable
        if free > 0:
            return self.hall.ftable


class Hall:
    __freeTables = 60

    @property
    def ftable(self):
        return Hall.__freeTables

    @ftable.setter
    def ftable(self, customer):
        Hall.__freeTables -= customer


class Staff:
    _staff = {"Waiter": 0, "Barman": 0, "Cook": 0, "Accountent": 0}
    income = 0
    outcome = 0

    def __init__(self, name):
        self.name = name
        for i in Staff._staff.keys():
            if self.__class__.__name__ == i:
                Staff._staff[i] += 1

    @abstractmethod
    def get_salary(self):
        raise NotImplementedError("Необходимо переопределить метод")


class Managmant(Staff):
    @abstractmethod
    def special(self):
        raise NotImplementedError("Необходимо переопределить метод")


class ServiceStaff(Staff):
    @abstractmethod
    def special(self):
        raise NotImplementedError("Необходимо переопределить метод")


class Accountent(Managmant):
    salary = 6000

    def __getBudget(self):
        pass

    def setBudget(self):
        pass


class Barman(ServiceStaff):
    salary = 4800
    waste = 0

    def __init__(self, name):
        super().__init__(name)
        self.order = None
        self.store = Store()

    def pay_off(self, pay):
        Staff.income += pay

    def __getproduct(self):
        order = self.order
        if order in self.store._product:
            Barman.waste += self.store.check_drinks(order)
            return True
        return False

    def get_order(self, outstanding):
        self.order = outstanding.lower()
        return outstanding

    def bring_order(self):
        return Barman.__getproduct(self)


class Cook(ServiceStaff):
    waste = 0
    salary = 5600
    _ingridients = {
        "Оливье": ("яйцо", "колбаса", "майонез", "горошек", "огурец"),
        "Цезарь": ("хлеб", "салат", "яйцо", "маслины", "мясо"),
    }

    def __init__(self, name):
        super().__init__(name)
        self.order = None
        self.store = Store()

    def to_cook(self, outstanding):
        self.order = outstanding
        return outstanding

    @property
    def _get_order(self):
        return Cook._ingridients

    @_get_order.setter
    def _get_order(self, ingridients):
        Cook._ingridients = ingridients

    def __getproduct(self):
        order = self.order
        ingridients = self._get_order
        if order in ingridients:
            # take a product
            meel = ingridients.get(order)
            Cook.waste += self.store.check_product(meel)
            return True
        return False

    def bring_order(self):
        return Cook.__getproduct(self)


class Waiter(ServiceStaff):
    salary = 4200

    def pay_off(self, pay):
        Staff.income += pay

    def get_order(self, order):
        return list(order)[0]

    def bring_order(self, cust):
        print(f"Thanks for your order {cust.name}")


class Store:
    _product = {
        "яйцо": 100,
        "масло": 50,
        "колбаса": 35,
        "хлеб": 150,
        "майонез": 60,
        "горошек": 44,
        "салат": 156,
        "маслины": 65,
        "огурец": 80,
        "мясо": 90,
        "виски": 30,
    }

    def check_product(self, meel):
        store = Store._product
        cost = 0
        for i in meel:
            for key, value in store.items():
                if i == key:
                    value -= 1
                    cost += 70
        return cost

    def check_drinks(self, drink):
        store = Store._product
        cost = 0
        for i in store:
            if i == drink:
                cost += 100
        return cost


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
cust2 = Customer("Brody")
cust3 = Customer("Johny")
cust4 = Customer("Finn")
count_cust = cust4.get_count

# проверка есть ли свободные столы
is_freeTable = restaurant.table_free(count_cust)

# заказ
order1 = cust1.get_order()
order2 = cust2.get_order()

pay1 = cust1.pay_off()
pay2 = cust2.pay_off()


# Personal
waiter1 = Waiter("Reychal")
waiter2 = Waiter("Mimi")
barman1 = Barman("Oleg")
cook1 = Cook("Grisha")
accountent1 = Accountent("Tamara")
# print(Staff._staff)

# внести кассу
waiter1.pay_off(pay1)
waiter2.pay_off(pay2)
# print(Staff.income)

# выполнение заказа
outstanding = waiter1.get_order(order1)
outstanding2 = waiter2.get_order(order2)
print(outstanding)
tocook = cook1.to_cook(outstanding)
isOrderisDone = cook1.bring_order()
print(cook1.waste)
drink_order = barman1.get_order(outstanding2)
isOrderisDone_2 = barman1.bring_order()
print(barman1.waste)
