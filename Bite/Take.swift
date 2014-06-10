//
//  Take.swift
//  Bite
//
//  Created by Brian Nickel on 6/11/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

struct TakeGenerator<T where T:Generator> : Generator {
    var remaining:Int
    var source:T
    
    init(_ source:T, count: Int) {
        self.remaining = count
        self.source = source
    }
    
    mutating func next() -> T.Element? {
        if remaining <= 0 { return nil }
        remaining -= 1
        return source.next()
    }
}

struct TakeSequence<T where T:Sequence> : Sequence {
    
    let count:Int
    let source:T
    
    init(_ source:T, count: Int) {
        self.count = count
        self.source = source
    }
    
    func generate() -> TakeGenerator<T.GeneratorType> {
        return TakeGenerator(source.generate(), count: count)
    }
}
