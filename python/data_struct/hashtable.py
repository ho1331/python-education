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

    def insert(self, key, value):
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

    def lookup(self, key):
        pass

    def delete(self, key):
        pass

    def printlist(self):
        """output values"""
        curent_node = self.head
        while curent_node.next is not None:
            print(f"{curent_node.key} : {curent_node.value}")
            curent_node = curent_node.next
        print(f"{curent_node.key} : {curent_node.value}")


if __name__ == "__main__":
    hashtable = Hashtable()
    hashtable.insert("sd", 17)
    hashtable.insert("asda", 90)
    hashtable.insert("afsdf", 45)
    hashtable.insert("dsfsdf", 9)
    hashtable.insert("dsfsdfr", 107)
    hashtable.insert("qqqqqqqq", 104)
    hashtable.insert("suywe", 1009)
    hashtable.insert("inbsgs", 105)
    hashtable.insert(7, 105)
    hashtable.insert(12, 105)
    hashtable.insert(456, 105)
    hashtable.insert(4589, 105)
    hashtable.printlist()
