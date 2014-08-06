//
//  BiteTests.swift
//  Bite
//
//  Created by Brian Nickel on 6/12/14.
//  Copyright (c) 2014 Brian Nickel. All rights reserved.
//

import XCTest
import Bite

class BiteTests: XCTestCase {
    
    //var primes:PrimeSequence!
    let numbers = 0 ..< 100
    let even = stride(from: 0, through: 98, by: 2)
    let odd = stride(from: 1, through: 99, by: 2)

    override func setUp() {
        super.setUp()
        //primes = PrimeSequence()
    }
    
    func testThatTakeLimitsTheAmountTaken() {
        let bite = Bite(numbers)
        XCTAssertEqual(10, bite.take(10).count, "Take should have limited the count.");
        XCTAssertEqual(20, bite.take(20).count, "Take should have limited the count.");
        let numberOfNumbers = countElements(numbers)
        XCTAssertEqual(numberOfNumbers, bite.take(numberOfNumbers + 1).count, "Take should not have overrun.");
    }
    
    func testThatTakeLimitsTheNumberOfIteratorExecutions() {
        
        var executionCount = 0
        let bite = Bite(numbers).map() { x -> Int in
            executionCount += 1
            return x
        }
        
        let firstCount = bite.take(10).count
        XCTAssertEqual(executionCount, firstCount, "Should have limited the number of times map executed")
        
        executionCount = 0
        let secondCount = bite.take(30).count
        XCTAssertEqual(executionCount, secondCount, "Should have limited the number of times map executed")
    }
    
    func testThatTakeReturnsTheFrontOfTheEnumerator() {
        let expected = Array(0 ..< 10)
        let actual = Bite(numbers).take(10).array()
        XCTAssertTrue(expected == actual, "\(expected) did not equal \(actual)")
    }
    
    func testSkip() {
        let expected = Array(15 ..< 20)
        let actual = Bite(numbers).skip(15).take(5).array()
        XCTAssertTrue(expected == actual, "\(expected) did not equal \(actual)")
    }
    
    func testMap() {
        let expected = ["0", "1", "2"]
        let actual = Bite(numbers).map({ "\($0)" }).take(3).array()
        XCTAssertTrue(expected == actual, "\(expected) did not equal \(actual)")
    }
    
    func testFilter() {
        let expected = Array(even)
        let actual = Bite(numbers).filter({ $0 % 2 == 0 }).array()
        XCTAssertTrue(expected == actual, "\(expected) did not equal \(actual)")
    }
    
    func testAddition() {
        let expected = Array(numbers)
        let actual = sorted(Bite(odd).and(even))
        XCTAssertTrue(expected == actual, "\(expected) did not equal \(actual)")
    }
    
    func testAdditionOfOne() {
        let expected = [1,2,3,4]
        let actual = Bite([1,2,3]).and([4]).array()
        XCTAssertTrue(expected == actual, "\(expected) did not equal \(actual)")
    }
    
    func testDictionary() {
        let items = Bite(["hElLo", "wOrld"]).dictionary({ ( $0.uppercaseString, $0.lowercaseString ) })
        XCTAssertEqual("hello", items["HELLO"]!, "Should have transformed")
        XCTAssertEqual("world", items["WORLD"]!, "Should have transformed")
    }
    
    func testGroupBy() {
        let results = Bite(numbers).groupBy({ $0 % 2 == 0 ? "even" : "odd" }).dictionary({ $0 })
        XCTAssertEqual(2, results.count, "Should have two groups")
        XCTAssertTrue(Array(even) == results["even"]!, "Should have matched evens")
        XCTAssertTrue(Array(odd) == results["odd"]!, "Should have matched evens")
    }
    
    func testFirstElement() {
        let expected:Int = 82
        let actual = Bite(even).filter({ $0 > 81 }).firstElement
        XCTAssertTrue(expected == actual, "\(expected) did not equal \(actual)")
    }
    
    func testLastElement() {
        let expected:Int = 82
        let actual = Bite(even).filter({ $0 < 83 }).lastElement
        XCTAssertTrue(expected == actual, "\(expected) did not equal \(actual)")
    }
    
    func testThatFirstElementReturnsNil () {
        let expected:Int? = nil
        let actual = Bite(numbers).filter({ $0 > 1000 }).firstElement
        XCTAssertTrue(expected == actual, "\(expected) did not equal \(actual)")
    }
    
    func testThatLastElementReturnsNil () {
        let expected:Int? = nil
        let actual = Bite(numbers).filter({ $0 > 1000 }).lastElement
        XCTAssertTrue(expected == actual, "\(expected) did not equal \(actual)")
    }
    
    func testFoldLeft() {
        let result = Bite(1 ..< 3).foldLeft("i") { "(\($0)) - (\($1))" }
        XCTAssertEqual("((i) - (1)) - (2)", result, "Should have folded left")
    }
    
    func testReduceLeft() {
        let shortestWord = Bite(["space", "ant", "cart", "squash", "bug", "time"]).reduceLeft({ acc, word in return word.utf16Count < acc.utf16Count ? word : acc })!
        XCTAssertEqual("ant", shortestWord, "Should have folded left.")
    }
    
    func testFoldRight() {
        let result = Bite(1 ..< 3).foldRight("i") { "(\($0)) - (\($1))" }
        XCTAssertEqual("(1) - ((2) - (i))", result, "Should have folded left")
    }
    
    func testReduceRight() {
        let shortestWord = Bite(["space", "ant", "cart", "squash", "bug", "time"]).reduceRight({ word, acc in return word.utf16Count < acc.utf16Count ? word : acc })!
        XCTAssertEqual("bug", shortestWord, "Should have folded left.")
    }
}
