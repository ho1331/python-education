"""class Graph"""


class Node:
    """class Node"""

    def __init__(self, edge, *values) -> None:
        self.values = values
        self.countvar = 0
        self.edge = edge
        self.next = None


class Graph:
    """class Graph"""

    def __init__(self) -> None:
        self.head = None

    def insert(self, edge, *values):
        """insert values"""
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
        """return path to value"""
        edge = self.head

        # create rec func for searh of ways
        def search_path(edg):
            res = []
            edge = edg
            if edge is not None:
                if value.capitalize() in edge.values:
                    res.append(edge.edge)
                res += search_path(edge.next)
            return res

        res = search_path(edge)

        if res:
            return res
        else:
            return "Not found"

    def output(self):
        """print curently graph"""
        curent_node = self.head
        while curent_node.next is not None:
            print(f"{curent_node.edge} : {curent_node.values}")
            curent_node = curent_node.next
        print(f"{curent_node.edge} : {curent_node.values}")

    def delete(self, value):
        """delete edge end relatives"""
        if not isinstance(self.lookup(value), str):
            if isinstance(value, str):
                value = value.capitalize()
        else:
            return "Not found"
        curent_node = self.head
        # cut edge
        while curent_node.next and curent_node.next.edge != value:
            if value in curent_node.values:
                curent_node.values = tuple(i for i in curent_node.values if i != value)

            curent_node = curent_node.next
        if value in curent_node.values:
            curent_node.values = tuple(i for i in curent_node.values if i != value)

        # clear relatives
        clear = curent_node.next
        while clear is not None:
            node = self.head
            while node.next is not None:
                node.values = tuple(i for i in node.values if i != clear.edge)
                node = node.next
            clear = clear.next

        curent_node.next = None


if __name__ == "__main__":
    test = Graph()
    test.insert("A", "B", "K", "D", "C")
    test.insert("B", "D", "M", "A")
    test.insert("C", "A", "O", "D")
    test.insert("D", "C", "A", "B", "F")
    test.insert("F", "K", "D", "M")
    test.insert("K", "F")
    test.insert("M", "F", "O", "Q")
    test.insert("O", "M")
    test.output()
    print(test.lookup("d"))  # way to D
    print()
    test.delete("f")
    test.output()
