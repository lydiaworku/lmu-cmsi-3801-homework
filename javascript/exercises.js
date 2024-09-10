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
