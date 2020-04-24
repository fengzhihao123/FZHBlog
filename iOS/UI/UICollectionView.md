# LearniOS

## Swift

### Closures

#### Closure Expression Syntax

* syntax

```
{ (`parameters`) -> return `type` in
    `statements`
}
```

The parameters in closure expression syntax can be in-out parameters, but they can’t have a default value. Variadic parameters can be used if you name the variadic parameter. Tuples can also be used as parameter types and return types

* Inferring Type From Context

```
reversedNames = names.sorted(by: { s1, s2 in return s1 > s2 } )
```

* Implicit Returns from Single-Expression Closures
Here, the function type of the sorted(by:) method’s argument makes it clear that a Bool value must be returned by the closure. Because the closure’s body contains a single expression (s1 > s2) that returns a Bool value, there is no ambiguity, and the return keyword can be omitted.

```
reversedNames = names.sorted(by: { s1, s2 in s1 > s2 } )
```

* Shorthand Argument Names
Swift automatically provides shorthand argument names to inline closures, which can be used to refer to the values of the closure’s arguments by the names $0, $1, $2, and so on.
The in keyword can also be omitted, because the closure expression is made up entirely of its body
```
reversedNames = names.sorted(by: { $0 > $1 } )
```

* Operator Methods
There’s actually an even shorter way to write the closure expression above. Swift’s String type defines its string-specific implementation of the greater-than operator (>) as a method that has two parameters of type String, and returns a value of type Bool. This exactly matches the method type needed by the sorted(by:) method. Therefore, you can simply pass in the greater-than operator, and Swift will infer that you want to use its string-specific implementation
```
reversedNames = names.sorted(by: >)
```
