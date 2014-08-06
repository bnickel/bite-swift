//
//  Skip.swift
//  Bite
//
//  Created by Brian Nickel on 6/16/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

public struct SkipGenerator<T where T:GeneratorType> : GeneratorType {
    let count:Int
    var source:T
    var skipped = false
    
    init(_ source:T, count: Int) {
        self.count = count
        self.source = source
    }
    
    public mutating func next() -> T.Element? {
        if !skipped {
            skipped = true
            var remaining = count
            while remaining > 0 && source.next() != nil {
                remaining--
            }
        }
        return source.next()
    }
}

public struct SkipSequence<T where T:SequenceType> : SequenceType {
    
    let count:Int
    let source:T
    
    init(_ source:T, count: Int) {
        self.count = count
        self.source = source
    }
    
    public func generate() -> SkipGenerator<T.Generator> {
        return SkipGenerator(source.generate(), count: count)
    }
}
