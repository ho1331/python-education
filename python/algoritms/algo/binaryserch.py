""" binary search"""

from random import sample


def binary_search(lst, item):
    """BS algoritm"""
    start = 0
    stop = len(lst) - 1

    while start <= stop:
        mid = (start + stop) // 2  # cut list
        guess = lst[mid]

        if guess == item:
            return mid

        if item < guess:
            stop = mid - 1

        else:
            start = mid + 1

    return f"{item} not in list"


def binary_rec(lst, item, start, stop):
    """recursive vers of BS"""
    if start > stop:
        return f"{item} not in list"
    else:
        mid = (start + stop) // 2
        if item == lst[mid]:
            return mid
        elif item > lst[mid]:
            return binary_rec(lst, item, mid + 1, stop)
        else:
            return binary_rec(lst, item, start, mid - 1)


if __name__ == "__main__":
    some_number = 12
    my_list = sorted(sample(list(range(1, 140)), 50))
    x = binary_search(my_list, some_number)
    print(x)

    y = binary_rec(my_list, some_number, 0, len(my_list) - 1)
    print(y)
