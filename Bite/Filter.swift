//
//  Filter.swift
//  Bite
//
//  Created by Brian Nickel on 8/6/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

public struct FilterGenerator<T where T:GeneratorType> : GeneratorType {
    
    let includeElement:T.Element -> Bool
    var source:T
    
    init(_ source:T, includeElement: T.Element -> Bool) {
        self.includeElement = includeElement
        self.source = source
    }
    
    public mutating func next() -> T.Element? {
        while let element = source.next() {
            if includeElement(element) {
                return element
            }
        }
        
        return nil
    }
}

public struct FilterSequence<T where T:SequenceType> : SequenceType {
    
    let includeElement:T.Generator.Element -> Bool
    let source:T
    
    init(_ source:T, includeElement: T.Generator.Element -> Bool) {
        self.includeElement = includeElement
        self.source = source
    }
    
    public func generate() -> FilterGenerator<T.Generator> {
        return FilterGenerator(source.generate(), includeElement: includeElement)
    }
}