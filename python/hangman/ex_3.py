"""https://www.learnpython.org/en/Generators"""

# Write a generator function which returns the Fibonacci series.
# They are calculated using the following formula: The first two numbers
# of the series is always equal to 1, and each consecutive number returned is the sum
# of the last two numbers. Hint: Can you use only two variables in the generator function?
# Remember that assignments can be done simultaneously.
# The code will simultaneously switch the values of a and b.
import types


# fill in this function
def fib():
    """generator function which returns the Fibonacci series"""
    pos1, pos2 = 1, 1
    while True:
        yield pos1
        pos1, pos2 = pos2, pos1 + pos2


# testing code


if type(fib()) == types.GeneratorType:
    print("Good, The fib function is a generator.")

    counter = 0
    for n in fib():
        print(n)
        counter += 1
        if counter == 10:
            break
