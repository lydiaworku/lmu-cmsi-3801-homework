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

    static Optional<String> firstThenLowerCase(List<String> strings, Predicate<String> predicate) {
        return strings.stream() // converts a into a stream
                .filter(predicate) // applies p to each item in the stream
                .findFirst() // finds the first letter in the string
                .map(String::toLowerCase); // turns the letter lowercase
    }


    // Write your say function here


    static record Sayer(String phrase) {

        Sayer and(String word) {
            return new Sayer(this.phrase + " " + word);
        }
    }
    
    public static Sayer say() {
        return new Sayer("");
    }
    
    public static Sayer say(String word) {
        return new Sayer(word);
    }
    

    // Write your line count function here

    public static int meaningfulLineCount(String filename) throws IOException {
        try (var reader = new BufferedReader(new FileReader(filename))) {
            return (int) reader.lines()
                    .map(String::trim)
                    .filter(line -> !line.isBlank() && !line.startsWith("#"))
                    .count();
        }
    }

}


// Write your Quaternion record class here


record Quaternion(double a, double b, double c, double d) {

    public final static Quaternion ZERO = new Quaternion(0, 0, 0, 0);
    public final static Quaternion I = new Quaternion(0, 1, 0, 0);
    public final static Quaternion J = new Quaternion(0, 0, 1, 0);
    public final static Quaternion K = new Quaternion(0, 0, 0, 1);

    public Quaternion {
        if (Double.isNaN(a) || Double.isNaN(b) || Double.isNaN(c) || Double.isNaN(d)) {
            throw new IllegalArgumentException("Coefficients cannot be NaN");
        }
    }

    Quaternion plus(Quaternion other) {
        return new Quaternion(a + other.a, b + other.b, c + other.c, d + other.d);
    }

    Quaternion times(Quaternion other) {
        return new Quaternion(
            a * other.a - b * other.b - c * other.c - d * other.d,
            a * other.b + b * other.a + c * other.d - d * other.c,
            a * other.c - b * other.d + c * other.a + d * other.b,
            a * other.d + b * other.c - c * other.b + d * other.a
        );
    }

    public Quaternion conjugate() {
        return new Quaternion(a, -b, -c, -d);
    }

    public List<Double> coefficients() {
        return List.of(a, b, c, d);
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();

        // If all coefficients are zero, return "0"
        if (a == 0 && b == 0 && c == 0 && d == 0) {
            return "0";
        }

        // Append the real part (a), if non-zero
        if (a != 0) {
            sb.append(a);
        }

        // Append imaginary parts with proper formatting
        appendComponent(sb, b, "i");
        appendComponent(sb, c, "j");
        appendComponent(sb, d, "k");

        return sb.toString();
    }

    private void appendComponent(StringBuilder sb, double value, String symbol) {
        if (value != 0) {
            // Handle sign for positive values and append value + symbol
            if (sb.length() > 0) {
                sb.append(value > 0 ? "+" : ""); // Only add a plus if there are already components
            }
            // Append coefficient and symbol, handling the special cases for 1 and -1
            if (value == 1) {
                sb.append(symbol);
            } else if (value == -1) {
                sb.append("-").append(symbol);
            } else {
                sb.append(value).append(symbol);
            }
        }
    }
}



// Write your BinarySearchTree sealed interface and its implementations here

sealed interface BinarySearchTree permits Empty, Node {
    int size();
    boolean contains(String value);
    BinarySearchTree insert(String value);
}

final record Empty() implements BinarySearchTree {
    
    @Override
    public int size() {
        return 0;
    }

    @Override
    public boolean contains(String value) {
        return false;
    }

    @Override
    public BinarySearchTree insert(String value) {
        return new Node(value, this, this);
    }

    @Override
    public String toString() {
        return "()";
    }

}

final class Node implements BinarySearchTree {
    private final String value;
    private final BinarySearchTree left;
    private final BinarySearchTree right;

    Node(String value, BinarySearchTree left, BinarySearchTree right) {
        this.value = value;
        this.left = left;
        this.right = right;
    }

    @Override
    public int size() {
        return 1 + left.size() + right.size();
    }

    @Override
    public boolean contains(String value) {
        return this.value.equals(value) || left.contains(value) || right.contains(value);
    }

    @Override
    public BinarySearchTree insert(String value) {
        if (value.compareTo(this.value) < 0) {
            return new Node(this.value, left.insert(value), right);
        } else if (value.compareTo(this.value) > 0) {
            return new Node(this.value, left, right.insert(value));
        }
        return this;  // If value is equal, return the current node (no duplicates)
    }

    @Override
    public String toString() {
        String leftStr = left instanceof Empty ? "" : left.toString();
        String rightStr = right instanceof Empty ? "" : right.toString();
        return "(" + leftStr + value + rightStr + ")";
    }
}


