//
//  Map.swift
//  Bite
//
//  Created by Brian Nickel on 8/6/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

public struct MapGenerator<T:GeneratorType, U> : GeneratorType {
    
    let transform:T.Element -> U
    var source:T
    
    init(_ source:T, transform: T.Element -> U) {
        self.transform = transform
        self.source = source
    }
    
    public mutating func next() -> U? {
        
        if let element = source.next() {
            return transform(element)
        }
        
        return nil
    }
}

public struct MapSequence<T:SequenceType, U> : SequenceType {
    
    let transform:T.Generator.Element -> U
    let source:T
    
    init(_ source:T, transform: T.Generator.Element -> U) {
        self.transform = transform
        self.source = source
    }
    
    public func generate() -> MapGenerator<T.Generator, U> {
        return MapGenerator(source.generate(), transform: transform)
    }
}