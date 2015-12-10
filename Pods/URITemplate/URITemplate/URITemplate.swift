//
//  URITemplate.swift
//  URITemplate
//
//  Created by Kyle Fuller on 25/11/2014.
//  Copyright (c) 2014 Kyle Fuller. All rights reserved.
//

import Foundation

// MARK: URITemplate

/// A data structure to represent an RFC6570 URI template.
public struct URITemplate : CustomStringConvertible, Equatable, Hashable, StringLiteralConvertible, ExtendedGraphemeClusterLiteralConvertible, UnicodeScalarLiteralConvertible {
  /// The underlying URI template
  public let template:String

  var regex:NSRegularExpression {
    let expression: NSRegularExpression?
    do {
      expression = try NSRegularExpression(pattern: "\\{([^\\}]+)\\}", options: NSRegularExpressionOptions(rawValue: 0))
    } catch let error as NSError {
      fatalError("Invalid Regex \(error)")
    }
    return expression!
  }

  var operators:[Operator] {
    return [
      StringExpansion(),
      ReservedExpansion(),
      FragmentExpansion(),
      LabelExpansion(),
      PathSegmentExpansion(),
      PathStyleParameterExpansion(),
      FormStyleQueryExpansion(),
      FormStyleQueryContinuation(),
    ]
  }

  /// Initialize a URITemplate with the given template
  public init(template:String) {
    self.template = template
  }

  public typealias ExtendedGraphemeClusterLiteralType = StringLiteralType
  public init(extendedGraphemeClusterLiteral value: ExtendedGraphemeClusterLiteralType) {
    template = value
  }

  public typealias UnicodeScalarLiteralType = StringLiteralType
  public init(unicodeScalarLiteral value: UnicodeScalarLiteralType) {
    template = value
  }

  public init(stringLiteral value: StringLiteralType) {
    template = value
  }

  /// Returns a description of the URITemplate
  public var description:String {
    return template
  }

  public var hashValue:Int {
    return template.hashValue
  }

  /// Returns the set of keywords in the URI Template
  public var variables:[String] {
    let expressions = regex.matches(template).map { expression in
      // Removes the { and } from the expression
      expression.substringWithRange(expression.startIndex.successor()..<expression.endIndex.predecessor())
    }

    return expressions.map { expression -> [String] in
      var expression = expression

      for op in self.operators {
        if let op = op.op {
          if expression.hasPrefix(op) {
            expression = expression.substringFromIndex(expression.startIndex.successor())
            break
          }
        }
      }

      return expression.componentsSeparatedByString(",").map { component in
        if component.hasSuffix("*") {
          return component.substringToIndex(expression.endIndex.predecessor())
        } else {
          return component
        }
      }
    }.reduce([], combine: +)
  }

  /// Expand template as a URI Template using the given variables
  public func expand(variables:[String:AnyObject]) -> String {
    return regex.substitute(template) { string in
      var expression = string.substringWithRange(string.startIndex.successor()..<string.endIndex.predecessor())
      let firstCharacter = expression.substringToIndex(expression.startIndex.successor())

      var op = self.operators.filter {
        if let op = $0.op {
          return op == firstCharacter
        }

        return false
      }.first

      if (op != nil) {
        expression = expression.substringFromIndex(expression.startIndex.successor())
      } else {
        op = self.operators.first
      }

      let rawExpansions = expression.componentsSeparatedByString(",").map { vari -> String? in
        var variable = vari
        var prefix:Int?

        if let range = variable.rangeOfString(":") {
          prefix = Int(variable.substringFromIndex(range.endIndex))
          variable = variable.substringToIndex(range.startIndex)
        }

        let explode = variable.hasSuffix("*")

        if explode {
          variable = variable.substringToIndex(variable.endIndex.predecessor())
        }

        if let value:AnyObject = variables[variable] {
          return op!.expand(variable, value: value, explode: explode, prefix:prefix)
        }

        return op!.expand(variable, value:nil, explode:false, prefix:prefix)
      }

      let expansions = rawExpansions.reduce([], combine: { (accumulator, expansion) -> [String] in
        if let expansion = expansion {
          return accumulator + [expansion]
        }

        return accumulator
      })

      if expansions.count > 0 {
        return op!.prefix + expansions.joinWithSeparator(op!.joiner)
      }

      return ""
    }
  }

