
/// An Integer type that clamps its value to its minimum and maximum, instead of overflowing.
///
/// For example:
///
/// ```
///     let a = ClampedInteger<Int>.max
///     if a == a + 1 { print("Clamped!") } // this prints Clamped!
/// ```
/// Minus, Plus and Multiplication have a custom *clamping* implementation. All other operations
/// are forwarded to the Wrapped integer type.
public struct ClampedInteger<Base>: BinaryInteger where Base: FixedWidthInteger {
    var base: Base
}

/// Set Int as the default Base generic parameter type
extension ClampedInteger where Base == Int {
    init(integerLiteral value: Int.IntegerLiteralType) {
        self.base = Int(integerLiteral: value)
    }

    /// The zero value.
    ///
    /// Zero is the identity element for addition. For any value,
    /// `x + .zero == x` and `.zero + x == x`.
    static var zero: ClampedInteger<Int> { ClampedInteger(base: .zero) }

    /// The minimum representable integer in this type.
    ///
    /// For unsigned integer types, this value is always `0`. For signed integer
    /// types, this value is `-(2 ** (bitWidth - 1))`, where `**` is
    /// exponentiation.
    static var min: ClampedInteger<Int> { ClampedInteger(base: .min) }

    /// The maximum representable integer in this type.
    ///
    /// For unsigned integer types, this value is `(2 ** bitWidth) - 1`, where
    /// `**` is exponentiation. For signed integer types, this value is
    /// `(2 ** (bitWidth - 1)) - 1`.
    static var max: ClampedInteger<Int> { ClampedInteger(base: .max) }
}

extension ClampedInteger {
    /// Creates a new instance from the given integer.
    ///
    /// If the value passed as `source` is not representable in the base type,
    /// the value will be clamped to the min or max value of the clamped integer's
    /// base type.
    ///
    ///     let x = -500 // x == -500
    ///     let y = ClampedInteger<UInt32>(x)
    ///     // y == 0
    ///
    /// - Parameter source: An integer to convert. `source` must be representable
    ///   in this type.
    public init<T>(_ source: T) where T : BinaryInteger {
        if source < Base.min {
            base = .min
        } else if source > Base.max {
            base = .max
        } else {
            base = Base(source)
        }
    }

    /// Creates an integer from the given floating-point value, rounding toward
    /// zero. Any fractional part of the value passed as `source` is removed.
    ///
    ///     let x = ClampedInteger<Int>(21.5)
    ///     // x == 21
    ///     let y = ClampedInteger<Int>(-21.5)
    ///     // y == -21
    ///
    /// If the value passed as `source` is not representable in the base type,
    /// the value will be clamped to the min or max value of the clamped integer's
    /// base type.
    ///
    ///     let x = -21.7 // x == -21.7
    ///     let y = ClampedInteger<UInt32>(x)
    ///     // y == 0
    ///
    /// - Parameter source: A floating-point value to convert to an integer.
    ///   `source` must be representable in this type after rounding toward
    ///   zero.
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
    /// Subtracts one value from another and produces their difference.
    ///
    /// The subtraction operator (`-`) calculates the difference of its two
    /// arguments. For example:
    ///
    ///     let x = ClampedInteger(-10) - 5
    ///     // x == -15
    ///
    /// If the difference of the two arguments is not representable in the
    /// arguments' type, the value will be clamped to the minimum
    /// or maxiumum value representable of the arguments type.
    /// In the following example, the result of `21 - 50` is
    /// less than zero, the minimum representable `UInt8` value:
    ///
    ///     let x = ClampedInteger<UInt8>(21)
    ///     let y = x - 50
    ///     // y == 0
    ///
    public static func - (lhs: ClampedInteger, rhs: ClampedInteger) -> ClampedInteger {
        let report = lhs.base.subtractingReportingOverflow(rhs.base)

        if report.overflow {
            return Self(base: rhs.base > 0 ? .min : .max)
        } else {
            return Self(base: report.partialValue)
        }
    }

    /// Adds two values and produces their sum.
    ///
    /// The addition operator (`+`) calculates the sum of its two
    /// arguments. For example:
    ///
    ///     let x = ClampedInteger(-10) + 5
    ///     // x == -5
    ///
    /// If the sum of the two arguments is not representable in the
    /// arguments' type, the value will be clamped to the minimum
    /// or maxiumum value representable of the arguments type.
    /// In the following example, the result of `21 + 1000000` is
    /// more than `255`, the maximum representable `UInt8` value:
    ///
    ///     let x = ClampedInteger<UInt8>(21)
    ///     let y = x + 1000000
    ///     // y == 255
    ///
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
    /// Multiplies two values and produces their product.
    ///
    /// The multiplication operator (`*`) calculates the product of its two
    /// arguments. For example:
    ///
    ///     ClampedInteger(2) * 3    // 6
    ///
    /// If the product of the two arguments is not representable in the
    /// arguments' type, the value will be clamped to the minimum
    /// or maxiumum value representable of the arguments type.
    /// In the following example, the result of `21 * 21` is greater than
    /// the maximum representable `Int8` value:
    ///
    ///     let x = ClampedInteger<Int8>(21)
    ///     let y = x * 21
    ///     // y == 255
    ///
    public static func * (lhs: ClampedInteger, rhs: ClampedInteger) -> ClampedInteger {
        let report = lhs.base.multipliedReportingOverflow(by: rhs.base)

        if report.overflow {
            let signEqual = (lhs.base > 0) == (rhs.base > 0)
            return Self(base: signEqual ? .max : .min)
        } else {
            return Self(base: report.partialValue)
        }
    }

    /// Multiplies two values and stores the result in the left-hand-side
    /// variable.
    ///
    /// If the product of the two arguments is not representable in the
    /// arguments' type, the value will be clamped to the minimum
    /// or maxiumum value representable of the arguments type.
    /// In the following example, the result of `21 * 21` is greater than
    /// the maximum representable `Int8` value:
    ///
    ///     var x = ClampedInteger<Int8>(21)
    ///     x *= 21
    ///     // x == 255
    ///
    public static func *= (lhs: inout ClampedInteger, rhs: ClampedInteger) {
        lhs = lhs * rhs
    }
}

extension ClampedInteger {
    /// Returns the sum of this value and the given value, along with a Boolean
    /// value indicating whether overflow occurred in the operation.
    ///
    /// Clamped integer never overflows, the overflow result value is always false
    public func addingReportingOverflow(_ rhs: ClampedInteger<Base>) -> (partialValue: ClampedInteger<Base>, overflow: Bool) {
        return (self + rhs, false)
    }

    /// Returns the difference obtained by subtracting the given value from this
    /// value, along with a Boolean value indicating whether overflow occurred in
    /// the operation.
    ///
    /// Clamped integer never overflows, the overflow result value is always false
    public func subtractingReportingOverflow(_ rhs: ClampedInteger<Base>) -> (partialValue: ClampedInteger<Base>, overflow: Bool) {
        return (self - rhs, false)
    }

    /// Returns the product of this value and the given value, along with a
    /// Boolean value indicating whether overflow occurred in the operation.
    ///
    /// Clamped integer never overflows, the overflow result value is always false
    public func multipliedReportingOverflow(by rhs: ClampedInteger<Base>) -> (partialValue: ClampedInteger<Base>, overflow: Bool) {
        return (self * rhs, false)
    }
}
