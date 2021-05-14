from abc import abstractmethod
from datetime import datetime


class Restaurant:
    """class Restaurant"""

    _budget = 100000
    __isOpen = None
    menu = {"Цезарь": 120, "Оливье": 80, "Виски": 100}

    def __init__(self):
        self.staff = {}
        self.hall = Hall()
        self.customer = 0
        self.worktime = datetime.now().hour

    def refresh_budget(self):
        return Restaurant._budget

    @property
    def check_isOpen(self):
        """check is restaurant is open"""
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
    """class Hall"""

    __freeTables = 60

    @property
    def ftable(self):
        return Hall.__freeTables

    @ftable.setter
    def ftable(self, customer):
        Hall.__freeTables -= customer


class Staff:
    """class Staff"""

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
    """class Managmant"""

    _salary = 5900

    @abstractmethod
    def special(self):
        raise NotImplementedError("Необходимо переопределить метод")

    @property
    def salary(self):
        return Managmant._salary


class ServiceStaff(Staff):
    """class ServiceStaff"""

    _salary = {"Waiter": 4200, "Barman": 4500, "Cook": 5100}

    @abstractmethod
    def special(self):
        raise NotImplementedError("Необходимо переопределить метод")

    @property
    def salary(self):
        return ServiceStaff._salary


class Accountent(Managmant):
    """class Accountent"""

    def setBudget(self, income, outcome, managm, serstaff):
        """returns incoming cash"""
        salary = 0
        for prof, salar in serstaff.items():
            for key, count in Staff._staff.items():
                if prof == key:
                    salary += salar * count
        # per a month
        wastage = (salary + managm) * 30 + outcome
        incoming = income - wastage
        return incoming

    def getBudget(self, main_budget, incomes):
        """returns diff of budget and incoming"""
        refresh = main_budget + incomes
        return refresh


class Barman(ServiceStaff):
    """class Barman"""

    waste = 0

    def __init__(self, name):
        super().__init__(name)
        self.order = None
        self.store = Store()

    def pay_off(self, pay):
        Staff.income += pay

    def __getproduct(self):
        """take product of store if it here and set waste"""
        order = self.order
        if order in self.store._product:
            Barman.waste += self.store.check_drinks(order)
            Staff.outcome += Barman.waste
            return True
        return False

    def get_order(self, outstanding):
        """take an order"""
        self.order = outstanding.lower()
        return outstanding

    def bring_order(self):
        """barmen start working"""
        return Barman.__getproduct(self)


class Cook(ServiceStaff):
    """class Cook"""

    waste = 0
    _ingridients = {
        "Оливье": ("яйцо", "колбаса", "майонез", "горошек", "огурец"),
        "Цезарь": ("хлеб", "салат", "яйцо", "маслины", "мясо"),
    }

    def __init__(self, name):
        super().__init__(name)
        self.order = None
        self.store = Store()

    def to_cook(self, outstanding):
        """take an order"""
        self.order = outstanding
        return outstanding

    @property
    def _get_order(self):
        return Cook._ingridients

    @_get_order.setter
    def _get_order(self, ingridients):
        Cook._ingridients = ingridients

    def __getproduct(self):
        """take product of store if it here and set waste"""
        order = self.order
        ingridients = self._get_order
        if order in ingridients:
            # take a product
            meel = ingridients.get(order)
            Cook.waste += self.store.check_product(meel)
            Staff.outcome += Cook.waste
            return True
        return False

    def bring_order(self):
        """cooker is working"""
        return Cook.__getproduct(self)


class Waiter(ServiceStaff):
    """class Wasiter"""

    def pay_off(self, pay):
        """put some cash"""
        Staff.income += pay

    def get_order(self, order):
        """return an order"""
        return list(order)[0]

    def bring_order(self, cust):
        print(f"Thanks for your order {cust.name}")


class Store:
    """class Store
    buildings in Cook and Barman
    """

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
        """check is product in store and return cost"""
        store = Store._product
        cost = 0
        for i in meel:
            for key, value in store.items():
                if i == key:
                    value -= 1
                    cost += 70
        return cost

    def check_drinks(self, drink):
        """check is drink in store and return cost"""
        store = Store._product
        cost = 0
        for i in store:
            if i == drink:
                cost += 100
        return cost


class Customer:
    """class Customer"""

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
        """if out on the restaurant"""
        if len(self.adress) > 0:
            return True

    def pay_off(self):
        """pay money for order"""
        return self.order.choise[1]

    def get_order(self):
        """return customer order"""
        my_choise = self.order.cust_order
        self.order.cust_order = my_choise
        return self.order.choise


class Order:
    """class Order"""

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


# test by words - оливье, виски
if __name__ == "__main__":
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
    tocook = cook1.to_cook(outstanding)
    isorderisdone = cook1.bring_order()
    print(cook1.waste)
    drink_order = barman1.get_order(outstanding2)
    isorderisdone_2 = barman1.bring_order()
    print(barman1.waste)

    # Budget
    main_budget = restaurant.refresh_budget()
    income, outcome = accountent1.income, accountent1.outcome
    salserviceStaff = waiter1.salary
    salmanagmant = accountent1.salary

    # incoming = accountent1.setBudget(income, outcome, salmanagmant, salserviceStaff)
    incoming = accountent1.setBudget(income, outcome, salmanagmant, salserviceStaff)
    refresh = accountent1.getBudget(main_budget, incoming)
    print(refresh)
