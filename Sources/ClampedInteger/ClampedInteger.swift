
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
public struct ClampedInteger<Base>: BinaryInteger where Base: FixedWidthInteger {
    var base: Base
}

/// Set Int as the default Base generic parameter type
extension ClampedInteger where Base == Int {
    init(integerLiteral value: Int.IntegerLiteralType) {
        self.base = Int(integerLiteral: value)
    }

    static var zero: ClampedInteger<Int> { ClampedInteger(base: .zero) }

    static var min: ClampedInteger<Int> { ClampedInteger(base: .min) }

    static var max: ClampedInteger<Int> { ClampedInteger(base: .max) }
}

extension ClampedInteger {
    public init<T>(_ source: T) where T : BinaryInteger {
        if source < Base.min {
            base = .min
        } else if source > Base.max {
            base = .max
        } else {
            base = Base(source)
        }
    }

    public init<T>(_ source: T) where T : BinaryFloatingPoint {
        if source < T(Base.min) {
            base = .min
        } else if source > T(Base.max) {
            base = .max
        } else {
            base = Base(source)
        }
    }
}

extension ClampedInteger: AdditiveArithmetic {
    public static func - (lhs: ClampedInteger, rhs: ClampedInteger) -> ClampedInteger {
        let report = lhs.base.subtractingReportingOverflow(rhs.base)

        if report.overflow {
            return Self(base: rhs.base > 0 ? .min : .max)
        } else {
            return Self(base: report.partialValue)
        }
    }

    public static func + (lhs: ClampedInteger, rhs: ClampedInteger) -> ClampedInteger {
        let report = lhs.base.addingReportingOverflow(rhs.base)

        if report.overflow {
            return Self(base: rhs.base > 0 ? .max : .min)
        } else {
            return Self(base: report.partialValue)
        }
    }
}

extension ClampedInteger {
    public static func * (lhs: ClampedInteger, rhs: ClampedInteger) -> ClampedInteger {
        let report = lhs.base.multipliedReportingOverflow(by: rhs.base)

        if report.overflow {
            let signEqual = (lhs.base > 0) == (rhs.base > 0)
            return Self(base: signEqual ? .max : .min)
        } else {
            return Self(base: report.partialValue)
        }
    }

    public static func *= (lhs: inout ClampedInteger, rhs: ClampedInteger) {
        lhs = lhs * rhs
    }
}
