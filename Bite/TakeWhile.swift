//
//  TakeWhile.swift
//  Bite
//
//  Created by Brian Nickel on 6/16/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

public struct TakeWhileGenerator<T where T:GeneratorType> : GeneratorType {
    let test:T.Element -> Bool
    var testFailed = false
    var source:T
    
    init(_ source:T, test:T.Element -> Bool) {
        self.test = test
        self.source = source
    }
    
    public mutating func next() -> T.Element? {
        if testFailed {
            return nil
        }
        
        if let element = source.next() {
            if test(element) {
                return element
            }
        }
        
        testFailed = true
        return nil
    }
}

public struct TakeWhileSequence<T where T:SequenceType> : SequenceType {
    
    let test:T.Generator.Element -> Bool
    let source:T
    
    init(_ source:T, test:T.Generator.Element -> Bool) {
        self.test = test
        self.source = source
    }
    
    public func generate() -> TakeWhileGenerator<T.Generator> {
        return TakeWhileGenerator(source.generate(), test: test)
    }
}
