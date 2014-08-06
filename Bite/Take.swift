//
//  Take.swift
//  Bite
//
//  Created by Brian Nickel on 6/11/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

public struct TakeGenerator<T where T:GeneratorType> : GeneratorType {
    var remaining:Int
    var source:T
    
    init(_ source:T, count: Int) {
        self.remaining = count
        self.source = source
    }
    
    public mutating func next() -> T.Element? {
        if remaining <= 0 { return nil }
        remaining -= 1
        return source.next()
    }
}

public struct TakeSequence<T where T:SequenceType> : SequenceType {
    
    let count:Int
    let source:T
    
    init(_ source:T, count: Int) {
        self.count = count
        self.source = source
    }
    
    public func generate() -> TakeGenerator<T.Generator> {
        return TakeGenerator(source.generate(), count: count)
    }
}
