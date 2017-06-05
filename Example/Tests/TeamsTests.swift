//
//  TeamsTests.swift
//  MixerAPI
//
//  Created by Jack Cook on 7/13/16.
//  Copyright (c) 2017 Microsoft Corporation. All rights reserved.
//

import MixerAPI
import XCTest

class TeamsTests: XCTestCase {
    
    let teamId = 111
    let teamToken = "partners"
    
    func testTeamWithId() {
        let expectation = self.expectation(description: "tests retrieving a team by id")
        
        MixerClient.sharedClient.teams.getTeamWithId(teamId) { (team, error) in
            XCTAssertNotNil(team)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testTeamWithToken() {
        let expectation = self.expectation(description: "tests retrieving a team by token")
        
        MixerClient.sharedClient.teams.getTeamWithToken(teamToken) { (team, error) in
            XCTAssertNotNil(team)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testTeams() {
        let expectation = self.expectation(description: "tests the teams endpoint")
        
        MixerClient.sharedClient.teams.getTeams { (teams, error) in
            XCTAssertNotNil(teams)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testMembersOfTeam() {
        let expectation = self.expectation(description: "tests retrieving the members of a stream team")
        
        MixerClient.sharedClient.teams.getMembersOfTeam(teamId) { (users, error) in
            XCTAssertNotNil(users)
            XCTAssertNil(error)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
}
