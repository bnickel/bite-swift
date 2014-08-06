//
//  Extensions.swift
//  Bite
//
//  Created by Brian Nickel on 6/10/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

public struct Bite<T where T:SequenceType> {
    let source:T
    
    public init(_ source:T) {
        self.source = source
    }
}

extension Bite : SequenceType {
    
    public func generate() -> T.Generator {
        return source.generate()
    }
}

extension Bite {

    public func take(count: Int) -> Bite<TakeSequence<T>> {
        return Bite<TakeSequence<T>>(TakeSequence(source, count:count))
    }
    
    public func skip(count: Int) -> Bite<SkipSequence<T>> {
        return Bite<SkipSequence<T>>(SkipSequence(source, count:count))
    }
    
    public func filter(includeElement: T.Generator.Element -> Bool) -> Bite<FilterSequence<T>> {
        return Bite<FilterSequence<T>>(FilterSequence(source, includeElement))
    }
    
    public func map<U>(transform: T.Generator.Element -> U) -> Bite<MapSequence<T, U>> {
        return Bite<MapSequence<T, U>>(MapSequence(source, transform))
    }
    
    public func takeWhile(includeElement: T.Generator.Element -> Bool) -> Bite<TakeWhileSequence<T>> {
        return Bite<TakeWhileSequence<T>>(TakeWhileSequence(source, includeElement))
    }
    
    public func takeUntil(excludeElement: T.Generator.Element -> Bool) -> Bite<TakeWhileSequence<T>> {
        return Bite<TakeWhileSequence<T>>(TakeWhileSequence(source, { !excludeElement($0) }))
    }
    
    public func and<U:SequenceType where T.Generator.Element == U.Generator.Element>(sequence:U) -> Bite<AndSequence<T, U>> {
        return Bite<AndSequence<T, U>>(AndSequence(source, sequence))
    }
}

extension Bite {
    
    public var count: Int {
        var count = 0
        for element in source {
            count++
        }
        return count
    }
    
    public var firstElement: T.Generator.Element? {
        for element in source {
            return element
        }
        return nil
    }
    
    public var lastElement: T.Generator.Element? {
        var lastElement:T.Generator.Element? = nil
        for element in source {
            lastElement = element
        }
        return lastElement
    }
    
    public func array() -> Array<T.Generator.Element> {
        return Array(source)
    }
    
    public func dictionary<KeyType : Hashable, ValueType>(pairs: T.Generator.Element -> (KeyType, ValueType)) -> Dictionary<KeyType, ValueType> {
        var dictionary = Dictionary<KeyType, ValueType>()
        for element in source {
            let (key, value) = pairs(element)
            dictionary[key] = value
        }
        return dictionary
    }
    
    public func groupBy<KeyType : Hashable>(transform: T.Generator.Element -> KeyType) -> Bite<Dictionary<KeyType, Array<T.Generator.Element>>> {
        
        var dictionary = Dictionary<KeyType, Array<T.Generator.Element>>()
        for element in source {
            let key = transform(element)
            let foundArray = dictionary[key]
            var array = foundArray ?? Array<T.Generator.Element>()
            array += [element]
            dictionary[key] = array
        }
        return Bite<Dictionary<KeyType, Array<T.Generator.Element>>>(dictionary)
    }
    
    public func any(test: T.Generator.Element -> Bool) -> Bool {
        for element in source {
            if test(element) {
                return true
            }
        }
        return false
    }
    
    public func all(test: T.Generator.Element -> Bool) -> Bool {
        for element in source {
            if !test(element) {
                return false
            }
        }
        return true
    }
    
    public func foldLeft<U>(inital: U, combine: (U, T.Generator.Element) -> U) -> U {
        return Bite.foldGeneratorLeft(source.generate(), initial: inital, combine)
    }
    
    public func reduceLeft(combine: (T.Generator.Element, T.Generator.Element) -> T.Generator.Element) -> T.Generator.Element? {
        var generator = source.generate()
        if let initial = generator.next() {
            return Bite.foldGeneratorLeft(generator, initial: initial, combine)
        } else {
            return nil
        }
    }
    
    public func foldRight<U>(inital: U, combine: (T.Generator.Element, U) -> U) -> U {
        let reversed = Bite<Array<T.Generator.Element>>(array().reverse())
        return reversed.foldLeft(inital, { combine($1, $0) })
    }
    
    public func reduceRight(combine: (T.Generator.Element, T.Generator.Element) -> T.Generator.Element) -> T.Generator.Element? {
        let reversed = Bite<Array<T.Generator.Element>>(array().reverse())
        return reversed.reduceLeft({ combine($1, $0) })
    }
    
    public static func foldGeneratorLeft<G : GeneratorType, U>(var generator: G, initial: U, combine: (U, G.Element) -> U) -> U {
        var value = initial
        while let element = generator.next() {
            value = combine(value, element)
        }
        return value
    }
}
