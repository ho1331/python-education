# LinkedList,
# Queue,
# Stack,
# HashTable,
# Tree,
# Graph

# LinkedList


class Linkedflist:
    """class Linkedlist"""

    def __init__(self) -> None:
        self.head = None

    class Node:
        """class Node"""

        def __init__(self, value) -> None:
            self.curent = value
            self.next = None

    def append(self, value):
        """add element to the end"""
        if self.head == None:
            self.head = self.Node(value)
            return
        # running by elements to end (if see None - its ends element)
        curent_node = self.head
        while curent_node.next != None:
            curent_node = curent_node.next

        curent_node.next = self.Node(value)  # ends element

    def insert(self, idx, new_value):
        """
        insert element by index
        (to prepend use obj.insert(0,value))
        """
        insert_node = self.Node(new_value)

        left_node = None
        next_node = self.head

        counter = 0
        # insert to head
        if idx == 0:
            self.head = insert_node
            self.head.next = next_node
            return

        # running by elements to end (if see None - its ends element)
        while counter < idx:
            left_node = next_node
            next_node = next_node.next
            counter += 1

        left_node.next = insert_node
        insert_node.next = next_node

    def get_element(self, idx):
        """get element by index"""
        curent_node = self.head
        counter = 0
        while counter < idx:
            curent_node = curent_node.next
            counter += 1

        return curent_node.curent

    def lookup(self, element):
        """get index of element by value"""
        curent_node = self.head
        counter = 0
        while curent_node.next != None:
            if element == curent_node.curent:
                break
            curent_node = curent_node.next
            counter += 1
        return counter

    def printlist(self):
        """output values of linkedlist"""
        curent_node = self.head
        while curent_node.next != None:
            print(curent_node.curent)
            curent_node = curent_node.next
        print(curent_node.curent)

    def delete(self, idx):
        """delete element by index"""
        del_item = self.get_element(idx)
        # apply three nodes (left,to delete,right) > left ref right
        prev_node = None
        cur_node = self.head
        next_node = cur_node.next
        counter = 0
        while counter < idx:
            if del_item == cur_node.curent:
                break
            prev_node = cur_node
            cur_node = prev_node.next
            next_node = cur_node.next
            counter += 1

        # change ref
        prev_node.next = next_node
        next_node = prev_node.next


some_lst = Linkedflist()
some_lst.append(17)
some_lst.append(90)
some_lst.append(4)
some_lst.append(5)
some_lst.append("some element")
some_lst.append(6)
# insert
some_lst.insert(2, "idx 2")  # insert with index=2
some_lst.insert(0, 11)  # prepend (shifts list for one position to the right)
some_lst.printlist()
print()

# get elem by index
element4 = some_lst.get_element(1)
print(element4, end="\n\n")
# get index by value
index_elem = some_lst.lookup("idx 2")
print(index_elem, end="\n\n")

# delete elem by index
some_lst.delete(3)
some_lst.printlist()
