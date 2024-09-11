from dataclasses import dataclass
from typing import Optional, Iterator
from collections.abc import Callable


def change(amount: int) -> dict[int, int]:
    if not isinstance(amount, int):
        raise TypeError('Amount must be an integer')
    if amount < 0:
        raise ValueError('Amount cannot be negative')
    counts, remaining = {}, amount
    for denomination in (25, 10, 5, 1):
        counts[denomination], remaining = divmod(remaining, denomination)
    return counts



# Write your first then lower case function here

def first_then_lower_case(a: list[str], p: Callable[[str], bool]) -> Optional[str]:
    for a_string in a:
        if p(a_string):
            return a_string.lower()
    return None

# Write your powers generator here
def powers_generator(base: int, limit: int) -> Iterator[int]:
    power: int = 0
    result: int = 0
    while result < limit:
        result = base**power
        power += 1
        if result <= limit: 
            yield result


# Write your say function here
def say(word: Optional[str] = None) -> str | Callable:
    if word == None:
        return ""
    else:
        return lambda next_word = None: say(word + " " + next_word) if next_word != None else word

    

# Write your line count function here


def meaningful_line_count(filename: str) -> int:
    try:
        with open(filename, 'r') as file: # opening the file in reading mode
            all_lines: list[str] = file.readlines() # list of all the lines
            count: int = 0
            for line in all_lines: # for each line in the list of lines, strips it and checks if it starts with #
                stripped_lines: str = line.strip()
                if stripped_lines and not stripped_lines.startswith('#'):
                    count += 1
            return count # returns the number of lines that are not whitespace or start with #
    except FileNotFoundError: # exception if the file is not found
        raise FileNotFoundError(f"No such file '{filename}'")


# Write your Quaternion class here

class Quaternion:
    def __init__(self, a: float, b: float, c: float, d: float):
        self.a = a
        self.b = b
        self.c = c
        self.d = d

        self.coefficients: tuple[float, float, float, float] = (a, b, c, d)

    @property
    def conjugate(self):
        return Quaternion(self.a, -self.b, -self.c, -self.d)

    def __add__(self, other):
        if isinstance(other, Quaternion):
            new_quaternion = Quaternion(self.a + other.a, self.b + other.b, self.c + other.c, self.d + other.d)
            return new_quaternion
        
    def __eq__(self, other):
        if isinstance(other, Quaternion):
            return self.a == other.a and self.b == other.b and self.c == other.c and self.d == other.d
        return False


    def __mul__(self, other):
        if isinstance(other, Quaternion):
            mult_a = (self.a * other.a) - (self.b * other.b) - (self.c * other.c) - (self.d * other.d)
            mult_b = (self.a * other.b) + (self.b * other.a) + (self.c * other.d) - (self.d * other.c)
            mult_c = (self.a * other.c) - (self.b * other.d) + (self.c * other.a) + (self.d * other.b)
            mult_d = (self.a * other.d) + (self.b * other.c) - (self.c * other.b) + (self.d * other.a)
            mult_quat = Quaternion(mult_a, mult_b, mult_c, mult_d)
            return mult_quat
        
    def __str__(self):
        set_of_values: list[tuple[float, str]] = [(self.b, "i"), (self.c, "j"), (self.d, "k")]
        total: str = ""
        if self.a == 0 and self.b == 0 and self.c == 0 and self.d == 0:
            return "0"
        if self.a != 0:
            total += f"{self.a}"
        for (val, letter) in set_of_values:
            if val > 0 and val != 1:
                if total == "": 
                    total += f"{val}"
                    total += f"{letter}"
                else:
                    total += f"+{val}"
                    total += f"{letter}"
            elif val < 0 and val != -1:
                total += f"{val}"
                total += f"{letter}"
            elif val == 1:
                if total == "":
                    total += f"{letter}"
                else:
                    total += f"+{letter}"
            elif val == -1:
                total += f"-{letter}"
        return total

