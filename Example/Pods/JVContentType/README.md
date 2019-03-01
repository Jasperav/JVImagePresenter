# JVContentType

[![CI Status](https://img.shields.io/travis/Jasperav/JVContentType.svg?style=flat)](https://travis-ci.org/Jasperav/JVContentType)
[![Version](https://img.shields.io/cocoapods/v/JVContentType.svg?style=flat)](https://cocoapods.org/pods/JVContentType)
[![License](https://img.shields.io/cocoapods/l/JVContentType.svg?style=flat)](https://cocoapods.org/pods/JVContentType)
[![Platform](https://img.shields.io/cocoapods/p/JVContentType.svg?style=flat)](https://cocoapods.org/pods/JVContentType)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
iOS 11.0 > and Swift 4.2 >

## Description
Create reusabele components throughout your app.

Do you ever write code and notice you constantly are writing duplicate code?
Do you create e.g. labels in your Storyboard and constantly setting the same font?

What happens when you want to change your font? Color? Size?


JVContentType to the rescue!


To tackle the problem described above, do the following:
1. Create an enum with all the types you are using in your app:

public enum LabelType { 
    case header, body, title
}

2. Make it initializable by a String expression by writing :String behind your enum (CaseIterable should be added aswell):
public enum LabelType: String { 
    case header, body, title
}

3. Subclass ContentType, make it a final class and add your properties. Example:


import JVContentType

public final class ContentTypeLabel: ContentType {
public static var allTypes = Set<ContentTypeLabel>()

public var contentTypeId: String?
public var font: UIFont
public var color: UIColor

public init(contentTypeId: String?, font: UIFont, color: UIColor) {
self.contentTypeId = contentTypeId
self.font = font
self.color = color
}
}

4. Add the following String extension to provide an easy contentType getter:

var contentTypeLabel: ContentTypeLabel {
return ContentTypeLabel.getContentType(contentTypeId: self)
}

5. Add the following variable to your enum:

var contentType: ContentTypeLabel {
return rawValue.contentTypeLabel
}

6. Now somewhere when your app start, loop through all the cases of your enum and make sure every rawValue has a contentType associated with it. You can now create a convenience initializer for e.g. the UILabel that only takes a contentType as parameter. 

## Installation

JVContentType is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'JVContentType'
```

## Author

Jasperav, Jasperav@hotmail.com

## License

JVContentType is available under the MIT license. See the LICENSE file for more info.
