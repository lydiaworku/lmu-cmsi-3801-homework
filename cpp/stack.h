#include <algorithm>
#include <memory>
#include <stdexcept>
#include <string>
using namespace std;

#define MAX_CAPACITY 32768
#define INITIAL_CAPACITY 16

template <typename T> class Stack {
  unique_ptr<T[]> elements; // Smart pointer to the array of elements
  int capacity;             // Current capacity of the array
  int top;                  // Index of the next available slot

  // Prohibit copying and assignment
  Stack(const Stack<T> &) = delete;
  Stack<T> &operator=(const Stack<T> &) = delete;

public:
  Stack()
      : elements(make_unique<T[]>(INITIAL_CAPACITY)),
        capacity(INITIAL_CAPACITY), top(0) {}

  int size() const { return top; }

  bool is_empty() const { return top == 0; }

  bool is_full() const { return top == MAX_CAPACITY; }

  void push(T item) {
    if (is_full()) {
      throw overflow_error("Stack has reached maximum capacity");
    }
    if (top == capacity) {
      reallocate(min(2 * capacity, MAX_CAPACITY));
    }
    elements[top++] = item;
  }

  T pop() {
    if (is_empty()) {
      throw underflow_error("cannot pop from empty stack");
    }

    T popped_item = elements[--top]; // Retrieve the top element
    elements[top] = T();             // Clear the slot (for security)

    // Shrink the stack if the size is <= 1/4 of the capacity, but not below
    // INITIAL_CAPACITY
    if (capacity > INITIAL_CAPACITY && top <= capacity / 4) {
      reallocate(max(capacity / 2, INITIAL_CAPACITY));
    }

    return popped_item;
  }

private:
  void reallocate(int new_capacity) {
    if (new_capacity > MAX_CAPACITY || new_capacity < INITIAL_CAPACITY) {
      return; // Do nothing if the new capacity is invalid
    }

    // Allocate a new array with the new capacity
    unique_ptr<T[]> new_elements = make_unique<T[]>(new_capacity);

    // Copy elements from the old array to the new array
    copy(&elements[0], &elements[top], &new_elements[0]);

    // Transfer ownership of the new array to the stack
    elements = std::move(new_elements);
    capacity = new_capacity;
  }
};
