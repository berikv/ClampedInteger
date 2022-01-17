
extension FixedWidthInteger {
    /// Creates an integer with the same value as the given clamped integer.
    init(_ value: ClampedInteger<Self>) {
        self = value.base
    }
}
