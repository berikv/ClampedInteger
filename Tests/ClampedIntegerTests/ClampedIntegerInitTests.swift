import XCTest
@testable import ClampedInteger

final class ClampedIntegerInitTests: XCTestCase {
    func test_bigger_int() {
        let biggerInt = Int16.max
        let clamped = ClampedInteger<Int8>(biggerInt)
        XCTAssertEqual(clamped, .max)
    }

    func test_bigger_negative_int() {
        let biggerInt = Int16.min
        let clamped = ClampedInteger<Int8>(biggerInt)
        XCTAssertEqual(clamped, .min)
    }

    func test_smaller_int() {
        let clamped = ClampedInteger<UInt>(Int(1))
        XCTAssertEqual(clamped, 1)
    }

    func test_smaller_negative_int() {
        let clamped = ClampedInteger<Int>(Int16.min)
        XCTAssertEqual(clamped, -32768)
    }

    func test_big_double() {
        let bigDouble = Double.greatestFiniteMagnitude
        let clamped = ClampedInteger<Int>.init(bigDouble)
        XCTAssertEqual(clamped, .max)
    }

    func test_big_negative_double() {
        let negativeDouble = -Double.greatestFiniteMagnitude
        let clamped = ClampedInteger<Int>.init(negativeDouble)
        XCTAssertEqual(clamped, .min)
    }

    func test_cast_to_double() {
        let clamped = ClampedInteger<Int>.max
        XCTAssertEqual(Double(clamped), Double(Int.max))
    }

    func test_cast_to_bigger_int() {
        let clamped = ClampedInteger<Int16>.max
        XCTAssertEqual(Int32(clamped), Int32(Int16.max))
    }

    func test_cast_to_smaller_int() {
        let clamped = ClampedInteger<Int32>(42)
        XCTAssertEqual(Int16(clamped), 42)
    }
}
