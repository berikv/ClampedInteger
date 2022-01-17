
// Below implementations forward to the Base type

extension ClampedInteger: Equatable, Comparable {
    static func ==(_ lhs: ClampedInteger<Base>, _ rhs: ClampedInteger<Base>) -> Bool {
        lhs.value == rhs.value
    }

    static func <(_ lhs: ClampedInteger<Base>, _ rhs: ClampedInteger<Base>) -> Bool {
        lhs.value < rhs.value
    }
}

extension ClampedInteger: FixedWidthInteger {
    static var max: Self { ClampedInteger(value: Base.max) }
    static var min: Self { ClampedInteger(value: Base.min) }

    static var bitWidth: Int { Base.bitWidth }

    init(_truncatingBits bits: UInt) { fatalError() }

    var nonzeroBitCount: Int { value.nonzeroBitCount }
    var leadingZeroBitCount: Int { value.leadingZeroBitCount }
    var byteSwapped: ClampedInteger<Base> { Self(value.byteSwapped) }

    func addingReportingOverflow(_ rhs: ClampedInteger<Base>) -> (partialValue: ClampedInteger<Base>, overflow: Bool) {
        return (self + rhs, false)
    }

    func subtractingReportingOverflow(_ rhs: ClampedInteger<Base>) -> (partialValue: ClampedInteger<Base>, overflow: Bool) {
        return (self - rhs, false)
    }

    func multipliedReportingOverflow(by rhs: ClampedInteger<Base>) -> (partialValue: ClampedInteger<Base>, overflow: Bool) {
        return (self * rhs, false)
    }

    func dividedReportingOverflow(by rhs: ClampedInteger<Base>) -> (partialValue: ClampedInteger<Base>, overflow: Bool) {
        let result = value.dividedReportingOverflow(by: rhs.value)
        return (Self(result.partialValue), result.overflow)
    }

    func remainderReportingOverflow(dividingBy rhs: ClampedInteger<Base>) -> (partialValue: ClampedInteger<Base>, overflow: Bool) {
        let result = value.remainderReportingOverflow(dividingBy: rhs.value)
        return (Self(result.partialValue), result.overflow)
    }

    func dividingFullWidth(_ dividend: (high: ClampedInteger<Base>, low: Base.Magnitude)) -> (quotient: ClampedInteger<Base>, remainder: ClampedInteger<Base>) {
        let result = value.dividingFullWidth((dividend.high.value, dividend.low))
        return (Self(result.quotient), Self(result.remainder))
    }
}

extension ClampedInteger: ExpressibleByIntegerLiteral {
    init(integerLiteral value: Base.IntegerLiteralType) {
        self.value = Base(integerLiteral: value)
    }
}

extension ClampedInteger: SignedInteger {}

extension ClampedInteger: BinaryInteger {

    var magnitude: Base.Magnitude { value.magnitude }
    var words: Base.Words { value.words }
    var bitWidth: Int { value.bitWidth }
    var trailingZeroBitCount: Int { value.trailingZeroBitCount }

    init<T>(_ source: T) where T : BinaryInteger {
        value = Base(source)
    }

    init?<T>(exactly source: T) where T : BinaryInteger {
        guard let value = Base(exactly: source) else { return nil }
        self.value = value
    }

    init<T>(truncatingIfNeeded source: T) where T : BinaryInteger {
        value = Base(truncatingIfNeeded: source)
    }

    init<T>(clamping source: T) where T : BinaryInteger {
        value = Base(clamping: source)
    }

    init?<T>(exactly source: T) where T : BinaryFloatingPoint {
        guard let value = Base(exactly: source) else { return nil }
        self.value = value
    }

    init<T>(_ source: T) where T : BinaryFloatingPoint {
        value = Base(source)
    }

    static func / (lhs: ClampedInteger, rhs: ClampedInteger) -> ClampedInteger {
        Self(lhs.value / rhs.value)
    }

    static func /= (lhs: inout ClampedInteger, rhs: ClampedInteger) {
        lhs.value /= rhs.value
    }

    static func % (lhs: ClampedInteger, rhs: ClampedInteger) -> ClampedInteger {
        Self(lhs.value % rhs.value)
    }

    static func %= (lhs: inout ClampedInteger, rhs: ClampedInteger) {
        lhs.value %= rhs.value
    }

    static func &= (lhs: inout ClampedInteger, rhs: ClampedInteger) {
        lhs.value &= rhs.value
    }

    static func |= (lhs: inout ClampedInteger, rhs: ClampedInteger) {
        lhs.value |= rhs.value
    }

    static func ^= (lhs: inout ClampedInteger, rhs: ClampedInteger) {
        lhs.value ^= rhs.value
    }

    prefix static func ~ (x: ClampedInteger) -> ClampedInteger {
        Self(~x.value)
    }

    static func >>= <RHS>(lhs: inout ClampedInteger, rhs: RHS) where RHS : BinaryInteger {
        lhs.value >>= rhs
    }

    static func <<= <RHS>(lhs: inout ClampedInteger, rhs: RHS) where RHS : BinaryInteger {
        lhs.value <<= rhs
    }
}
