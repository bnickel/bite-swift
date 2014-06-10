//
//  And.swift
//  Bite
//
//  Created by Brian Nickel on 6/16/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

struct AndGenerator<T:Generator, U:Generator where T.Element == U.Element> : Generator {
    var firstIsFinished = false
    var firstSource:T
    var secondSource:U
    
    init(_ firstSource:T, _ secondSource:U) {
        self.firstSource = firstSource
        self.secondSource = secondSource
    }
    
    mutating func next() -> T.Element? {
        if !firstIsFinished {
            if let element = firstSource.next() {
                return element
            }
            firstIsFinished = true
        }
        
        return secondSource.next()
    }
}

struct AndSequence<T:Sequence, U:Sequence where T.GeneratorType.Element == U.GeneratorType.Element> : Sequence {
    
    var firstSource:T
    var secondSource:U
    
    init(_ firstSource:T, _ secondSource:U) {
        self.firstSource = firstSource
        self.secondSource = secondSource
    }
    
    func generate() -> AndGenerator<T.GeneratorType, U.GeneratorType> {
        return AndGenerator<T.GeneratorType, U.GeneratorType>(firstSource.generate(), secondSource.generate())
    }
}
