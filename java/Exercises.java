import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Optional;
import java.util.function.Predicate;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

public class Exercises {
    static Map<Integer, Long> change(long amount) {
        if (amount < 0) {
            throw new IllegalArgumentException("Amount cannot be negative");
        }
        var counts = new HashMap<Integer, Long>();
        for (var denomination : List.of(25, 10, 5, 1)) {
            counts.put(denomination, amount / denomination);
            amount %= denomination;
        }
        return counts;
    }

    // Write your first then lower case function here

    static Optional<String> firstThenLowerCase(List<String> a, Predicate<String> p) {
        return a.stream() // converts a into a stream
                .filter(p) // applies p to each item in the stream
                .findFirst() // finds the first letter in the string
                .map(String::toLowerCase); // turns the letter lowercase
    }


    // Write your say function here


    public static class Chainable {
        private StringBuilder accumulatedString;

        // Constructor for an initial word
        public Chainable(String word) {
            accumulatedString = new StringBuilder(word);
        }

        // Default constructor for empty chain
        public Chainable() {
            accumulatedString = new StringBuilder();
        }

        // Method to add a word to the chain
        public Chainable and(String word) {
            if (accumulatedString.length() > 0 && word.length() > 0) {
                accumulatedString.append(" ");
            } else if (accumulatedString.length() > 0 && word.length() == 0) {
                accumulatedString.append(" ");
            }
            accumulatedString.append(word);
            return this;
        }

        // Read-only property to get the accumulated string
        public String phrase() {
            return accumulatedString.toString();
        }
    }

    // Static method to create a Chainable object
    public static Chainable say(String word) {
        return new Chainable(word);
    }

    // Overloaded method to create an empty Chainable object
    public static Chainable say() {
        return new Chainable();
    }

    // Write your line count function here
}

// Write your Quaternion record class here

// Write your BinarySearchTree sealed interface and its implementations here
