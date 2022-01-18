
// Below implementations forward to the Base type

extension ClampedInteger: Equatable, Comparable {
    public static func ==(_ lhs: ClampedInteger<Base>, _ rhs: ClampedInteger<Base>) -> Bool {
        lhs.base == rhs.base
    }

    public static func <(_ lhs: ClampedInteger<Base>, _ rhs: ClampedInteger<Base>) -> Bool {
        lhs.base < rhs.base
    }
}

extension ClampedInteger: FixedWidthInteger {
    public static var max: Self { ClampedInteger(base: Base.max) }
    public static var min: Self { ClampedInteger(base: Base.min) }

    public static var bitWidth: Int { Base.bitWidth }

    public init(_truncatingBits bits: UInt) { fatalError() }

    public var nonzeroBitCount: Int { base.nonzeroBitCount }
    public var leadingZeroBitCount: Int { base.leadingZeroBitCount }
    public var byteSwapped: ClampedInteger<Base> { Self(base.byteSwapped) }

    public func dividedReportingOverflow(by rhs: ClampedInteger<Base>) -> (partialValue: ClampedInteger<Base>, overflow: Bool) {
        let result = base.dividedReportingOverflow(by: rhs.base)
        return (Self(result.partialValue), result.overflow)
    }

    public func remainderReportingOverflow(dividingBy rhs: ClampedInteger<Base>) -> (partialValue: ClampedInteger<Base>, overflow: Bool) {
        let result = base.remainderReportingOverflow(dividingBy: rhs.base)
        return (Self(result.partialValue), result.overflow)
    }

    public func dividingFullWidth(_ dividend: (high: ClampedInteger<Base>, low: Base.Magnitude)) -> (quotient: ClampedInteger<Base>, remainder: ClampedInteger<Base>) {
        let result = base.dividingFullWidth((dividend.high.base, dividend.low))
        return (Self(result.quotient), Self(result.remainder))
    }
}

extension ClampedInteger: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Base.IntegerLiteralType) {
        self.base = Base(integerLiteral: value)
    }
}

extension ClampedInteger: SignedInteger {}

extension ClampedInteger { /* BinaryInteger */

    public var magnitude: Base.Magnitude { base.magnitude }
    public var words: Base.Words { base.words }
    public var bitWidth: Int { base.bitWidth }
    public var trailingZeroBitCount: Int { base.trailingZeroBitCount }

    public init?<T>(exactly source: T) where T : BinaryInteger {
        guard let value = Base(exactly: source) else { return nil }
        self.base = value
    }

    public init<T>(truncatingIfNeeded source: T) where T : BinaryInteger {
        base = Base(truncatingIfNeeded: source)
    }

    public init<T>(clamping source: T) where T : BinaryInteger {
        base = Base(clamping: source)
    }

    public init?<T>(exactly source: T) where T : BinaryFloatingPoint {
        guard let value = Base(exactly: source) else { return nil }
        self.base = value
    }

    public static func / (lhs: ClampedInteger, rhs: ClampedInteger) -> ClampedInteger {
        Self(lhs.base / rhs.base)
    }

    public static func /= (lhs: inout ClampedInteger, rhs: ClampedInteger) {
        lhs.base /= rhs.base
    }

    public static func % (lhs: ClampedInteger, rhs: ClampedInteger) -> ClampedInteger {
        Self(lhs.base % rhs.base)
    }

    public static func %= (lhs: inout ClampedInteger, rhs: ClampedInteger) {
        lhs.base %= rhs.base
    }

    public static func &= (lhs: inout ClampedInteger, rhs: ClampedInteger) {
        lhs.base &= rhs.base
    }

    public static func |= (lhs: inout ClampedInteger, rhs: ClampedInteger) {
        lhs.base |= rhs.base
    }

    public static func ^= (lhs: inout ClampedInteger, rhs: ClampedInteger) {
        lhs.base ^= rhs.base
    }

    prefix public static func ~ (x: ClampedInteger) -> ClampedInteger {
        Self(~x.base)
    }

    public static func >>= <RHS>(lhs: inout ClampedInteger, rhs: RHS) where RHS : BinaryInteger {
        lhs.base >>= rhs
    }

    public static func <<= <RHS>(lhs: inout ClampedInteger, rhs: RHS) where RHS : BinaryInteger {
        lhs.base <<= rhs
    }
}
