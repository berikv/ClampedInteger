
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
struct ClampedInteger<Base>: BinaryInteger where Base: FixedWidthInteger {
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
        let report = lhs.value.subtractingReportingOverflow(rhs.value)

        if report.overflow {
            return Self(value: rhs.value > 0 ? .min : .max)
        } else {
            return Self(value: report.partialValue)
        }
    }

    static func + (lhs: ClampedInteger, rhs: ClampedInteger) -> ClampedInteger {
        let report = lhs.value.addingReportingOverflow(rhs.value)

        if report.overflow {
            return Self(value: rhs.value > 0 ? .max : .min)
        } else {
            return Self(value: report.partialValue)
        }
    }
}

extension ClampedInteger {
    static func * (lhs: ClampedInteger, rhs: ClampedInteger) -> ClampedInteger {
        let report = lhs.value.multipliedReportingOverflow(by: rhs.value)

        if report.overflow {
            let signEqual = (lhs.value > 0) == (rhs.value > 0)
            return Self(value: signEqual ? .max : .min)
        } else {
            return Self(value: report.partialValue)
        }
    }

    static func *= (lhs: inout ClampedInteger, rhs: ClampedInteger) {
        lhs = lhs * rhs
    }
}
