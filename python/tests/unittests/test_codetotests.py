from unittest.mock import Mock, patch

import pytest
from tests.testfiles import codetotest as code

# import pkgutil

# search_path = [
#     "."
# ]  # Используйте None, чтобы увидеть все модули, импортируемые из sys.path
# all_modules = [x[1] for x in pkgutil.iter_modules(path=search_path)]
# print(all_modules)

# test even_odd()
def test_even_odd():
    assert code.even_odd(4) == "even"
    assert code.even_odd(5) == "odd"
# -----------------------------------------------------------------------------------------
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
# -----------------------------------------------------------------------------------------

# test class Product
@pytest.fixture
def obj_product():
    return code.Product("apple", 20)


def test_subtract_quantity(obj_product):
    obj_product.subtract_quantity()
    assert obj_product.quantity >= 0


def test_add_quantity(obj_product):
    obj_product.add_quantity()
    assert obj_product.quantity > 0


def test_change_price(obj_product):
    price = obj_product.price
    obj_product.change_price(20.4)
    assert (obj_product.price > price) and (type(obj_product.price) == float)
