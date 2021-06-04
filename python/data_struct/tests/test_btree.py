import pytest

from ...data_struct.struct import btree


@pytest.fixture
def tree():
    return btree.BTree()


def test_insert(tree):
    tree.insert(5)
    assert tree.root.value == 5
    tree.insert(10)
    assert tree.root.right.value == 10
    tree.insert(3)
    assert tree.root.left.value == 3


def test_lookup(tree):
    tree.insert(10), tree.insert(12), tree.insert(6), tree.insert(5), tree.insert(8)
    assert tree.lookup(8) == [10, 6, 8]


def test_delete(tree):
    tree.insert(10), tree.insert(12)
    # old = tree.printree()
    assert 10 in tree.printtree()
    tree.delete(12)
    assert 12 not in tree.printtree()
