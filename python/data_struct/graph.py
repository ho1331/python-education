"""class Graph"""
# import my queue class
# from python.data_struct.queues import Queue
from queues import Queue


class Node:
    """class Node"""

    def __init__(self, edge, *values) -> None:
        self.values = values
        self.countvar = 0
        self.edge = edge
        self.next = None


class Graph:
    def __init__(self) -> None:
        self.head = None

    def insert(self, edge, *values):
        if self.head is None:
            self.head = Node(edge, *values)
            for _ in self.head.values:
                self.head.countvar += 1
            return

        curent_node = self.head
        while curent_node.next is not None:
            curent_node = curent_node.next

        curent_node.next = Node(edge, *values)  # ends element
        for _ in curent_node.next.values:
            curent_node.next.countvar += 1

    def lookup(self, value):
        edge = self.head

        def search_path(edg):
            res = []
            edge = edg
            if edge is not None:
                if value.capitalize() in edge.values:
                    res.append(edge.edge)
                res += search_path(edge.next)
            return res

        res = search_path(edge)
        return res

    def output(self):
        curent_node = self.head
        while curent_node.next is not None:
            print(f"{curent_node.edge} : {curent_node.values}")
            curent_node = curent_node.next
        print(f"{curent_node.edge} : {curent_node.values}")


if __name__ == "__main__":
    test = Graph()
    test.insert("A", "B", "D", "C")
    test.insert("B", "D", "A")
    test.insert("C", "A", "D")
    test.insert("D", "C", "A", "B", "F")
    test.insert("F", "K", "D", "M")
    test.insert("K", "F")
    test.insert("M", "F", "O")
    test.insert("O", "M")
    test.output()
    print(test.lookup("d"))
