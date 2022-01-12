import UIKit

// Consolidation Project 8: Swift Extensions

// 1. Extend UIView so that it has a bounceOut(duration:) method that uses animation to scale its size down to 0.0001 over a specified number of seconds.
extension UIView {
    func bounceOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: []) {
            [unowned self] in
            self.transform = CGAffineTransform(scaleX: 0.0001, y: 0.0001)
        }
    }
}

let view = UIView()
view.bounceOut(duration: 3)

// 2. Extend Int with a times() method that runs a closure as many times as the number is high.
extension Int {
    func times(_ closure: () -> Void) {
        guard self > 0 else { return }
        for _ in 0..<self {
            closure()
        }
    }
}

5.times { print("Hello!") } // will print "Hello" five times.

// 3. Extend Array so that it has a mutating remove(item:) method. If the item exists more than once, it should remove only the first instance it find.
extension Array where Element: Comparable {
    mutating func remove(item: Element) {
        guard self.count > 1 else { return }
        var itemCount = 0
        for element in self {
            if element == item {
                itemCount += 1
                if itemCount > 1 {
                    if let index = self.firstIndex(of: item) {
                        self.remove(at: index)
                        return
                    }
                }
            }
        }
    }
}

var numbers = [1, 2, 3, 4, 5]
numbers.remove(item: 3)
print(numbers)  // [1, 2, 3, 4, 5]

numbers = [1, 2, 3, 3, 3, 4, 5]
numbers.remove(item: 3)
print(numbers)  // [1, 2, 3, 3, 4, 5]

