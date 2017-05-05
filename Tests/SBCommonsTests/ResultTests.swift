//
//  ResultTest.swift
//  SBCommons
//
//  Created by Ed Gamble on 10/22/15.
//  Copyright © 2015 Opus Logica Inc. All rights reserved.
//
@testable import SBCommons
import XCTest
import Foundation

class ResultTests: XCTestCase {

  enum TestError: Error {
    case one
    case two
  }
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testResultOne() {
    let r1 : Result<Int,TestError> = Result.success(10)

    XCTAssertTrue(nil != r1.value)
    XCTAssertEqual(10, r1.valueOrOther(0))

    let r2 : Result<Int,TestError> = Result.failure(TestError.one)
    
    XCTAssertTrue(nil == r2.value)
    XCTAssertEqual(10, r2.valueOrOther(10))
    
    let r3 : Result<Int,TestError> = Result.success(1)
    
    XCTAssertEqual(100, r3.map { (v:Int) -> Int in return 100 }.valueOrOther(0))

    _ = Result<Int,TestError>.success(1)
    
    //    XCTAssertEqual(r4, Result<Int,TestError>.Success)
    
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
  }
}


#if os(Linux)
extension ResultTests: XCTestCaseProvider {
  var allTests : [(String, () throws -> Void)] {
    return [
      ("testResultOne", testResultOne)
    ]
  }
}
#endif
