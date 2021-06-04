import pytest

from ...data_struct.struct.graph import Graph


@pytest.fixture
def graph():
    return Graph()


@pytest.fixture
def look():
    f = Graph()
    f.insert("A", "N", "K", "D")
    f.insert("N", "O", "D")
    f.insert("K", "Z", "D", "N")
    return f


def test_insert(graph):
    graph.insert("A", "B", "C", "E")
    assert graph.head.edge == "A"
    assert graph.head.values == ("B", "C", "E")
    graph.insert("F", "Q", "W")
    assert graph.head.next.edge == "F"
    assert graph.head.next.values == ("Q", "W")


def test_lookup(look):
    assert look.lookup("D") == ["A", "N", "K"]


def test_delete(look):
    assert ["A", "N", "K"] == look.lookup("D")
    look.delete("D")
    assert look.lookup("D") == "Not found"
