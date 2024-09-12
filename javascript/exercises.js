import { open } from "fs/promises"


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
  for (let index of a) {
      if (p(index)) {
          return index?.toLowerCase();
      }
  }
  return undefined;
}


// Write your powers generator here
export function* powersGenerator({ofBase, upTo}) {
  let power = 0;
  let result = 0;

  while (result < upTo) {
    result = Math.pow(ofBase, power);
    power ++ ;
    if (result <= upTo) {
      yield result;
    }

  }
}

// Write your say function here
export function say(word = null) {
  if (word === null) {
      return "";
  } else {
      return function(nextWord = null) {
          return nextWord !== null ? say(word + " " + nextWord) : word;
      };
  }
}

// Write your line count function here


export async function meaningfulLineCount(filename) {
  let fileHandle; 

  try {
    const fileHandle = await open(filename, 'r');
    const fileContents = await fileHandle.readFile('utf-8');
    const theLines = fileContents.split('\n');
    let count = 0;

    for (let line of theLines) {
      const stripLine = line.trim()
      if (stripLine && !stripLine.startsWith('#')) {
        count += 1;
      }
    }

    return count;

  } catch (err) {
    if (err.code === 'ENOENT') {
      throw new Error(`No such file '${filename}'`);
    }
    throw err;
    
  } finally {
    if (fileHandle) {
        await fileHandle.close(); 
    }
}
}



// Write your Quaternion class here

export class Quaternion {
  constructor(a, b, c, d) {
      this.a = a;
      this.b = b;
      this.c = c;
      this.d = d;
      Object.freeze(this); // freezing the objects upn construction
  }

  get coefficients() { // getter method for coefficients
      return [this.a, this.b, this.c, this.d];
  }

  get conjugate() { // getter method for conjugates
      return new Quaternion(this.a, -this.b, -this.c, -this.d);
  }

  plus(other) {
      if (other instanceof Quaternion) {
          return new Quaternion(
              this.a + other.a,
              this.b + other.b,
              this.c + other.c,
              this.d + other.d
          );
      }
      throw new TypeError('Argument must be an instance of Quaternion');
  }

  equals(other) {
      if (other instanceof Quaternion) {
          return (
              this.a === other.a &&
              this.b === other.b &&
              this.c === other.c &&
              this.d === other.d
          );
      }
      return false;
  }

  times(other) {
      if (other instanceof Quaternion) {
          const a = (this.a * other.a) - (this.b * other.b) - (this.c * other.c) - (this.d * other.d);
          const b = (this.a * other.b) + (this.b * other.a) + (this.c * other.d) - (this.d * other.c);
          const c = (this.a * other.c) - (this.b * other.d) + (this.c * other.a) + (this.d * other.b);
          const d = (this.a * other.d) + (this.b * other.c) - (this.c * other.b) + (this.d * other.a);
          return new Quaternion(a, b, c, d);
      }
      throw new TypeError('Argument must be an instance of Quaternion');
  }

  toString() {
      let total = "";

      if (this.a === 0 && this.b === 0 && this.c === 0 && this.d === 0) {
        return "0";
    }
    
    if (this.a !== 0) {
        total += `${this.a}`;
    }

    const setOfValues = [
      [this.b, 'i'],
      [this.c, 'j'],
      [this.d, 'k']
  ];

    for (const [val, letter] of setOfValues) {
        if (val > 0 && val !== 1) {
            if (total === "") {
                total += `${val}`;
                total += `${letter}`;
            } else {
                total += `+${val}`;
                total += `${letter}`;
            }
        } else if (val < 0 && val !== -1) {
            total += `${val}`;
            total += `${letter}`;
        } else if (val === 1) {
            if (total === "") {
                total += `${letter}`;
            } else {
                total += `+${letter}`;
            }
        } else if (val === -1) {
            total += `-${letter}`;
        }
    }
    
    
    return total;
  }
}