  func regexForVariable(variable:String, op:Operator?) -> String {
    if op != nil {
      return "(.*)"
    } else {
      return "([A-z0-9%_\\-]+)"
    }
  }

  func regexForExpression(expression:String) -> String {
    var expression = expression

    let op = operators.filter {
      $0.op != nil && expression.hasPrefix($0.op!)
    }.first

    if op != nil {
      expression = expression.substringWithRange(expression.startIndex.successor()..<expression.endIndex)
    }

    let regexes = expression.componentsSeparatedByString(",").map { variable -> String in
      return self.regexForVariable(variable, op: op)
    }

    return regexes.joinWithSeparator((op ?? StringExpansion()).joiner)
  }

  var extractionRegex:NSRegularExpression? {
    let regex = try! NSRegularExpression(pattern: "(\\{([^\\}]+)\\})|[^(.*)]", options: NSRegularExpressionOptions(rawValue: 0))

    let pattern = regex.substitute(self.template) { expression in
      if expression.hasPrefix("{") && expression.hasSuffix("}") {
        let startIndex = expression.startIndex.successor()
        let endIndex = expression.endIndex.predecessor()
        return self.regexForExpression(expression.substringWithRange(startIndex..<endIndex))
      } else {
        return NSRegularExpression.escapedPatternForString(expression)
      }
    }

    do {
      return try NSRegularExpression(pattern: "^\(pattern)$", options: NSRegularExpressionOptions(rawValue: 0))
    } catch _ {
      return nil
    }
  }

  /// Extract the variables used in a given URL
  public func extract(url:String) -> [String:String]? {
    if let expression = extractionRegex {
      let input = url as NSString
      let range = NSRange(location: 0, length: input.length)
      let results = expression.matchesInString(url, options: NSMatchingOptions(rawValue: 0), range: range)

      if let result = results.first {
        var extractedVariables = Dictionary<String, String>()

        for (index, variable) in variables.enumerate() {
          let range = result.rangeAtIndex(index + 1)
          let value = input.substringWithRange(range).stringByRemovingPercentEncoding
          extractedVariables[variable] = value
        }

        return extractedVariables
      }
    }

    return nil
  }
}

/// Determine if two URITemplate's are equivalent
public func ==(lhs:URITemplate, rhs:URITemplate) -> Bool {
  return lhs.template == rhs.template
}

// MARK: Extensions

extension NSRegularExpression {
  func substitute(string:String, block:((String) -> (String))) -> String {
    let oldString = string as NSString
    let range = NSRange(location: 0, length: oldString.length)
    var newString = string as NSString

    let matches = matchesInString(string, options: NSMatchingOptions(rawValue: 0), range: range)
    for match in Array(matches.reverse()) {
      let expression = oldString.substringWithRange(match.range)
      let replacement = block(expression)
      newString = newString.stringByReplacingCharactersInRange(match.range, withString: replacement)
    }

    return newString as String
  }

  func matches(string:String) -> [String] {
    let input = string as NSString
    let range = NSRange(location: 0, length: input.length)
    let results = matchesInString(string, options: NSMatchingOptions(rawValue: 0), range: range)

    return results.map { result -> String in
      return input.substringWithRange(result.range)
    }
  }
}

extension String {
  func percentEncoded() -> String {
    return CFURLCreateStringByAddingPercentEscapes(nil, self, nil, ":/?&=;+!@#$()',*", CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding)) as String
  }
}

// MARK: Operators

protocol Operator {
  /// Operator
  var op:String? { get }

  /// Prefix for the expanded string
  var prefix:String { get }

  /// Character to use to join expanded components
  var joiner:String { get }

  func expand(variable:String, value:AnyObject?, explode:Bool, prefix:Int?) -> String?
}

class BaseOperator {
  var joiner:String { return "," }

