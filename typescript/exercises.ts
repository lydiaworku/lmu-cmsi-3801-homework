import { open } from "node:fs/promises"

export function change(amount: bigint): Map<bigint, bigint> {
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative")
  }
  let counts: Map<bigint, bigint> = new Map()
  let remaining = amount
  for (const denomination of [25n, 10n, 5n, 1n]) {
    counts.set(denomination, remaining / denomination)
    remaining %= denomination
  }
  return counts
}

export function firstThenApply<T, U>(
  items: T[], 
  predicate: (item: T) => boolean, 
  consumer: (item: T) => U
): U | undefined {
  const foundItem = items.find(predicate);
  return foundItem ? consumer(foundItem) : undefined;
}


export function* powersGenerator(base: bigint): Generator<BigInt> {
  for (let power = 1n; ; power *= base) {
    yield power
  }
}


export async function meaningfulLineCount(filename: string): Promise<number> {
  let file: any;

  try {
    // Opens the file, reads its content, and splits into lines
    file = await open(filename, 'r');
    const fileContents = await file.readFile('utf-8');
    const theLines = fileContents.split('\n');
    let count = 0;

    // Counts non-empty, non-comment lines
    for (const line of theLines) {
      const stripLine = line.trim();
      if (stripLine && !stripLine.startsWith('#')) {
        count += 1;
      }
    }

    return count;

  } catch (err: any) {
    // Handles file not found error
    if (err.code === 'ENOENT') {
      throw new Error(`No such file '${filename}'`);
    }
    throw err;

  } finally {
    // Closes the file if it was successfully opened
    if (file) {
      await file.close();
    }
  }
}

interface Sphere {
  kind: "Sphere"
  radius: number
}

interface Box {
  kind: "Box"
  width: number
  length: number
  depth: number
}

export type Shape = Sphere | Box

export function surfaceArea(shape: Shape): number {
  switch (shape.kind) {
    case "Sphere":
      return 4 * Math.PI * shape.radius ** 2
    case "Box":
      return 2 * (shape.width * shape.length + shape.width * shape.depth + shape.length * shape.depth)
  }
}

export function volume(shape: Shape): number {
  switch (shape.kind) {
    case "Sphere":
      return (4 / 3) * Math.PI * shape.radius ** 3;
    case "Box":
      return shape.width * shape.length * shape.depth
  }
}


// Define the Comparator type for comparing two values of type T
export type Comparable<T> = (a: T, b: T) => number;

// Default comparator function that assumes T can be compared with '<' and '>'
const defaultComparator = <T>(a: T, b: T): number => {
  if (a < b) return -1;
  if (a > b) return 1;
  return 0;
};

// Define the BinarySearchTree interface
export interface BinarySearchTree<T> {
  size(): number;
  insert(value: T): BinarySearchTree<T>;
  contains(value: T): boolean;
  inorder(): Iterable<T>;
  toString(): string;
}

// Implementation of the Empty class (represents an empty node in the tree)
export class Empty<T> implements BinarySearchTree<T> {
  constructor(private comparator: Comparable<T> = defaultComparator) {}

  size(): number {
    return 0;
  }

  insert(value: T): BinarySearchTree<T> {
    // Create a new node with value and comparator when inserting into an empty tree
    return new Node(value, new Empty(this.comparator), new Empty(this.comparator), this.comparator);
  }

  contains(value: T): boolean {
    return false;
  }

  *inorder(): Iterable<T> {
    return;
  }

  toString(): string {
    return "()";
  }
}

// Implementation of the Node class (represents a node with a value in the tree)
class Node<T> implements BinarySearchTree<T> {
  constructor(
    private value: T,
    private left: BinarySearchTree<T>,
    private right: BinarySearchTree<T>,
    private comparator: Comparable<T>
  ) {}

  size(): number {
    return 1 + this.left.size() + this.right.size();
  }

  insert(value: T): BinarySearchTree<T> {
    const comp = this.comparator(value, this.value);
    if (comp < 0) {
      // Insert on the left side
      return new Node(this.value, this.left.insert(value), this.right, this.comparator);
    } else if (comp > 0) {
      // Insert on the right side
      return new Node(this.value, this.left, this.right.insert(value), this.comparator);
    }
    // No duplicates allowed, return unchanged node
    return this;
  }

  contains(value: T): boolean {
    const comp = this.comparator(value, this.value);
    if (comp === 0) return true;
    if (comp < 0) return this.left.contains(value);
    return this.right.contains(value);
  }

  *inorder(): Iterable<T> {
    yield* this.left.inorder();
    yield this.value;
    yield* this.right.inorder();
  }

  toString(): string {
    const leftStr = this.left.toString();
    const rightStr = this.right.toString();
    return `(${leftStr === "()" ? "" : leftStr}${this.value}${rightStr === "()" ? "" : rightStr})`;
  }
}

// Factory function to create a new BinarySearchTree with a required comparator
export function createTree<T>(comparator?: Comparable<T>): BinarySearchTree<T> {
  return new Empty(comparator);
}

// Conditional export for testing
if (typeof module !== 'undefined' && module.exports) {
  module.exports = { createTree, Node, Empty };
}