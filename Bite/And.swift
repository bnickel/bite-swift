//
//  And.swift
//  Bite
//
//  Created by Brian Nickel on 6/16/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

public struct AndGenerator<T:GeneratorType, U:GeneratorType where T.Element == U.Element> : GeneratorType {
    var firstIsFinished = false
    var firstSource:T
    var secondSource:U
    
    init(_ firstSource:T, _ secondSource:U) {
        self.firstSource = firstSource
        self.secondSource = secondSource
    }
    
    public mutating func next() -> T.Element? {
        if !firstIsFinished {
            if let element = firstSource.next() {
                return element
            }
            firstIsFinished = true
        }
        
        return secondSource.next()
    }
}

public struct AndSequence<T:SequenceType, U:SequenceType where T.Generator.Element == U.Generator.Element> : SequenceType {
    
    var firstSource:T
    var secondSource:U
    
    init(_ firstSource:T, _ secondSource:U) {
        self.firstSource = firstSource
        self.secondSource = secondSource
    }
    
    public func generate() -> AndGenerator<T.Generator, U.Generator> {
        return AndGenerator<T.Generator, U.Generator>(firstSource.generate(), secondSource.generate())
    }
}