  func expand(variable:String, value:AnyObject?, explode:Bool, prefix:Int?) -> String? {
    if let value:AnyObject = value {
      if let values = value as? [String:AnyObject] {
        return expand(variable:variable, value: values, explode: explode)
      } else if let values = value as? [AnyObject] {
        return expand(variable:variable, value: values, explode: explode)
      } else if let _ = value as? NSNull {
        return expand(variable:variable)
      } else {
        return expand(variable:variable, value:"\(value)", prefix:prefix)
      }
    }

    return expand(variable:variable)
  }

  // Point to overide to expand a value (i.e, perform encoding)
  func expand(value  value:String) -> String {
    return value
  }

  // Point to overide to expanding a string
  func expand(variable  variable:String, value:String, prefix:Int?) -> String {
    if let prefix = prefix {
      if value.characters.count > prefix {
        let index = value.startIndex.advancedBy(prefix, limit: value.endIndex)
        return expand(value: value.substringToIndex(index))
      }
    }

    return expand(value: value)
  }

  // Point to overide to expanding an array
  func expand(variable  variable:String, value:[AnyObject], explode:Bool) -> String? {
    let joiner = explode ? self.joiner : ","
    return value.map { self.expand(value: "\($0)") }.joinWithSeparator(joiner)
  }

  // Point to overide to expanding a dictionary
  func expand(variable  variable:String, value:[String:AnyObject], explode:Bool) -> String? {
    let joiner = explode ? self.joiner : ","
    let keyValueJoiner = explode ? "=" : ","
    let elements = value.map({ (key, value) -> String in
      let expandedKey = self.expand(value: key)
      let expandedValue = self.expand(value: "\(value)")
      return "\(expandedKey)\(keyValueJoiner)\(expandedValue)"
    })

    return elements.joinWithSeparator(joiner)
  }

  // Point to overide when value not found
  func expand(variable  variable:String) -> String? {
    return nil
  }
}

/// RFC6570 (3.2.2) Simple String Expansion: {var}
class StringExpansion : BaseOperator, Operator {
  var op:String? { return nil }
  var prefix:String { return "" }
  override var joiner:String { return "," }

  override func expand(value  value:String) -> String {
    return value.percentEncoded()
  }
}

/// RFC6570 (3.2.3) Reserved Expansion: {+var}
class ReservedExpansion : BaseOperator, Operator {
  var op:String? { return "+" }
  var prefix:String { return "" }
  override var joiner:String { return "," }

  override func expand(value  value:String) -> String {
    return value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
  }
}

/// RFC6570 (3.2.4) Fragment Expansion {#var}
class FragmentExpansion : BaseOperator, Operator {
  var op:String? { return "#" }
  var prefix:String { return "#" }
  override var joiner:String { return "," }

  override func expand(value  value:String) -> String {
    return value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLFragmentAllowedCharacterSet())!
  }
}

/// RFC6570 (3.2.5) Label Expansion with Dot-Prefix: {.var}
class LabelExpansion : BaseOperator, Operator {
  var op:String? { return "." }
  var prefix:String { return "." }
  override var joiner:String { return "." }

  override func expand(value  value:String) -> String {
    return value.percentEncoded()
  }

  override func expand(variable  variable:String, value:[AnyObject], explode:Bool) -> String? {
    if value.count > 0 {
      return super.expand(variable: variable, value: value, explode: explode)
    }

    return nil
  }
}

/// RFC6570 (3.2.6) Path Segment Expansion: {/var}
class PathSegmentExpansion : BaseOperator, Operator {
  var op:String? { return "/" }
  var prefix:String { return "/" }
  override var joiner:String { return "/" }

  override func expand(value  value:String) -> String {
    return value.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLPathAllowedCharacterSet())!
  }

  override func expand(variable  variable:String, value:[AnyObject], explode:Bool) -> String? {
    if value.count > 0 {
      return super.expand(variable: variable, value: value, explode: explode)
    }

    return nil
  }
}

/// RFC6570 (3.2.7) Path-Style Parameter Expansion: {;var}
class PathStyleParameterExpansion : BaseOperator, Operator {
  var op:String? { return ";" }
  var prefix:String { return ";" }
  override var joiner:String { return ";" }

