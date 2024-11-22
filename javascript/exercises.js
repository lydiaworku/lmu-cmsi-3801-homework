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

// Write your first then lower case function here

// loops through the list of strings, a, and, if the string satisfies p, returns the lowercase version of a
export function firstThenLowerCase(a, p) {
  for (let index of a) {
      if (p(index)) {
         // uses the optional chaining operator to only call toLowerCase if index exists
          return index?.toLowerCase();
      }
  }
  return undefined;
}


// Write your powers generator here
export function* powersGenerator({ofBase, upTo}) { // function uses destructuring of obj argument
  let power = 0;
  let result = 0; // variables representing the exponent and the result of each calculation

  // while the result is less than or equal to the limit, calculations are done
  while (result < upTo) {
    result = Math.pow(ofBase, power);
    power ++ ;
    // if the result is still less than the limit after calculations, it is yielded
    if (result <= upTo) {
      yield result;
    }

  }
}

// Write your say function here
export function say(word = null) {
  // if word is null, the empty string is returned
  if (word === null) {
      return "";
  } else {
    // if not, word is appended to a space and the next word and the function is done recursively to this new word
      return function(nextWord = null) {
          return nextWord !== null ? say(word + " " + nextWord) : word;
      };
  }
}

// Write your line count function here
export async function meaningfulLineCount(filename) {
  let file; 

  try {
    // opens files, reads it, and separates the lines
    const file = await open(filename, 'r');
    const fileContents = await file.readFile('utf-8');
    const theLines = fileContents.split('\n');
    let count = 0;

    // loops through the lines and counts how many lines are not empty and don't start with '#'
    for (let line of theLines) {
      const stripLine = line.trim()
      if (stripLine && !stripLine.startsWith('#')) {
        count += 1;
      }
    }

    return count;

    // throws an error if the file is not found
  } catch (err) {
    if (err.code === 'ENOENT') {
      throw new Error(`No such file '${filename}'`);
    }
    throw err;
  
    // closes the file
  } finally {
    if (file) {
        await file.close(); 
    }
}
}


// Write your Quaternion class here

export class Quaternion {
  // constructor for the Quaternion class
  constructor(a, b, c, d) {
      this.a = a;
      this.b = b;
      this.c = c;
      this.d = d;
      Object.freeze(this); // freezing the objects upn construction
  }
  // getter method for coefficients
  get coefficients() { 
      return [this.a, this.b, this.c, this.d];
  }

  // getter method for conjugates
  get conjugate() { 
      return new Quaternion(this.a, -this.b, -this.c, -this.d);
  }

  // plus method to add two Quaternions by their coefficients
  plus(other) {
      if (other instanceof Quaternion) {
          return new Quaternion(
              this.a + other.a,
              this.b + other.b,
              this.c + other.c,
              this.d + other.d
          );
      }
      // throws an error if the argument is not a Quaternion
      throw new TypeError('Argument must be an instance of Quaternion');
  }

  // equals method to compare two quaternions by their coefficients
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

  // times method to accurately multiply two quaternions
  times(other) {
      if (other instanceof Quaternion) {
          const a = (this.a * other.a) - (this.b * other.b) - (this.c * other.c) - (this.d * other.d);
          const b = (this.a * other.b) + (this.b * other.a) + (this.c * other.d) - (this.d * other.c);
          const c = (this.a * other.c) - (this.b * other.d) + (this.c * other.a) + (this.d * other.b);
          const d = (this.a * other.d) + (this.b * other.c) - (this.c * other.b) + (this.d * other.a);
          return new Quaternion(a, b, c, d);
      }
      // throws an error if the argument is not a Quaternion
      throw new TypeError('Argument must be an instance of Quaternion');
  }

  // toString method that turns a Quaternion into a string of operations
  toString() {
      let total = "";

      // handles the case of all 0 coeffients
      if (this.a === 0 && this.b === 0 && this.c === 0 && this.d === 0) {
        return "0";
    }
    
    // handles the real number in the equation
    if (this.a !== 0) {
        total += `${this.a}`;
    }

    // set of values and their corresponding letter
    const setOfValues = [
      [this.b, 'i'],
      [this.c, 'j'],
      [this.d, 'k']
  ];

  // loop that handles the imaginary numbers in the equation
    for (const [val, letter] of setOfValues) {

        // positive coefficient that is not 1
        if (val > 0 && val !== 1) {
            if (total === "") {
                total += `${val}`;
                total += `${letter}`;
            } else {
                total += `+${val}`;
                total += `${letter}`;
            }

        // negative coefficient that is not -1
        } else if (val < 0 && val !== -1) {
            total += `${val}`;
            total += `${letter}`;

        // coefficient of 1
        } else if (val === 1) {
            if (total === "") {
                total += `${letter}`;
            } else {
                total += `+${letter}`;
            }
        // coefficient of -1
        } else if (val === -1) {
            total += `-${letter}`;
        }
    }
    return total;
  }
}
