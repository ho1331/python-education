"""Binary Search Tree"""
# insert - добавить элемент,
# lookup - найти элемент по значению и вернуть ссылку на него (узел),
# delete - удалить элемент по значению),


class BTree:
    def __init__(self) -> None:
        self.root = None

    class Node:
        def __init__(self, value):

            self.left = None
            self.value = value
            self.right = None

    def insert(self, value):
        """unsert leaf to tree"""
        if self.root is None:
            self.root = self.Node(value)
            return

        leaf = self.root

        while True:
            if leaf.value > value:
                if leaf.left is None:
                    leaf.left = self.Node(value)
                    break
                else:
                    leaf = leaf.left

            elif leaf.value <= value:
                if leaf.right is None:
                    leaf.right = self.Node(value)
                    break
                else:
                    leaf = leaf.right

    def lookup(self, value):
        """search leaf by value"""
        leaf = self.root
        path = []
        while True:
            if leaf.value > value:
                if value in path:
                    return path
                path.append(leaf.value)
                if leaf.left is not None:
                    leaf = leaf.left

            elif leaf.value <= value:
                if value in path:
                    return path
                path.append(leaf.value)
                if leaf.right is not None:
                    leaf = leaf.right

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


if __name__ == "__main__":
    root = BTree()
    root.insert(12)
    root.insert(6)
    root.insert(14)
    root.insert(3)
    root.insert(26)
    root.insert(13)
    root.insert(5)
    root.insert(2)
    print(root.lookup(13))
    print(root.printtree())
