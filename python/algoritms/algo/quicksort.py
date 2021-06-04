def qs(lst):
    """quick sort funk"""

    def reverse(lst, start, end):
        """replace elements arround base"""
        # choise base
        base_element = start
        for j in range(start + 1, end + 1):
            if lst[j] < lst[start]:
                base_element += 1
                lst[base_element], lst[j] = lst[j], lst[base_element]

        lst[base_element], lst[start] = lst[start], lst[base_element]

        return base_element

    # here we choise part for raplace (like rec)
    area = [
        0,
        len(lst) - 1,
    ]

    while len(area) > 0:
        end = area.pop()
        start = area.pop()
        base_element = reverse(lst, start, end)

        if start < base_element - 1:
            area.append(start), area.append(base_element - 1)

        if end > base_element + 1:
            area.append(base_element + 1), area.append(end)


def factorial(n):
    """fuctorial"""
    if n == 0:
        return None
    if n == 1:
        return n
    return factorial(n - 1) * n


if __name__ == "__main__":

    lst = [7, 11, 1, 2, 6, 5, 4, 3]
    qs(lst)
    print(lst)

    print(factorial(0))
