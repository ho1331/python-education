import pytest

from ...data_struct.struct.stack import Stack


@pytest.fixture
def lils():
    h = Stack()
    h.push(24)
    h.push(4)
    return h


def test_push(lils):
    lils.push(2)
    assert lils.head.next.next.curent == 2


def test_pop(lils):
    assert lils.pop() == 4


def test_peek(lils):
    lils.push(7)
    assert lils.peek() == 7
