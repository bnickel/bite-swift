//
//  PrimeSequence.swift
//  Bite
//
//  Created by Brian Nickel on 6/12/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

import Foundation

struct PrimeGenerator:Generator {
    let source:PrimeSequence
    var index = 0
    
    init (_ source:PrimeSequence) {
        self.source = source
    }
    
    mutating func next() -> Int? {
        return source[index++]
    }
}

class PrimeSequence:NSObject, Sequence {
    
    var knownPrimes = [2]
    
    func generate() -> PrimeGenerator {
        return PrimeGenerator(self)
    }
    
    subscript (i: Int) -> Int {
        while knownPrimes.count <= i { findNextPrime() }
        return knownPrimes[i]
    }
    
    func findNextPrime() {
        var lastKnownPrime = knownPrimes[knownPrimes.count - 1]
        while isDivisibleByKnownPrimes(++lastKnownPrime) { }
        knownPrimes += lastKnownPrime
    }
    
    func isDivisibleByKnownPrimes(number:Int) -> Bool {
        
        let limit = Int(ceilf(sqrtf(CFloat(number))));
        
        for prime in knownPrimes {
            if number % prime == 0 { return true }
            if prime > limit { break }
        }
        
        return false
    }
}
