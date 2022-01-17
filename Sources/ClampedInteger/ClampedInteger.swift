
/**
 * An Integer type that clamps its value to its minimum and maximum, instead of overflowing.
 *
 * For example:
 *
 * ```
 *     let a = ClampedInteger<Int>.max
 *     if a == a + 1 { print("Clamped!") } // this prints Clamped!
 * ```
 * Minus, Plus and Multiplication have a custom *clamping* implementation. All other operations
 * are forwarded to the Wrapped integer type.
 *
 */
struct ClampedInteger<Base> where Base: FixedWidthInteger {
    var value: Base
}

/// Set Int as the default Base generic parameter type
extension ClampedInteger where Base == Int {
    init(integerLiteral value: Int.IntegerLiteralType) {
        self.value = Int(integerLiteral: value)
    }

    static var zero: ClampedInteger<Int> { ClampedInteger(value: .zero) }

    static var min: ClampedInteger<Int> { ClampedInteger(value: .min) }

    static var max: ClampedInteger<Int> { ClampedInteger(value: .max) }
}

extension ClampedInteger: AdditiveArithmetic {
    static func - (lhs: ClampedInteger, rhs: ClampedInteger) -> ClampedInteger {
        // Overflow test when lhs > rhs:
        //
        //   lhs - rhs >= .max  =>  lhs >= .max + rhs
        //
        // Underflow test when lhs < rhs:
        //
        //  lhs - rhs < .min  =>  lhs < .min + rhs

        if lhs.value > rhs.value && rhs.value < 0 && lhs.value >= .max + rhs.value {
            return Self(value: .max)
        } else if lhs.value < rhs.value && rhs.value > 0 && lhs.value < .min + rhs.value {
            return Self(value: .min)
        } else {
            return Self(lhs.value - rhs.value)
        }
    }

    static func + (lhs: ClampedInteger, rhs: ClampedInteger) -> ClampedInteger {
        if lhs.value > 0 && rhs.value > Base.max - lhs.value {
            return Self(value: Base.max)
        } else if lhs.value < 0 && rhs.value < Base.min - lhs.value {
            return Self(value: .min)
        } else {
            return Self(lhs.value + rhs.value)
        }
    }
}

extension ClampedInteger {
    static func * (lhs: ClampedInteger, rhs: ClampedInteger) -> ClampedInteger {
        if rhs.value == .zero { return .zero }

        let result = rhs.value &* lhs.value

        if lhs.value == result / rhs.value {
            return Self(result)
        } else if (lhs.value > .zero) == (rhs.value > .zero) {
            return Self(value: .max)
        } else {
            return Self(value: .min)
        }
    }

    static func *= (lhs: inout ClampedInteger, rhs: ClampedInteger) {
        lhs = lhs * rhs
    }
}
