import pytest

from ...data_struct.struct.queues import Queue


@pytest.fixture
def lils():
    h = Queue()
    h.enqueue(24)
    h.enqueue(4)
    h.enqueue(10)
    return h


def test_enqueue(lils):
    lils.enqueue(9)
    assert lils.head.curent == 9


def test_dequeue(lils):
    assert lils.dequeue() == 24


def test_peek(lils):
    lils.enqueue(17)
    assert lils.peek() == 17
