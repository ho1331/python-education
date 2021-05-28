"""https://www.learnpython.org/en/Exception_Handling"""

# Handle all the exception! Think back to the previous
# lessons to return the last name of the actor.

# Setup
actor = {"name": "John Cleese", "rank": "awesome"}

# Function to modify!!!
def get_last_name():
    """return last name"""
    try:
        return actor["last_name"]
    except KeyError:
        return actor["name"].split()[1]


# Test code
get_last_name()
print("All exceptions caught! Good job!")
print("The actor's last name is %s" % get_last_name())
