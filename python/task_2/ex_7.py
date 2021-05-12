"""https://www.learnpython.org/en/Partial_functions"""

# Edit the function provided by calling partial() and replacing
# the first three variables in func(). Then print with the new
# partial function using only one input variable so that the output equals 60.


# Following is the exercise, function provided:
from functools import partial


def func(u, v, w, x):
    "return some sum"
    return u * 4 + v * 3 + w * 2 + x


# Enter your code here to create and print with your partial function
new_funk = partial(func, 4, 10, 5)
print(new_funk(4))
