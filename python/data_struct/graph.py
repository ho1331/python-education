"""class Graph"""
# from python.data_struct.linkedlist import Linkedflist

from linkedlist import Linkedflist


class Graph(Linkedflist):
    def __init__(self) -> None:
        super().__init__()
        # Here self.head - children
        self.edge = None
        self.count = 0

    def insert(self, edge, *values):
        if self.edge is None:
            self.edge = self.Node(edge)
        curent_node = self.edge
        while curent_node.next is not None:
            curent_node = curent_node.next
        curent_node.next = self.Node(edge)

        # added neighbours
        for i in values:
            self.append(i)
            self.count += 1

    def output(self):
        print(f"{self.edge.curent} : [", end=" ")
        curent_node = self.head
        while curent_node.next is not None:
            print(f"{curent_node.curent},", end=" ")
            curent_node = curent_node.next
        print(f"{curent_node.curent} ]")


if __name__ == "__main__":
    test = Graph()
    test.insert("A", 2, 3, 1, 4)
    test.output()
