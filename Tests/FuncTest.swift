//
//  FuncTest.swift
//  SBCommons
//
//  Created by Ed Gamble on 11/27/15.
//  Copyright © 2015 Opus Logica Inc. All rights reserved.
//
import XCTest
@testable import SBCommons

func allEven <S:SequenceType where Int == S.Generator.Element> (source: S) -> Bool {
  return source.all { 0 == $0 % 2 }
}

class FuncTest: XCTestCase {
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
  }
  
  func testAlways() {
    XCTAssertEqual(always(1)(y:2), 1)
  }
  
  func testComplement () {
    XCTAssertTrue (complement { $0 == 10 } ( 0))
    XCTAssertFalse(complement { $0 == 10 } (10))
  }
  
  func testCompose () {
    XCTAssertEqual(compose(f: { 10 * $0 }, g: { $0 +  3 }) (1), 40)
    XCTAssertEqual(compose(f: { $0 +  3 }, g: { 10 * $0 }) (1), 13)
    
    XCTAssertEqual(compose(f: { $0.utf8.count }, g: { $0 + "xyz" }) ("abc"), 6)
  }
  
  func testDisjoin () {
    XCTAssertEqual(disjoin(pred1: { $0 == 10 }, pred2: { $0 == 5 })(10), true)
    XCTAssertEqual(disjoin(pred1: { $0 == 10 }, pred2: { $0 == 5 })( 5), true)
    XCTAssertEqual(disjoin(pred1: { $0 == 10 }, pred2: { $0 == 5 })( 0), false)
  }
  
  func testConjoin () {
    XCTAssertEqual(conjoin(pred1: { 0 == $0 % 3 }, pred2: { 0 == $0 % 2 }) ( 6), true)
    XCTAssertEqual(conjoin(pred1: { 0 == $0 % 3 }, pred2: { 0 == $0 % 2 }) ( 3), false)
    XCTAssertEqual(conjoin(pred1: { 0 == $0 % 3 }, pred2: { 0 == $0 % 2 }) ( 2), false)
    XCTAssertEqual(conjoin(pred1: { 0 == $0 % 3 }, pred2: { 0 == $0 % 2 }) ( 0), true)
    XCTAssertEqual(conjoin(pred1: { 0 == $0 % 3 }, pred2: { 0 == $0 % 2 }) (60), true)
  }
  
  func testEqualTo () {
    XCTAssertEqual(equalTo(pred: ==, x: 10) (10), true)
    XCTAssertEqual(equalTo(pred: ==, x: 10) ( 5), false)
  }
  
  func testApp () {
    let seriesSum = { (n:Int) -> Int in return n * (n + 1) / 2 }
    var sum = 0
    
    Array(1...5).app { sum += $0 }
    XCTAssertEqual(sum, seriesSum(5))
  }
  
  func testAny () {
    XCTAssertEqual([0, 5, 10].any(equalTo(pred: ==, x: 5)), true)
    XCTAssertEqual([0, 7, 10].any(equalTo(pred: ==, x: 5)), false)
  }
  
  func testAll () {
    let divisibleBythree = { (x:Int) -> Bool in return 0 == x % 3 }
    
    XCTAssertEqual([0, 3, 6].all(divisibleBythree), true)
    XCTAssertEqual([0, 3, 7].all(divisibleBythree), false)
  }
  
  func testScan () {
    XCTAssertTrue([1,2,3,4,5].scan(120, combine: /).elementsEqual([120,120,60,20,5,1]))
    XCTAssertTrue([2,3,4,5].scan(1, combine: *).elementsEqual([1,2,6,24,120]))
  }
  
  func testEquateUsing () {
    XCTAssertEqual(equateUsing(==) (5) (5), true)
    XCTAssertEqual(equateUsing(==) (5) (2), false)
  }

  func testAnyUsing () {
    XCTAssertEqual(anyUsing({ $0 == 5 }) ([0, 5, 10]), true)
    XCTAssertEqual(anyUsing({ $0 == 5 }) ([0, 7, 10]), false)
    
    let anyFive : (Array<Int>) -> Bool = anyUsing ({ (x:Int) in return x == 5 })

    XCTAssertEqual(anyFive([0, 5, 10]), true)
    XCTAssertEqual(anyFive([0, 7, 10]), false)
  }

  func testAllUsing () {
    let allDivisibleByThree : (Array<Int>) -> Bool = allUsing({ 0 == $0 % 3 })
    
    XCTAssertEqual(allDivisibleByThree ([0, 3, 6]), true)
    XCTAssertEqual(allDivisibleByThree ([0, 4, 6]), false)
  }
  
  func testAppUsing () {
    var sum = 0;
    appUsing ({ (x:Int) -> Void in sum += x }) ([0, 1, 2])
    XCTAssertEqual (sum, 3)
  }

  func testPerformanceExample() {
    self.measureBlock {
    }
  }
}
