"""class Hashtable"""


class Node:
    """class Node"""

    def __init__(self, key, value) -> None:
        self.value = value
        self.index = None
        self.key = key  # added for beauty output
        self.next = None


class Hashtable:
    """class Hashtable"""

    def __init__(self) -> None:
        self.head = None

    def insert(self, key, value):
        """add item"""
        if self.head is None:
            self.head = Node(key, value)
            self.head.index = self.get_hash(key)
            return

        curent_node = self.head
        while curent_node.next is not None:
            # if old.key == new.key
            if curent_node.next.index == self.get_hash(key):
                curent_node.next.value = Node(key, value).value
                return
            else:
                curent_node = curent_node.next

        curent_node.next = Node(key, value)  # ends element
        curent_node.next.index = self.get_hash(key)

    def lookup(self, key):
        """return value by key"""
        curent_node = self.head

        while curent_node.next is not None:
            if self.get_hash(key) == curent_node.index:
                return curent_node.value
            curent_node = curent_node.next

        print(f"Key {key} not found")
        return curent_node.value

    def delete(self, key):
        """delete element by index"""
        del_item = self.lookup(key)
        # apply three nodes (left,to delete,right) > left ref right
        prev_node = None
        cur_node = self.head
        next_node = cur_node.next
        counter = 0
        while cur_node.next is not None:
            if del_item == cur_node.value:
                break
            prev_node = cur_node
            cur_node = prev_node.next
            next_node = cur_node.next
            counter += 1

        # change ref
        prev_node.next = next_node
        next_node = prev_node.next

    def printdict(self):
        """output dict items"""
        curent_node = self.head
        while curent_node.next is not None:
            print(f"{curent_node.key} : {curent_node.value}")
            curent_node = curent_node.next
        print(f"{curent_node.key} : {curent_node.value}")

    def get_hash(self, key):
        """return hash custom of value"""
        if isinstance(key, int):
            return key % 256
        else:
            mass_of_string = 0
            for pos, val in enumerate(key):
                mass_of_string = mass_of_string + ord(key[pos])
            return mass_of_string % 256


if __name__ == "__main__":
    hashtable = Hashtable()
    hashtable.insert("sd", 17)
    hashtable.insert("asda", 90)  # colission
    hashtable.insert("asda", 20)  # colission
    hashtable.insert("afsdf", 45)
    hashtable.insert("dsfsdf", 9)
    hashtable.insert("dsfsdfr", 107)
    hashtable.insert("qqqqqqqq", 104)
    hashtable.insert("suywe", 1009)
    hashtable.insert("inbsgs", 105)
    hashtable.insert(7, 105)  # colission
    hashtable.insert(7, "col")  # colission
    hashtable.insert(12, 110)
    hashtable.insert(456, 111)
    hashtable.insert(4589, 1)
    hashtable.printdict()
    some_key1, some_key2 = hashtable.lookup("sd1"), hashtable.lookup(7)
    print(some_key2)
    hashtable.delete("asdakfmwklfmlwkmeflkwmflkwmflk")
    print()
    hashtable.printdict()
