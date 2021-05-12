"My iterators"
import re


class SentenceIterator:
    "class SentenceIterator"

    def __init__(self, text: str):
        self.text = text
        self.start = 0
        self.stop = len(self.text)

    def __iter__(self):
        return self

    def __next__(self):
        if self.start < self.stop:
            word = self.text[self.start]
            self.start += 1
            return word

        raise StopIteration


class Sentence:
    "class Sentence"

    def __init__(self, text: str):
        if isinstance(text, str) and text[-1] in ["?", ".", "!"]:
            self.text = [i for i in re.findall(r"\w+", text)]
            self.chars = [i for i in re.findall(r"[.,!?;:]", text)]
        elif not isinstance(text, str):
            raise TypeError("U must type a string")
        else:
            raise ValueError

    def __repr__(self):
        return f"<Sentence(words={len(self.text)}, other_chars={len(self.chars)})>"

    def __iter__(self):
        return SentenceIterator(self.text)

    def _words(self):
        # return <lazy iterator>
        for i in self.text:
            yield i

    def __getitem__(self, idx):
        return self.text[idx]

    @property
    def words(self):
        "return words generators"
        return (i for i in self.text)

    @property
    def other_chars(self):
        "return chars generators"
        return (i for i in self.chars)


obj1 = Sentence("Не помню, :;не люблю fuckkkkkkkk!!!")
