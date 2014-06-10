//
//  Extensions.swift
//  Bite
//
//  Created by Brian Nickel on 6/10/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

struct Bite<T where T:Sequence> {
    let source:T
    
    init(_ source:T) {
        self.source = source
    }
}

extension Bite : Sequence {
    
    func generate() -> T.GeneratorType {
        return source.generate()
    }
}

extension Bite {

    func take(count: Int) -> Bite<TakeSequence<T>> {
        return Bite<TakeSequence<T>>(TakeSequence(source, count:count))
    }
    
    func skip(count: Int) -> Bite<SkipSequence<T>> {
        return Bite<SkipSequence<T>>(SkipSequence(source, count:count))
    }
    
    func filter(includeElement: T.GeneratorType.Element -> Bool) -> Bite<FilterSequenceView<T>> {
        return Bite<FilterSequenceView<T>>(Swift.filter(source, includeElement))
    }
    
    func map<U>(transform: T.GeneratorType.Element -> U) -> Bite<MapSequenceView<T, U>> {
        return Bite<MapSequenceView<T, U>>(Swift.map(source, transform))
    }
    
    func takeWhile(includeElement: T.GeneratorType.Element -> Bool) -> Bite<TakeWhileSequence<T>> {
        return Bite<TakeWhileSequence<T>>(TakeWhileSequence(source, includeElement))
    }
    
    func takeUntil(excludeElement: T.GeneratorType.Element -> Bool) -> Bite<TakeWhileSequence<T>> {
        return Bite<TakeWhileSequence<T>>(TakeWhileSequence(source, { !excludeElement($0) }))
    }
}

extension Bite {
    
    var count: Int {
        var count = 0
        for element in source {
            count++
        }
        return count
    }
    
    var firstElement: T.GeneratorType.Element? {
        for element in source {
            return element
        }
        return nil
    }
    
    var lastElement: T.GeneratorType.Element? {
        var lastElement:T.GeneratorType.Element? = nil
        for element in source {
            lastElement = element
        }
        return lastElement
    }
    
    func array() -> Array<T.GeneratorType.Element> {
        return Array(source)
    }
    
    func dictionary<KeyType : Hashable, ValueType>(pairs: T.GeneratorType.Element -> (KeyType, ValueType)) -> Dictionary<KeyType, ValueType> {
        var dictionary = Dictionary<KeyType, ValueType>()
        for element in source {
            let (key, value) = pairs(element)
            dictionary[key] = value
        }
        return dictionary
    }
    
    func groupBy<KeyType : Hashable>(transform: T.GeneratorType.Element -> KeyType) -> Bite<Dictionary<KeyType, Array<T.GeneratorType.Element>>> {
        
        var dictionary = Dictionary<KeyType, Array<T.GeneratorType.Element>>()
        for element in source {
            let key = transform(element)
            let foundArray = dictionary[key]
            var array = foundArray ? foundArray! : Array<T.GeneratorType.Element>()
            array += element
            dictionary[key] = array
        }
        return Bite<Dictionary<KeyType, Array<T.GeneratorType.Element>>>(dictionary)
    }
    
    func any(test: T.GeneratorType.Element -> Bool) -> Bool {
        for element in source {
            if test(element) {
                return true
            }
        }
        return false
    }
    
    func all(test: T.GeneratorType.Element -> Bool) -> Bool {
        for element in source {
            if !test(element) {
                return false
            }
        }
        return true
    }
    
    func foldLeft<U>(inital: U, combine: (U, T.GeneratorType.Element) -> U) -> U {
        return Bite.foldGeneratorLeft(source.generate(), initial: inital, combine)
    }
    
    func reduceLeft(combine: (T.GeneratorType.Element, T.GeneratorType.Element) -> T.GeneratorType.Element) -> T.GeneratorType.Element? {
        var generator = source.generate()
        if let initial = generator.next() {
            return Bite.foldGeneratorLeft(generator, initial: initial, combine)
        } else {
            return nil
        }
    }
    
    func foldRight<U>(inital: U, combine: (T.GeneratorType.Element, U) -> U) -> U {
        let reversed = Bite<Array<T.GeneratorType.Element>>(array().reverse())
        return reversed.foldLeft(inital, { combine($1, $0) })
    }
    
    func reduceRight(combine: (T.GeneratorType.Element, T.GeneratorType.Element) -> T.GeneratorType.Element) -> T.GeneratorType.Element? {
        let reversed = Bite<Array<T.GeneratorType.Element>>(array().reverse())
        return reversed.reduceLeft({ combine($1, $0) })
    }
    
    static func foldGeneratorLeft<G : Generator, U>(var generator: G, initial: U, combine: (U, G.Element) -> U) -> U {
        var value = initial
        while let element = generator.next() {
            value = combine(value, element)
        }
        return value
    }
}

@infix func + <T:Sequence, U:Sequence where T.GeneratorType.Element == U.GeneratorType.Element>(lhs:Bite<T>, rhs:U) -> Bite<AndSequence<Bite<T>,U>> {
    return Bite<AndSequence<Bite<T>,U>>(AndSequence(lhs, rhs))
}

@infix func + <T:Sequence, U where U == T.GeneratorType.Element>(lhs:Bite<T>, rhs:U) -> Bite<AndSequence<Bite<T>, Array<U>>> {
    return Bite<AndSequence<Bite<T>,Array<U>>>(AndSequence(lhs, [rhs]))
}
