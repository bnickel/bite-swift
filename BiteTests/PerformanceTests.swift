//
//  BiteTests.swift
//  BiteTests
//
//  Created by Brian Nickel on 6/10/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

import XCTest
import Bite

class PerformanceTests: XCTestCase {
    
    func testBuiltIn() {
        self.measureBlock() {
            let x = filter(5..100000) { $0 % 5 == 0 }
            println(reduce(x, 0) { $1 - $0 })
        }
    }
    
    func testBite() {
        self.measureBlock() {
            let x = Bite(5..100000).filter() { $0 % 5 == 0 }
            println(reduce(x, 0) { $1 - $0 })
        }
    }
    
    func testRaw() {
        self.measureBlock() {
            var acc = 0
            for i in 5..100000 {
                if i % 5 == 0 {
                    acc = i - acc
                }
            }
            println(acc)
        }
    }
    
    func testRaw2() {
        self.measureBlock() {
            var acc = 0
            for i in (5..100000).by(5) {
                acc = i - acc
            }
            println(acc)
        }
    }
}
