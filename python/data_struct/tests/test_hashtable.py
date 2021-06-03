import pytest

from ...data_struct.struct.hashtable import Hashtable


@pytest.fixture
def hash_table():
    return Hashtable()


@pytest.fixture
def look():
    h = Hashtable()
    h.insert("sd", 24)
    h.insert("d", 4)
    h.insert("f", 10)
    return h


def test_insert(hash_table):
    hash_table.insert("sd", 24)
    assert hash_table.head.value == 24
    assert hash_table.head.key == "sd"
    assert hash_table.head.index is not None
    assert hash_table.head.next is None
    hash_table.insert("d", 4)
    assert hash_table.head.next is not None


def test_lookup(look):
    assert look.lookup("d") == 4


def test_delete(look):
    assert look.head.next.key == "d"
    look.delete("d")
    assert look.head.next.key == "f"
