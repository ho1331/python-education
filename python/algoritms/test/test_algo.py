from math import factorial as fact

import pytest

from ..algo.binaryserch import binary_search
from ..algo.quicksort import factorial, qs


def test_binary_search():
    assert binary_search([2, 5, 3, 4, 7], 3) == 2


def test_qs():
    lst = [3, 3, 2, 454, 78, 8, 6, 3, 4]
    assert qs(lst) == lst.sort()


def test_factorial():
    assert factorial(43) == fact(43)
