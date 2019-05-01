//
//  FamilyArchivesTests.swift
//  FamilyArchivesTests
//
//  Created by Zoe Henry on 4/10/19.
//  Copyright © 2019 Zoe Henry. All rights reserved.
//

import XCTest
@testable import FamilyArchives

class FamilyArchivesTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //MARK: PersonEvent Class Tests
    // Confirm that the PersonEvent initializer returns a PersonEvent object when passed valid parameters.
    func testPersonEventInitializationSucceeds() {
        let audioURL = URL(string: "")
        let personEventWithName = PersonEvent.init(name: "Test1", photo: nil, audioURL: audioURL, personEventDescription: "")
        let personEventWithNameAndDescription = PersonEvent.init(name: "Test2", photo: nil, audioURL: audioURL, personEventDescription: "Test Description")

        XCTAssertNotNil(personEventWithName)
        XCTAssertNotNil(personEventWithNameAndDescription)

    }

    func testPersonEventInitializationFails() {
        let audioURL = URL(string: "")
        let personEventWithoutName = PersonEvent.init(name: "", photo: nil, audioURL: audioURL, personEventDescription: "")

        XCTAssertNil(personEventWithoutName)
    }

}
