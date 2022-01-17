import XCTest
@testable import ClampedInteger

final class ClampedIntegerTests: XCTestCase {

    // MARK: - Add

    func test_add_overflow_big_lhs() {
        let value = ClampedInteger.max
        let overflowed = value + 1
        XCTAssertEqual(overflowed.value, .max)
    }

    func test_add_overflow_big_rhs() {
        let value = ClampedInteger.max
        let overflowed = 1 + value
        XCTAssertEqual(overflowed.value, .max)
    }

    func test_add_almost_overflow_big_lhs() {
        let value = ClampedInteger.max - 1
        let overflowed = value + 1
        XCTAssertEqual(overflowed.value, .max)
    }

    func test_add_almost_overflow_big_rhs() {
        let value = ClampedInteger.max - 1
        let overflowed = 1 + value
        XCTAssertEqual(overflowed.value, .max)
    }

    func test_add_underflow_big_lhs() {
        let value = ClampedInteger.min
        let overflowed = value + -1
        XCTAssertEqual(overflowed.value, .min)
    }

    func test_add_underflow_big_rhs() {
        let value = ClampedInteger.min
        let overflowed = -1 + value
        XCTAssertEqual(overflowed.value, .min)
    }

    func test_add_almost_underflow_big_lhs() {
        let value = ClampedInteger.min + 1
        let overflowed = value + -1
        XCTAssertEqual(overflowed.value, .min)
    }

    func test_add_almost_underflow_big_rhs() {
        let value = ClampedInteger.min + 1
        let overflowed = -1 + value
        XCTAssertEqual(overflowed.value, .min)
    }

    // MARK: - Subtract

    func test_subtract_overflow_big_lhs() {
        let value = ClampedInteger.max
        let overflowed = value - -1
        XCTAssertEqual(overflowed.value, .max)
    }

    func test_subtract_overflow_big_rhs() {
        let value = ClampedInteger.min
        let overflowed = 1 - value
        XCTAssertEqual(overflowed.value, .max)
    }

    func test_subtract_almost_overflow_big_lhs() {
        let value = ClampedInteger.max - 1
        let overflowed = value - -1
        XCTAssertEqual(overflowed.value, .max)
    }

    func test_subtract_almost_overflow_big_rhs() {
        let value = ClampedInteger.min + 1
        let overflowed = 1 - value
        XCTAssertEqual(overflowed.value, .max)
    }

    func test_subtract_underflow_big_lhs() {
        let value = ClampedInteger.min
        let overflowed = value - 1
        XCTAssertEqual(overflowed.value, .min)
    }

    func test_subtract_underflow_big_rhs() {
        let value = ClampedInteger.max
        let overflowed = -1 - value
        XCTAssertEqual(overflowed.value, .min)
    }

    func test_subtract_almost_underflow_big_lhs() {
        let value = ClampedInteger.min + 1
        let overflowed = value - 1
        XCTAssertEqual(overflowed.value, .min)
    }

    func test_subtract_almost_underflow_big_rhs() {
        let value = ClampedInteger.max
        let overflowed = 0 - value
        XCTAssertEqual(overflowed.value, .min + 1)
    }

    func test_subtract_negative_number() {
        let value = ClampedInteger.min
        let overflowed = value - -1
        XCTAssertEqual(overflowed.value, .min + 1)
    }

    // MARK: - Multiply

    func test_multiply_overflow_big_lhs() {
        let value = ClampedInteger.max
        let overflowed = value * 2
        XCTAssertEqual(overflowed.value, .max)
    }

    func test_multiply_overflow_big_rhs() {
        let value = ClampedInteger.max
        let overflowed = 2 * value
        XCTAssertEqual(overflowed.value, .max)
    }

    func test_multiply_underflow_big_lhs() {
        let value = ClampedInteger.min
        let overflowed = value * 2
        XCTAssertEqual(overflowed.value, .min)
    }

    func test_multiply_underflow_big_rhs() {
        let value = ClampedInteger.min
        let overflowed = 2 * value
        XCTAssertEqual(overflowed.value, .min)
    }
}
