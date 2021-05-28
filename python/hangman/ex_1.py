"""https://www.learnpython.org/en/Modules_and_Packages"""

# In this exercise, you will need to print an alphabetically
# sorted list of all functions in the re module, which contain the word find.


import re

list_of_regex = dir(re)
methods = ", ".join(list_of_regex)
mutch = re.findall(r"[^,\s]*find[^,\s]*", methods)
print(sorted(mutch))
