""" binary search"""

from random import sample


def binary_search(lst, item):
    """BS algoritm"""
    start = 0
    stop = len(lst) - 1

    while start <= stop:
        mid = (start + stop) // 2
        guess = lst[mid]

        if guess == item:
            return mid

        if item < guess:
            stop = mid - 1

        else:
            start = mid + 1

    return f"{item} not in list"


item = 12
my_list = sorted(sample(list(range(1, 140)), 50))
x = binary_search(my_list, item)
print(x)
