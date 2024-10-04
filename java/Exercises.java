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

    // converts the string into a stream, then applies the predicate and turns the
    // first letter lowercase
    static Optional<String> firstThenLowerCase(List<String> strings, Predicate<String> predicate) {
        return strings.stream()
                .filter(predicate)
                .findFirst()
                .map(String::toLowerCase);
    }

    static record Sayer(String phrase) {

        // appends words to the given phrase
        Sayer and(String word) {
            return new Sayer(this.phrase + " " + word);
        }
    }

    // initializes Sayer with an empty phrase
    public static Sayer say() {
        return new Sayer("");
    }

    // initializes Sayer with a given phrase

    public static Sayer say(String word) {
        return new Sayer(word);
    }

    public static int meaningfulLineCount(String filename) throws IOException {
        try (var reader = new BufferedReader(new FileReader(filename))) {
            return (int) reader.lines()
                    .map(String::trim) // trims whitespace
                    .filter(line -> !line.isBlank() && !line.startsWith("#")) // doesn't count blank lines or lines that
                                                                              // start with #
                    .count();
        }
    }

}

record Quaternion(double a, double b, double c, double d) {

    // initializes quaternions with set values
    public final static Quaternion ZERO = new Quaternion(0, 0, 0, 0);
    public final static Quaternion I = new Quaternion(0, 1, 0, 0);
    public final static Quaternion J = new Quaternion(0, 0, 1, 0);
    public final static Quaternion K = new Quaternion(0, 0, 0, 1);

    // throws errors if any of a, b, c, d are NaN
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
                a * other.d + b * other.c - c * other.b + d * other.a);
    }

    public Quaternion conjugate() {
        return new Quaternion(a, -b, -c, -d);
    }

    public List<Double> coefficients() {
        return List.of(a, b, c, d);
    }

    // overrides the toString method to add coefficients to variables
    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();

        // ZERO case
        if (a == 0 && b == 0 && c == 0 && d == 0) {
            return "0";
        }

        if (a != 0) {
            sb.append(a);
        }

        appendComponent(sb, b, "i");
        appendComponent(sb, c, "j");
        appendComponent(sb, d, "k");

        return sb.toString();
    }

    // takes care of the addition/subtraction within quaternions for toString
    private void appendComponent(StringBuilder sb, double value, String symbol) {
        if (value != 0) {
            if (sb.length() > 0) {
                sb.append(value > 0 ? "+" : "");
            }
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

sealed interface BinarySearchTree permits Empty, Node {
    int size();

    boolean contains(String value);

    BinarySearchTree insert(String value);
}

// takes care of the case of an empty node in the BST
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

// holds a value, left subtree, and right subtree
final class Node implements BinarySearchTree {
    private final String value;
    private final BinarySearchTree left;
    private final BinarySearchTree right;

    // initializes the default values of the left, right, and value variables
    Node(String value, BinarySearchTree left, BinarySearchTree right) {
        this.value = value;
        this.left = left;
        this.right = right;
    }

    @Override
    public int size() {
        return 1 + left.size() + right.size();
    }

    // checks if the BST contains a given value
    @Override
    public boolean contains(String value) {
        return this.value.equals(value) || left.contains(value) || right.contains(value);
    }

    // inserts a value into the BST
    @Override
    public BinarySearchTree insert(String value) {
        if (value.compareTo(this.value) < 0) {
            return new Node(this.value, left.insert(value), right);
        } else if (value.compareTo(this.value) > 0) {
            return new Node(this.value, left, right.insert(value));
        }
        return this;
    }

    // overrides the toString method and adds parentheses to strings
    @Override
    public String toString() {
        String leftStr = left instanceof Empty ? "" : left.toString();
        String rightStr = right instanceof Empty ? "" : right.toString();
        return "(" + leftStr + value + rightStr + ")";
    }
}
