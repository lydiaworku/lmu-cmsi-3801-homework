import Foundation

struct NegativeAmountError: Error {}
struct NoSuchFileError: Error {}

func change(_ amount: Int) -> Result<[Int:Int], NegativeAmountError> {
    if amount < 0 {
        return .failure(NegativeAmountError())
    }
    var (counts, remaining) = ([Int:Int](), amount)
    for denomination in [25, 10, 5, 1] {
        (counts[denomination], remaining) = 
            remaining.quotientAndRemainder(dividingBy: denomination)
    }
    return .success(counts)
}


func firstThenLowerCase(of strings: [String], satisfying predicate: (String) -> Bool) -> String? {
    return strings.first(where: predicate)?.lowercased()
}

struct Sayer {
    let phrase: String
    func and(_ nextPhrase: String) -> Sayer {
        return Sayer(phrase: phrase + " " + nextPhrase)
    }
}

func say(_ word: String = "") -> Sayer {
    return Sayer(phrase: word)
}


// The function remains synchronous
// The function remains synchronous
func meaningfulLineCount(_ filename: String) async -> Result<Int, NoSuchFileError> {
    guard let contents = try? String(contentsOfFile: filename) else {
        return .failure(NoSuchFileError())
    }

    // Filter out lines that are empty or start with '#' after removing leading spaces
    let meaningfulLines = contents.split(separator: "\n").filter { line in
        let leadingTrimmed = line.drop(while: { $0.isWhitespace })
        return !leadingTrimmed.isEmpty && !leadingTrimmed.hasPrefix("#")
    }

    return .success(meaningfulLines.count)
}

struct Quaternion: CustomStringConvertible, Equatable {
    let a, b, c, d: Double

    static let ZERO = Quaternion(a: 0, b: 0, c: 0, d: 0)
    static let I = Quaternion(a: 0, b: 1, c: 0, d: 0)
    static let J = Quaternion(a: 0, b: 0, c: 1, d: 0)
    static let K = Quaternion(a: 0, b: 0, c: 0, d: 1)

    init(a: Double = 0, b: Double = 0, c: Double = 0, d: Double = 0) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }

    var coefficients: [Double] {
        return [a, b, c, d]
    }

    var conjugate: Quaternion {
        return Quaternion(a: a, b: -b, c: -c, d: -d)
    }

    static func +(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        return Quaternion(a: lhs.a + rhs.a, b: lhs.b + rhs.b, c: lhs.c + rhs.c, d: lhs.d + rhs.d)
    }

    static func *(lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        let a = lhs.a * rhs.a - lhs.b * rhs.b - lhs.c * rhs.c - lhs.d * rhs.d
        let b = lhs.a * rhs.b + lhs.b * rhs.a + lhs.c * rhs.d - lhs.d * rhs.c
        let c = lhs.a * rhs.c - lhs.b * rhs.d + lhs.c * rhs.a + lhs.d * rhs.b
        let d = lhs.a * rhs.d + lhs.b * rhs.c - lhs.c * rhs.b + lhs.d * rhs.a
        return Quaternion(a: a, b: b, c: c, d: d)
    }

    var description: String {

        if a == 0 && b == 0 && c == 0 && d == 0 {
            return "0"
        }

        var result = ""

        if a != 0 {
            result += "\(a)"
        }

        if b != 0 {
            result += (result.isEmpty ? "" : (b > 0 ? "+" : "")) + (b == 1 ? "i" : (b == -1 ? "-i" : "\(b)i"))
        }
        if c != 0 {
            result += (result.isEmpty ? "" : (c > 0 ? "+" : "")) + (c == 1 ? "j" : (c == -1 ? "-j" : "\(c)j"))
        }
        if d != 0 {
            result += (result.isEmpty ? "" : (d > 0 ? "+" : "")) + (d == 1 ? "k" : (d == -1 ? "-k" : "\(d)k"))
        }

        return result
    }
}

indirect enum BinarySearchTree: CustomStringConvertible {
    case empty
    case node(String, BinarySearchTree, BinarySearchTree)

    var size: Int {
        switch self {
            case .empty:
                return 0
            case let .node(_, left, right):
                return 1 + left.size + right.size
        }
    }

    func contains(_ value: String) -> Bool {
        switch self {
            case .empty:
                return false
            case let .node(v, left, right):
                if value < v {
                    return left.contains(value)
                } else if value > v {
                    return right.contains(value)
                } else {
                    return true
                }
        }
    }

    func insert(_ value: String) -> BinarySearchTree {
        switch self {
            case .empty:
                return .node(value, .empty, .empty)
            case let .node(v, left, right):
                if value < v {
                    return .node(v, left.insert(value), right)
                } else if value > v {
                    return .node(v, left, right.insert(value))
                } else {
                    return self
                }
        }
    }

    var description: String {
        switch self {
            case .empty:
                return "()"
            case let .node(value, left, right):
                let leftStr = left.size == 0 ? "" : "\(left)"
                let rightStr = right.size == 0 ? "" : "\(right)"
                return "(\(leftStr)\(value)\(rightStr))"
        }
    }
}
