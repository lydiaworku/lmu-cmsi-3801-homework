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

# loops through the list of strings, a, and, if the string satisfies p, returns the lowercase version of a
def first_then_lower_case(a: list[str], p: Callable[[str], bool], /) -> Optional[str]:  # only positional arguments are allowed
    for a_string in a:
        if p(a_string):
            return a_string.lower()
    return None


# Write your powers generator here

def powers_generator(*, base: int, limit: int) -> Iterator[int]:   # only keyword arguments allowed
    power: int = 0
    result: int = 0     # variables representing the exponent and the result of each calculation
    while result < limit:       # while the result is less than or equal to the limit, calculations are done
        result = base ** power
        power += 1
        if result <= limit: # if the result is still less than the limit after calculations, it is yielded
            yield result


# Write your say function here

def say(word: Optional[str] = None, /) -> str | Callable:   # only positional arguments allowed
    if word == None: # if word is None (its default value), the empty string is returned
        return ""
    else:   # if not, word is appended to a space and the next word and the function is done recursively to this new word
        return lambda next_word = None: say(word + " " + next_word) if next_word != None else word


# Write your line count function here

def meaningful_line_count(filename: str, /) -> int: # only positional arguments
    try:
        with open(filename, 'r') as file: # opening the file in reading mode
            count: int = 0
            for line in file: # for each line in the list of lines, strips it and checks if it starts with #
                stripped_lines: str = line.strip()
                if stripped_lines and not stripped_lines.startswith('#'): # takes away lines that start with '#'
                    count += 1
            return count # returns the number of lines that are not whitespace or start with #
    except FileNotFoundError: # exception if the file is not found
        raise FileNotFoundError(f"No such file '{filename}'")


# Write your Quaternion class here

@dataclass(frozen=True)
class Quaternion:
    a: float
    b: float
    c: float
    d: float

    # returns coefficients of a, b, c, d in the Quaternion
    @property
    def coefficients(self):
        return (self.a, self.b, self.c, self.d)
        
    # returns the conjugate of the given Quaternion
    @property
    def conjugate(self):
        return Quaternion(self.a, -self.b, -self.c, -self.d)

    # overrides the __add__ function to add the individual coefficients of Quaternion
    def __add__(self, other):
        if isinstance(other, Quaternion):
            new_quaternion = Quaternion(self.a + other.a, self.b + other.b, self.c + other.c, self.d + other.d)
            return new_quaternion
            
    # overrides the __eq__ function to compare the individual coefficients of Quaternion
    def __eq__(self, other):
        if isinstance(other, Quaternion):
            return self.a == other.a and self.b == other.b and self.c == other.c and self.d == other.d
        return False

    # overrides the __add__ function to carry out accurate Quaternion multiplication
    def __mul__(self, other):
        if isinstance(other, Quaternion):
            mult_a = (self.a * other.a) - (self.b * other.b) - (self.c * other.c) - (self.d * other.d)
            mult_b = (self.a * other.b) + (self.b * other.a) + (self.c * other.d) - (self.d * other.c)
            mult_c = (self.a * other.c) - (self.b * other.d) + (self.c * other.a) + (self.d * other.b)
            mult_d = (self.a * other.d) + (self.b * other.c) - (self.c * other.b) + (self.d * other.a)
            mult_quat = Quaternion(mult_a, mult_b, mult_c, mult_d)
            return mult_quat
    
    # overrides the __str__ function to turn a Quaternion into a string of operations
    def __str__(self):
        set_of_values: list[tuple[float, str]] = [(self.b, "i"), (self.c, "j"), (self.d, "k")]
        total: str = ""

        # handles the case of a Quaternion with all 0 coefficients
        if self.a == 0 and self.b == 0 and self.c == 0 and self.d == 0:
            return "0"
        
        # handles the real number in the expression
        if self.a != 0:
            total += f"{self.a}"

        # loop that handles the imaginary numbers in the expression
        for (val, letter) in set_of_values:

            # positive coefficient that is not 1
            if val > 0 and val != 1:
                if total == "": 
                    total += f"{val}"
                    total += f"{letter}"
                else:
                    total += f"+{val}"
                    total += f"{letter}"
            
            # negative coefficient that is not -1
            elif val < 0 and val != -1:
                total += f"{val}"
                total += f"{letter}"
            
            # coefficient of 1
            elif val == 1:
                if total == "":
                    total += f"{letter}"
                else:
                    total += f"+{letter}"

            # coefficient of -1
            elif val == -1:
                total += f"-{letter}"
        return total