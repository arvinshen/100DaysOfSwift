import UIKit

// Challenges
// 1. Create a String extension that adds a withPrefix() method. If the string already contains the prefix it should return itself; if it doesn't contain the prefix, it should return itself with the prefix added.
extension String {
    func withPrefix(prefix: String) -> String {
        return self.hasPrefix(prefix) ? self : prefix + self
    }
}

"pet".withPrefix(prefix: "car")
"carpet".withPrefix(prefix: "car")

// 2. Create a String extension that adds an isNumeric property that returns true if the string holds any sort of number. (i.e. isNumeric is true if either an Int or Double)
extension String {
    var isNumeric: Bool {
        return (Double(self) != nil) == true
    }
}

"1".isNumeric
"1.0".isNumeric
"One".isNumeric
"One is 1".isNumeric

// 3. Create a String extension that adds a lines property that returns an array of all the lines in a string.
extension String {
    var lines: [String] {
        return self.components(separatedBy: "\n")
    }
}

"this\nis\na\ntest".lines
