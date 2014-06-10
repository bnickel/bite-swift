//
//  Skip.swift
//  Bite
//
//  Created by Brian Nickel on 6/16/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

struct SkipGenerator<T where T:Generator> : Generator {
    let count:Int
    var source:T
    var skipped = false
    
    init(_ source:T, count: Int) {
        self.count = count
        self.source = source
    }
    
    mutating func next() -> T.Element? {
        if !skipped {
            skipped = true
            var remaining = count
            while remaining > 0 && source.next() {
                remaining--
            }
        }
        return source.next()
    }
}

struct SkipSequence<T where T:Sequence> : Sequence {
    
    let count:Int
    let source:T
    
    init(_ source:T, count: Int) {
        self.count = count
        self.source = source
    }
    
    func generate() -> SkipGenerator<T.GeneratorType> {
        return SkipGenerator(source.generate(), count: count)
    }
}
