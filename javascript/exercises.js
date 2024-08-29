import { open } from "node:fs/promises"

export function change(amount) {
  if (!Number.isInteger(amount)) {
    throw new TypeError("Amount must be an integer")
  }
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative")
  }
  let [counts, remaining] = [{}, amount]
  for (const denomination of [25, 10, 5, 1]) {
    counts[denomination] = Math.floor(remaining / denomination)
    remaining %= denomination
  }
  return counts
}

export function firstThenLowerCase(a, p) {
  for (let index = 0; index < a.length; index++) {
    const element = a[index];
    if (p(element)) {
      return a[index].toLowerCase();
    }
  return None

  }
}
// Write your powers generator here

// Write your say function here

// Write your line count function here

// Write your Quaternion class here
