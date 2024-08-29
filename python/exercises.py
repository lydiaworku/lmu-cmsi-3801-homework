from dataclasses import dataclass
from collections.abc import Callable
from typing import Optional


def change(amount: int) -> dict[int, int]:
    if not isinstance(amount, int):
        raise TypeError('Amount must be an integer')
    if amount < 0:
        raise ValueError('Amount cannot be negative')
    counts, remaining = {}, amount
    for denomination in (25, 10, 5, 1):
        counts[denomination], remaining = divmod(remaining, denomination)
    return counts


def first_then_lower_case(a: list[str], p: Callable[[str], bool]) -> Optional[str]:
    for a_string in a:
        if p(a_string):
            return a_string.lower()
    return None 


# Write your powers generator here


# Write your say function here


# Write your line count function here


# Write your Quaternion class here
