def qs(lst):
    def reverse(lst, start, end):
        """replace elements arround base"""
        #choise base
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


        area += {
            start < base_element - 1: [start, base_element - 1],
            end > base_element + 1: [base_element + 1, end],
        }.get(True, area)


lst = [7, 11, 1, 2, 6, 5, 4, 3]
qs(lst)
print(lst)
