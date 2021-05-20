# from unittest.mock import Mock, patch

import pytest
from tests.testfiles import codetotest as code

# @pytest.fixture
# def empty_wallet():
#     """Returns a Wallet instance with a zero balance"""
#     return Wallet()


# @pytest.mark.parametrize(
#     "earned,spent,expected",
#     [
#         (30, 10, 20),
#         (20, 2, 18),
#     ],
# )
# def test_transactions(earned, spent, expected):
#     my_wallet = Wallet()
#     my_wallet.add_cash(earned)
#     my_wallet.spend_cash(spent)
#     assert my_wallet.balance == expected


# def capital_case(x):
#     if not isinstance(x, str):
#         raise TypeError("Please provide a string argument")
#     return x.capitalize()


# def test_capital_case():
#     assert capital_case("semaphore") == "Semaphore"


# def test_raises_exception_on_non_string_arguments():
#     with pytest.raises(TypeError):
#         capital_case(9)

# m = Mock()
# m()
# m()
# m()
# print(m.call_count)

# test even_odd()
def test_even_odd():
    assert code.even_odd(4) == "even"
    assert code.even_odd(5) == "odd"


# test sum_all()
@pytest.mark.parametrize(
    "args",
    [
        list(range(50)),
        [float(i) for i in range(45)],
        [int(i) + float(x) for i in range(34) for x in range(10)],
    ],
)
def test_sun_all(args):
    assert code.sum_all(*args) == sum(args)
