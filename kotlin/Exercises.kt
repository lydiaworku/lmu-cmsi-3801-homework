import java.io.BufferedReader
import java.io.FileReader
import java.io.IOException

fun change(amount: Long): Map<Int, Long> {
    require(amount >= 0) { "Amount cannot be negative" }
    
    val counts = mutableMapOf<Int, Long>()
    var remaining = amount
    for (denomination in listOf(25, 10, 5, 1)) {
        counts[denomination] = remaining / denomination
        remaining %= denomination
    }
    return counts
}

fun firstThenLowerCase(strings: List<String>, predicate: (String) -> Boolean): String? {
    return strings.firstOrNull(predicate)?.lowercase()
}

data class Say(val phrase: String) {
    fun and(nextPhrase: String): Say {
        return Say("$phrase $nextPhrase")
    }
}
fun say(phrase: String = ""): Say {
    return Say(phrase)
}

@Throws(IOException::class)
fun meaningfulLineCount(filename: String): Long {
    BufferedReader(FileReader(filename)).use { reader ->
    return reader.lines().filter { it.trim().isNotEmpty() && !it.trim().startsWith("#") }.count()  // Exclude empty lines and lines starting with #

}
}


data class Quaternion(val a: Double, val b: Double, val c: Double, val d: Double) {

    companion object {
        val ZERO = Quaternion(0.0, 0.0, 0.0, 0.0)
        val I = Quaternion(0.0, 1.0, 0.0, 0.0)
        val J = Quaternion(0.0, 0.0, 1.0, 0.0)
        val K = Quaternion(0.0, 0.0, 0.0, 1.0)
    }

    operator fun plus(other: Quaternion): Quaternion {
        return Quaternion(a + other.a, b + other.b, c + other.c, d + other.d)
    }

    operator fun times(other: Quaternion): Quaternion{
        return Quaternion(
            a * other.a - b * other.b - c * other.c - d * other.d,
            a * other.b + b * other.a + c * other.d - d * other.c,
            a * other.c - b * other.d + c * other.a + d * other.b,
            a * other.d + b * other.c - c * other.b + d * other.a
        )
    }

    fun coefficients(): List<Double> = listOf(a, b, c, d)
    
    fun conjugate(): Quaternion = Quaternion(a, -b, -c, -d)

    override fun toString(): String {
        val sb = StringBuilder()
    
        if (a == 0.0 && b == 0.0 && c == 0.0 && d == 0.0) {
            return "0"
        }
    
        if (a != 0.0) {
            sb.append(a)
        }
    
        appendComponent(sb, b, "i")
        appendComponent(sb, c, "j")
        appendComponent(sb, d, "k")
    
        return sb.toString()
    }
    
    private fun appendComponent(sb: StringBuilder, value: Double, symbol: String) {
        if (value != 0.0) {
            if (sb.isNotEmpty()) {
                sb.append(if (value > 0) "+" else "")
            }
            when {
                value == 1.0 -> sb.append(symbol)
                value == -1.0 -> sb.append("-").append(symbol)
                else -> sb.append(value).append(symbol)
            }
        }
    }
}

sealed interface BinarySearchTree {
    fun size(): Int
    fun contains(value: String): Boolean
    fun insert(value: String): BinarySearchTree

    object Empty : BinarySearchTree {
        override fun size(): Int = 0
        override fun contains(value: String): Boolean = false
        override fun insert(value: String): BinarySearchTree = Node(value, Empty, Empty)

        override fun toString(): String = "()"
    }

    data class Node(private val value: String, private val left: BinarySearchTree, private val right: BinarySearchTree) : BinarySearchTree {
        override fun size(): Int = 1 + left.size() + right.size()

        override fun contains(value: String): Boolean = when {
            value < this.value -> left.contains(value)
            value > this.value -> right.contains(value)
            else -> true
        }

        override fun insert(value: String): BinarySearchTree = when {
            value < this.value -> Node(this.value, left.insert(value), right)
            value > this.value -> Node(this.value, left, right.insert(value))
            else -> this
        }

        override fun toString(): String {
            val leftStr = if (left is Empty) "" else "$left"
            val rightStr = if (right is Empty) "" else "$right"
            return "($leftStr$value$rightStr)"
        }
    }
}
