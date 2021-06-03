"""class Stack"""
from ...data_struct.struct.queues import Queue


class Stack(Queue):
    """class Stack"""

    def push(self, value):
        """push next element to stack"""
        super().append(value)

    def pop(self):
        """pop last element"""
        return self.dequeue()

    def peek(self):
        curent_node = self.head
        while curent_node.next is not None:
            curent_node = curent_node.next

        return curent_node.curent


if __name__ == "__main__":
    some_stack = Stack()
    some_stack.push("firs in")
    some_stack.push(17)
    some_stack.push(90)
    some_stack.push("last in")
    some_stack.printlist()
    pop = some_stack.pop()
    print()
    some_stack.printlist()
    print()
    print(f"Here is- '{pop}'")

    last = some_stack.peek()
    print(last)
