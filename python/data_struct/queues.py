"""class Queue"""

from linkedlist import Linkedflist


class Queue(Linkedflist):
    """class Queue"""

    def enqueue(self, value):
        """add element to the end"""
        if self.head is None:
            self.head = self.Node(value)
            return
        self.insert(0, value)

    def dequeue(self):
        """pop first element"""
        idx = 0
        curent_node = self.head
        while curent_node.next is not None:
            curent_node = curent_node.next
            idx += 1

        self.delete(idx)
        return curent_node.curent


if __name__ == "__main__":
    some_eq = Queue()
    some_eq.enqueue("firs in")
    some_eq.enqueue(17)
    some_eq.enqueue(90)
    some_eq.enqueue(34)
    some_eq.enqueue("last in")
    some_eq.printlist()
    print()
    deq = some_eq.dequeue()
    some_eq.printlist()
    print()
    print(f"Here is - '{deq}'")
