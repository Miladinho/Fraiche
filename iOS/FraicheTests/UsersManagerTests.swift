//
//  FraicheTests.swift
//  FraicheTests
//
//  Created by Milad  on 11/25/16.
//  Copyright © 2016 Milad . All rights reserved.
//

import XCTest
import UIKit
@testable import Fraiche

class UsersManagerTests: XCTestCase {
    
    var vc : UsersManager!
    
    override func setUp() {
        super.setUp()
        //let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        //vc = storyboard.instantiateInitialViewController() as!
        
        self.vc = UsersManager()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLoginUser() {
        XCTASSERT(self.vc.loginUser(),true)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
