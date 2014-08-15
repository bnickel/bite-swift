# bite-swift

Bite is a lazy chaining functional enumeration library for Swift.

### Motivation

 - Swift has chained `filter`, `map`, etc functions on arrays, but they are not lazy.  If you only want the first element meeting your critera you will create multiple intermedate arrays.
 - Swift has global functions like `map` and `filter` but they are not lazy (every element will get mapped or filtered) and awkward to chain: `map(filter(seq, { ... }), { ... })`.
 - There are other beneficial transforms like `take(Int)`, `skip(Int)`, `groupBy(...)` and collectors `foldLeft(...)`, `any(...)`, that can be added.

### Prior art

 - For the Objective-C version, see [bnickel/bite-objc](https://github.com/bnickel/bite-objc).
 - Concept based on the [Bite Java library](https://bitbucket.org/balpha/bite/wiki/Home).

## Usage

### Installation

No idea.  It's a framework project right now, so ... take the built product?

### Creating a bite

```swift
let bite = Bite(myArray)

for item in Bite(myArray) {
    // Use directly in a for-in block.
}
```

### Chaining bites

```swift
let bite = Bite(myArray).filter({ $0.size.width < 100 })
let bite2 = bite.skip(5)

for picture in bite2.take(5).map(processImage) {
    self.doSomething(picture)
}
```

### Transforms

- `take(count: Int) -> Bite` Stops iterating after `count` elements are iterated.
- `skip(count: Int) -> Bite` Skips over `count` elements.
- `map<U>(transform: T.Generator.Element -> U) -> Bite` Passes each element through a mapping function and iterates the results.
- `filter(includeElement: T.Generator.Element -> Bool) -> Bite` Only iterates elements that pass a test.
- `takeWhile(includeElement: T.Generator.Element -> Bool) -> Bite` Stops iterating when the test fails.
- `takeUntil(excludeElement: T.Generator.Element -> Bool) -> Bite` Stops iterating when the test passes.
- `and(sequence:U) -> Bite` Concatenates with another sequence with the same element type.

### Evaluating/Collecting

- `var count: Int` Returns the number of elements in the enumerator.
- `var firstElement: T.Generator.Element?` Returns the first item or `nil` if the enumerator is empty.  Can be used safely on infinite sequences.
- `var lastElement: T.Generator.Element?` Returns the last item or `nil` if the enumerator is empty.

- `array() -> Array<T.Generator.Element>` Creates an array. **Sequence must be finite.**
- `dictionary(pairs: T.Generator.Element -> (KeyType, ValueType)) -> Dictionary<KeyType, ValueType>` Creates a dictionary.  If the enumerator already contains pairs, you can pass `{ $0 }` as the mapping function.
- `groupBy(transform: T.Generator.Element -> KeyType) -> Bite<Dictionary<KeyType, Array<T.GeneratorType.Element>>>`. Iterates through the group and generates pairs with the mapped key and an array of corresponding items.

- `any(test: T.Generator.Element -> Bool) -> Bool` Returns `true` if any item in the enumerator passes the test and stops iterating.
- `all(test: T.Generator.Element -> Bool) -> Bool` Returns `true` if all items in the enumerator pass the test.  Returns `false` and stops iterating as soon as the test fails.

- `foldLeft<U>(inital: U, combine: (U, T.Generator.Element) -> U) -> U` Folds left with an initial accumulator value.
- `foldRight<U>(inital: U, combine: (T.Generator.Element, U) -> U) -> U` Folds right with an initial accumulator value.

- `reduceLeft(combine: (T.Generator.Element, T.Generator.Element) -> T.Generator.Element) -> T.GeneratorType.Element?` Reduces left or returns `nil` if the sequence is empty.
- `reduceRight(combine: (T.Generator.Element, T.Generator.Element) -> T.Generator.Element) -> T.GeneratorType.Element? ` Reduces right or returns `nil` if the sequence is empty.


## Examples

1. Creating a dictionary from an item's properties.

    ```swift
    let networkUsersForSites = Bite(networkUsers).filter({ $0.siteUrl != nil }).dictionary({ ($0.siteUrl, $0) })
    ```

2. Finding the most active date on a blog:

    ```swift
    let calendar = NSCalendar.currentCalendar()
    let components:NSCalendarUnit = .CalendarUnitYear | .CalendarUnitMonth | .CalendarUnitDay

    if let (mostActiveDay, mostPostPerDay) = Bite(posts)
        .groupBy({ post -> NSDateComponents in calendar.components(components, fromDate: post.date) })
        .map({ ($0, $1.count ) })
        .reduceLeft({ $0.1 > $1.1 ? $0 : $1 }) {
            println("Your most active day was \(calendar.dateFromComponents(mostActiveDay)) with \(mostPostPerDay) posts")
    }

    ```
