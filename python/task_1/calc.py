# coding: utf-8

"""This module implements a simple calculator class"""


class Calculator:
    """Class of Calculator"""

    def __init__(self, num1, num2):
        """
        initializeted object
        where num1, num1 are number of input
        """
        self.num1 = num1
        self.num2 = num2

    def add(self):
        """addition"""
        return self.num1 + self.num2

    def subtr(self):
        """subtraction"""
        return self.num1 - self.num2

    def mult(self):
        """multiplication"""
        return self.num1*self.num2

    def div(self):
        """division"""
        try:
            return self.num1/self.num2
        except ZeroDivisionError:
            return "Your 2nd number must be > 0"


def result_calc():
    """Show our result"""
    number_1 = int(input("Input 1st number: "))
    number_2 = int(input("Input 2nd number: "))
    operators = input("What do u want to do (enter /,*, -, +): ")
    calc = Calculator(number_1, number_2)
    if operators == "/":
        result = calc.div()
    elif operators == "*":
        result = calc.mult()
    elif operators == "+":
        result = calc.add()
    elif operators == "-":
        result = calc.subtr()
    else:
        result = "Please type again"

    return result


if __name__ == "__main__":
    answer = result_calc()
    print(answer)
