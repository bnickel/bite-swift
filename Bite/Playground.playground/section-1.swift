// Playground - noun: a place where people can play

import Foundation
/*
struct PrimeGenerator:Generator {
    let sequence:PrimeSequence
    var index = 0
    
    init (_ sequence:PrimeSequence) {
        self.sequence = sequence
    }
    
    mutating func next() -> Int? {
        
        if index == sequence.knownPrimes.count {
            sequence.findNextPrime()
        }
        
        return sequence.knownPrimes[index++]
    }
}

class PrimeSequence:Sequence {
    var knownPrimes = [2]
    
    func generate() -> PrimeGenerator {
        return PrimeGenerator(self)
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

for i in PrimeSequence() {
    if i > 1000 { break }
    println(i)
}
*/