  override func expand(value  value:String) -> String {
    return value.percentEncoded()
  }

  override func expand(variable  variable:String, value:String, prefix:Int?) -> String {
    if value.characters.count > 0 {
      let expandedValue = super.expand(variable: variable, value: value, prefix: prefix)
      return "\(variable)=\(expandedValue)"
    }

    return variable
  }

  override func expand(variable  variable:String, value:[AnyObject], explode:Bool) -> String? {
    let joiner = explode ? self.joiner : ","
    let expandedValue = value.map {
      let expandedValue = self.expand(value: "\($0)")

      if explode {
        return "\(variable)=\(expandedValue)"
      }

      return expandedValue
    }.joinWithSeparator(joiner)

    if !explode {
      return "\(variable)=\(expandedValue)"
    }

    return expandedValue
  }

  override func expand(variable  variable:String, value:[String:AnyObject], explode:Bool) -> String? {
    let expandedValue = super.expand(variable: variable, value: value, explode: explode)

    if let expandedValue = expandedValue {
      if (!explode) {
        return "\(variable)=\(expandedValue)"
      }
    }

    return expandedValue
  }
}

/// RFC6570 (3.2.8) Form-Style Query Expansion: {?var}
class FormStyleQueryExpansion : BaseOperator, Operator {
  var op:String? { return "?" }
  var prefix:String { return "?" }
  override var joiner:String { return "&" }

  override func expand(value  value:String) -> String {
    return value.percentEncoded()
  }

  override func expand(variable  variable:String, value:String, prefix:Int?) -> String {
    let expandedValue = super.expand(variable: variable, value: value, prefix: prefix)
    return "\(variable)=\(expandedValue)"
  }

  override func expand(variable  variable:String, value:[AnyObject], explode:Bool) -> String? {
    if value.count > 0 {
      let joiner = explode ? self.joiner : ","
      let expandedValue = value.map {
        let expandedValue = self.expand(value: "\($0)")

        if explode {
          return "\(variable)=\(expandedValue)"
        }

        return expandedValue
      }.joinWithSeparator(joiner)

      if !explode {
        return "\(variable)=\(expandedValue)"
      }

      return expandedValue
    }

    return nil
  }

  override func expand(variable  variable:String, value:[String:AnyObject], explode:Bool) -> String? {
    if value.count > 0 {
      let expandedVariable = self.expand(value: variable)
      let expandedValue = super.expand(variable: variable, value: value, explode: explode)

      if let expandedValue = expandedValue {
        if (!explode) {
          return "\(expandedVariable)=\(expandedValue)"
        }
      }

      return expandedValue
    }

    return nil
  }
}

/// RFC6570 (3.2.9) Form-Style Query Continuation: {&var}
class FormStyleQueryContinuation : BaseOperator, Operator {
  var op:String? { return "&" }
  var prefix:String { return "&" }
  override var joiner:String { return "&" }

  override func expand(value  value:String) -> String {
    return value.percentEncoded()
  }

  override func expand(variable  variable:String, value:String, prefix:Int?) -> String {
    let expandedValue = super.expand(variable: variable, value: value, prefix: prefix)
    return "\(variable)=\(expandedValue)"
  }

  override func expand(variable  variable:String, value:[AnyObject], explode:Bool) -> String? {
    let joiner = explode ? self.joiner : ","
    let expandedValue = value.map {
      let expandedValue = self.expand(value: "\($0)")

      if explode {
        return "\(variable)=\(expandedValue)"
      }

      return expandedValue
    }.joinWithSeparator(joiner)

    if !explode {
      return "\(variable)=\(expandedValue)"
    }

    return expandedValue
  }

  override func expand(variable  variable:String, value:[String:AnyObject], explode:Bool) -> String? {
    let expandedValue = super.expand(variable: variable, value: value, explode: explode)

    if let expandedValue = expandedValue {
      if (!explode) {
        return "\(variable)=\(expandedValue)"
      }
    }

    return expandedValue
  }
}
