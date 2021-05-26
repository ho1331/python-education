"""class Stack"""
# from python.data_struct.linkedlist import Linkedflist
# from python.data_struct.queue import Queue
from queues import Queue


class Stack(Queue):
    """class Stack"""

    def push(self, value):
        """push next element to stack"""
        super().append(value)

    def pop(self):
        """pop last element"""
        pop = self.dequeue()
        return pop


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
