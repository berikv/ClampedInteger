# ClampedInteger

An Integer type that clamps its value to its minimum and maximum instead of over- or underflowing.

## Examples

```swift
    let big = ClampedInteger.max // 9223372036854775807
    big + 10 == .max // true
    big * 2 == .max // true
    big * -1 == .min + 1 // true, because -.max > .min
    big * -2 == .min // true
    
    let negative = ClampedInteger.min // -9223372036854775808
    negative - 10 == .min // true
    negative * 2 == .min // true
    negative * -1 == .max // true
```

ClampedInteger is generic over FixedWidthIntegers and can be used with any fixed with integer type:

```swift
    let big = ClampedInteger<UInt16>(21)
    big * 21 == 255 // true
```

The clamping behavior may lead to surprising results.
In this example the literal `-10` is clamped to the minimum value of UInt (which is `0`).

```swift
    ClampedInteger<UInt>(-10) == 0 // true
```

## Install

### Package.swift

Edit the Package.swift file. Add the ClampedInteger as a dependency:
 
```
let package = Package(
    name: " ... ",
    products: [ ... ],
    dependencies: [
        .package(url: "https://github.com/berikv/ClampedInteger.git", from: "0.0.0") // here
    ],
    targets: [
        .target(
            name: " ... ",
            dependencies: [
                "ClampedInteger" // and here
            ]),
    ]
)
```

### For .xcodeproj projects

1. Open menu File > Add Packages...
2. Search for "https://github.com/berikv/ClampedInteger.git" and click Add Package.
3. Open your project file, select your target in "Targets".
4. Open Dependencies
5. Click the + sign
6. Add ClampedInteger
