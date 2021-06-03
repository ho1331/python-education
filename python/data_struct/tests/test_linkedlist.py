import pytest

from ...data_struct.struct.linkedlist import Linkedflist


@pytest.fixture
def ll():
    return Linkedflist()


@pytest.fixture
def lils():
    h = Linkedflist()
    h.append(24)
    h.append(4)
    h.append(10)
    return h


def test_append(lils):
    lils.append(11)
    assert lils.head.next.next.next.curent == 11


def test_insert(lils):
    lils.insert(1, 200)
    assert lils.head.next.curent == 200


def test_get_element(lils):
    assert lils.get_element(2) == 10


def test_lookup(lils):
    assert lils.lookup(4) == 1


def test_delete(lils):
    lils.delete(1)
    assert lils.head.next.curent == 10
