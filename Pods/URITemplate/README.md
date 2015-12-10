URITemplate
===========

Swift implementation of URI Template ([RFC6570](https://tools.ietf.org/html/rfc6570)).

## Installation

[CocoaPods](http://cocoapods.org/) is the recommended installation method.

```ruby
pod 'URITemplate'
```

## Example

### Expanding a URI Template

```swift
let template = URITemplate(template: "https://api.github.com/repos/{owner}/{repo}/")
let url = template.expand(["owner": "kylef", "repo": "URITemplate.swift"])
=> "https://api.github.com/repos/kylef/URITemplate.swift/"
```

### Determine which variables are in a template

```swift
let variables = template.variables
=> ["owner", "repo"]
```

### Extract the variables used in a given URL

```swift
let variables = template.extract("https://api.github.com/repos/kylef/PathKit/")
=> ["owner":"kylef", "repo":"PathKit"]
```

## [RFC6570](https://tools.ietf.org/html/rfc6570)

The URITemplate library follows the [test suite](https://github.com/uri-templates/uritemplate-test).

We have full support for level 4 of RFC6570 when expanding a template and retrieving the variables in a template.

For extraction of variables from an already expanded template, level 3 is supported.

## License

URITemplate is licensed under the MIT license. See [LICENSE](LICENSE) for more
info.
