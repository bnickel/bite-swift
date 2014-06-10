//
//  TakeWhile.swift
//  Bite
//
//  Created by Brian Nickel on 6/16/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

struct TakeWhileGenerator<T where T:Generator> : Generator {
    let test:T.Element -> Bool
    var testFailed = false
    var source:T
    
    init(_ source:T, test:T.Element -> Bool) {
        self.test = test
        self.source = source
    }
    
    mutating func next() -> T.Element? {
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

struct TakeWhileSequence<T where T:Sequence> : Sequence {
    
    let test:T.GeneratorType.Element -> Bool
    let source:T
    
    init(_ source:T, test:T.GeneratorType.Element -> Bool) {
        self.test = test
        self.source = source
    }
    
    func generate() -> TakeWhileGenerator<T.GeneratorType> {
        return TakeWhileGenerator(source.generate(), test: test)
    }
}
