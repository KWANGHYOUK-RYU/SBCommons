# Commons

Commons is a collection of largely standalone Swift abstractions.

[![Swift 3.0](https://img.shields.io/badge/Swift-3.0-orange.svg?style=flat)](https://developer.apple.com/swift/)
[![Platforms OS X | Linux](https://img.shields.io/badge/Platforms-OS%20X%20%7C%20Linux%20-lightgray.svg?style=flat)](https://developer.apple.com/swift/)
![License](https://img.shields.io/cocoapods/l/SBCommons.svg)
![](https://img.shields.io/badge/Package%20Maker-compatible-orange.svg)
[![Version](https://img.shields.io/cocoapods/v/SBCommons.svg)](http://cocoapods.org)

## Features

### Functions

Swift has first class functions with static binding from the lexical context.  Combining functions
in a few well-defined ways is a common need.  We provide the following functions that returns
functions of `x`:

* `Always` - always returns `y`
* `Complement` - returns `!pred(x)`
* `Compose` - computes `g(f(x))`
* `Disjoin` - returns `pred1(x) || pred2(x)`
* `Conjoin` - returns `pred1(x) && pred2(x)`
* `equalTo` - returns `pred(x, y)`

where `y`, `pred{,1,2}`, `f`, and `g` are captured lexically.

Additional functions include `any` and `all` on `SequenceType` and a set of functions taking a 
predicate and returning functions of a `SequenceType` as: `allUsing`, `anyUsing`, `mapUsing` and
`appUsing`.

### As, Any Protocols

The `As<Protocol>` pattern allows any `Item`, with a property satisfying a protocol, to 'adopt' that
protocol.  For example, consider a `Person` abstraction with properties: ssn, name and age (in
years):

```swift
class Person : Equatable {
  let ssn  : String
  let name : String
  var age  : UInt
}

func == (lhs:Person, rhs:Person) -> Bool {
  return lhs.ssn == rhs.ssn
}
```

`Person` is not comparable but in some contexts you might need to compare people based on any of
`ssn`, `name` or `age`.  You'd do that with, for example:

```swift
let p1 = Person (ssn: "123", name: "Zack", age: 10)
let p2 = Person (ssn: "321", name: "Zoey", age: 9)

let younger = min(AsComparable (value: p1.age, item: p1), AsComparable (value: p2.age, item: p2)).item
younger.name // => "Zoey"
```

The `As<Protocol>` is implemented for three common Swift protocols as `AsEquatable`, `AsComparable`,
and `AsHashable`.  `AsComparableInvert` is also provided.

### Result

The ubiquitious 

```swift
enum Result<V,E:ErrorType> {
  case Success(V)
  case Failure(E)
}
```

This really should be supplanted by other, more complete, GitHub packages.

## Usage

Access the framework with

```swift
import SBCommons
```

## Installation

Three easy installation options:

### Apple Package Manager

In your Package.swift file, add a dependency on SBCommons:

```swift
import PackageDescription

let package = Package (
  name: "<your package>",
  dependencies: [
    // ...
    .Package (url: "https://github.com/EBGToo/SBCommons.git",  majorVersion: 0),
    // ...
  ]
)
```

### Cocoa Pods

```ruby
pod 'SBCommons', '~> 0.1'
```

### XCode

```bash
$ git clone https://github.com/EBGToo/SBCommons.git SBCommons
```

Add the SBCommons Xcode Project to your Xcode Workspace.

