"""Binary Search Tree"""
# insert - добавить элемент,
# lookup - найти элемент по значению и вернуть ссылку на него (узел),
# delete - удалить элемент по значению),


class BTree:
    """class BTree"""

    def __init__(self) -> None:
        self.root = None

    class Node:
        """class Node"""

        def __init__(self, value):

            self.left = None
            self.value = value
            self.right = None

        def min(self):
            """return min val on branch"""
            if self.left is None:
                return self.value
            return self.left.min()

        def remove(self, value):
            """remove node"""
            if value < self.value:
                if self.left:
                    self.left = self.left.remove(value)
            elif value > self.value:
                if self.right:
                    self.right = self.right.remove(value)
            else:
                if self.left is None and self.right is None:
                    return None
                elif self.left is None:
                    return self.right
                elif self.right is None:
                    return self.left

                min = self.right.min()
                self.value = min
                self.right = self.right.remove(min)

            return self

    def insert(self, item):
        """unsert leaf to tree"""
        value = self.get_hash(item)
        if self.root is None:
            self.root = self.Node(item)
            return

        leaf = self.root

        while True:
            if self.get_hash(leaf.value) > value:
                if leaf.left is None:
                    leaf.left = self.Node(item)
                    break
                else:
                    leaf = leaf.left

            elif self.get_hash(leaf.value) <= value:
                if leaf.right is None:
                    leaf.right = self.Node(item)
                    break
                else:
                    leaf = leaf.right

    def lookup(self, value):
        """search leaf by value"""
        leaf = self.root
        path = []
        hash = self.get_hash(value)

        if value not in self.printtree():
            return "Not exist"

        while leaf:
            if self.get_hash(leaf.value) > hash:
                if value in path:
                    return path
                path.append(leaf.value)
                if leaf.left is not None:
                    leaf = leaf.left

            elif self.get_hash(leaf.value) <= hash:
                if value in path:
                    return path
                path.append(leaf.value)
                if leaf.right is not None:
                    leaf = leaf.right

    def get_hash(self, key):
        """return hash custom of value"""
        if isinstance(key, int):
            return key % 256
        else:
            mass_of_string = 0
            for pos, val in enumerate(key):
                mass_of_string = mass_of_string + ord(key[pos])
            return mass_of_string % 256

    def printtree(self):
        """output values of tree"""
        curent = self.root

        def dfs(curent):
            res = []
            if curent:
                res += dfs(curent.left)
                res.append(curent.value)
                res += dfs(curent.right)
            return res

        return dfs(curent)

    def delete(self, value):
        """delete link of Node"""

        if value not in self.printtree():
            return "Not found"

        if value < self.root.value:
            if self.root.left:
                self.root.left = self.root.left.remove(value)
        elif value > self.root.value:
            if self.root.right:
                self.root.right = self.root.right.remove(value)

        return self.root


if __name__ == "__main__":
    root = BTree()
    root.insert(15)
    root.insert(10)
    root.insert(18)
    root.insert(13)
    root.insert(9)
    root.insert(17)
    root.insert(19)
    root.insert(16)
    root.insert(17)
    print(root.lookup(9))
    print(root.printtree())
    root.delete(18)
    print(root.printtree())
