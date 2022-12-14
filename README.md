# TextureTransition

[![CI Status](https://img.shields.io/travis/dankinsoid/TextureTransition.svg?style=flat)](https://travis-ci.org/dankinsoid/TextureTransition)
[![Version](https://img.shields.io/cocoapods/v/TextureTransition.svg?style=flat)](https://cocoapods.org/pods/TextureTransition)
[![License](https://img.shields.io/cocoapods/l/TextureTransition.svg?style=flat)](https://cocoapods.org/pods/TextureTransition)
[![Platform](https://img.shields.io/cocoapods/p/TextureTransition.svg?style=flat)](https://cocoapods.org/pods/TextureTransition)


## Description

TextureTransition provides easy way to describe node transitions based on [VDTransiotion](https://github.com/dankinsoid/VDTransiotion.git).

## Example
1. `.tansition` and `defaultAnimateLayoutTransition`
```swift
private func configureTransitions() {
    node1.transition = .scale(anchor: .topTrailing)
    node2.transition = .opacity
    node3.transition = [.move(edge: .trailing), .opacity]
}

override func animateLayoutTransition(_ context: ASContextTransitioning) {
    defaultAnimateLayoutTransition(context, animation: .default)
}
```
2. Some helpers methods
```swift 
node1.set(hidden: true, transition: .opacity)
node2.set(hidden: true, transition: .move(edge: .trailing))
node3.removeFromSupernode(transition: [.move(edge: .trailing), .opacity])
```

## Installation
1.  [CocoaPods](https://cocoapods.org)

Add the following line to your Podfile:
```ruby
pod 'TextureTransition'
```
and run `pod update` from the podfile directory first.

2. [Swift Package Manager](https://github.com/apple/swift-package-manager)

Create a `Package.swift` file.
```swift
// swift-tools-version:5.6
import PackageDescription

let package = Package(
  name: "SomeProject",
  dependencies: [
    .package(url: "https://github.com/dankinsoid/TextureTransition.git", from: "1.1.4")
  ],
  targets: [
    .target(name: "SomeProject", dependencies: ["TextureTransition"])
  ]
)
```
```ruby
$ swift build
```

## Author

dankinsoid, voidilov@gmail.com

## License

TextureTransition is available under the MIT license. See the LICENSE file for more info.

