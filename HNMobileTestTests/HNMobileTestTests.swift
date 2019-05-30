//
//  HNMobileTestTests.swift
//  HNMobileTestTests
//
//  Created by Diego Sepúlveda on 5/29/19.
//  Copyright © 2019 reigndesign. All rights reserved.
//

import XCTest
@testable import HNMobileTest

class HNMobileTestTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testUserDefaultUtils() {
        // Given
        UserDefaultsUtils.clearData()

        let hit = Hit(storyTitle: "the story title", createdAtI: Int(123456), createdAt: "10-10-2020", storyUrl: "www.google.com", author: "Me", title: "the title", objectId: "123456789")
        var hits = UserDefaultsUtils.loadHits()

        XCTAssertNotNil(hits)
        XCTAssertTrue(hits.isEmpty)

        hits.append(hit)
        UserDefaultsUtils.saveHits(hits)

        let hitsWithOneHit = UserDefaultsUtils.loadHits()
        XCTAssertNotNil(hitsWithOneHit)
        XCTAssertTrue(hitsWithOneHit.count == 1)

        let hitSaved = hitsWithOneHit[0]
        XCTAssertTrue(hit.objectId! == hitSaved.objectId!)

    }

}
