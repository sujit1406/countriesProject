//
//  ContentAnalyserHashtagTests.swift
//  CrossChatTests
//
//  Created by Sujith Antony on 13/01/19.
//  Copyright © 2019 Crossover. All rights reserved.
//

import XCTest

class ContentAnalyserHashtagTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHashtagAtTheBeginning() {
        let extracted = try! ContentAnalyser.extractHashtags(from: "#word mention")
        let expected = ["word"]
        
        XCTAssertEqual(extracted, expected, "Failed to extract hashtag at the beginning")
    }
    
    func testHashtagWithLeadingSpace() {
        let extracted = try! ContentAnalyser.extractHashtags(from: " #word mention")
        let expected = ["word"]
        
        XCTAssertEqual(extracted, expected, "Failed to extract hashtag with leading space")
    }
    
    func testHashtagInMidText() {
        let extracted = try! ContentAnalyser.extractHashtags(from: "Hashtag #word here")
        let expected = ["word"]
        
        XCTAssertEqual(extracted, expected, "Failed to extract hashtag in mid text")
    }
    
    func testMultipleHashtags() {
        let extracted = try! ContentAnalyser.extractHashtags(from: "hashtag #word1 here and #word2 here")
        let expected = ["word1", "word2"]
        
        XCTAssertEqual(extracted, expected, "Failed to extract multiple mentioned words")
    }
    
    func testInvalidHashtags() {
        let extracted = try! ContentAnalyser.extractHashtags(from: "# invalid hashtag.")
        let expected: [String] = []
        
        XCTAssertEqual(extracted, expected,"Extracted an invalid hashtag: \(extracted)")
    }
    
    func testMentionWithIndices() {
        let extracted = try! ContentAnalyser.extractHashtagsWithIndices(from:" #word1 hashtag #word2 here #word3 ")
        
        XCTAssertEqual(extracted.count, 3)
        XCTAssertEqual(extracted[0].start, 1)
        XCTAssertEqual(extracted[0].end, 7)
        XCTAssertEqual(extracted[1].start, 16)
        XCTAssertEqual(extracted[1].end, 22)
        XCTAssertEqual(extracted[2].start, 28)
        XCTAssertEqual(extracted[2].end, 34)
    }
}
