"""class Hashtable"""


class Node:
    """class Node"""

    def __init__(self, key, value) -> None:
        self.value = value
        self.index = None
        self.key = key
        self.next = None


class Hashtable:
    def __init__(self) -> None:
        self.head = None

    def len(self):
        """return len of list"""
        curent_node = self.head
        len = 0
        while curent_node:
            curent_node = curent_node.next
            len += 1
        return len

    def get_hash(self, key):
        lentab = self.len()
        if isinstance(key, int):
            return key % (lentab ** 2)
        else:
            sum = 0
            for pos in range(len(key)):
                sum = sum + ord(key[pos]) * pos
            return sum % (lentab ** 2)

    def add_item(self, key, value):
        """add element to the end"""
        if self.head is None:
            self.head = Node(key, value)
            self.head.index = self.get_hash(key)
            # print(self.head.index)
            return
        # running by elements to end (if see None - its ends element)
        curent_node = self.head
        while curent_node.next is not None:
            curent_node = curent_node.next

        curent_node.next = Node(key, value)  # ends element
        curent_node.next.index = self.get_hash(key)
        # print(curent_node.next.index)

    def printlist(self):
        """output values"""
        curent_node = self.head
        while curent_node.next is not None:
            print(f"{curent_node.key} : {curent_node.value}")
            curent_node = curent_node.next
        print(f"{curent_node.key} : {curent_node.value}")




if __name__ == "__main__":
    hashtable = Hashtable()
    hashtable.add_item("sd", 17)
    hashtable.add_item("asda", 90)
    hashtable.add_item("afsdf", 45)
    hashtable.add_item("dsfsdf", 9)
    hashtable.add_item("dsfsdfr", 107)
    hashtable.add_item("qqqqqqqq", 104)
    hashtable.add_item("suywe", 1009)
    hashtable.add_item("inbsgs", 105)
    hashtable.add_item(7, 105)
    hashtable.add_item(12, 105)
    hashtable.add_item(456, 105)
    hashtable.add_item(4589, 105)
    hashtable.printlist()
