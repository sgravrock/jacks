import UIKit
import XCTest

class PlayerTests: XCTestCase {
	func testNormalScores() {
		let target = Player(name: "test player")
		
		for i in 0...3 {
			target.hand.append(Card(suit: Suit.Clubs, value: i + 1))
		}
		
		XCTAssertEqual(target.score(), 1 + 2 + 3 + 4, "Wrong score")
	}

	func testJackScore() {
		let target = Player(name: "test player")
		
		for i in 0...2 {
			target.hand.append(Card(suit: Suit.Clubs, value: i + 1))
		}
		
		target.hand.append(Card(suit: Suit.Clubs, value: 11))
		XCTAssertEqual(target.score(), 1 + 2 + 3, "Wrong score")
	}
	
	func testOtherFaceCardScore() {
		let target = Player(name: "test player")
		target.hand.append(Card(suit: Suit.Clubs, value: 9))
		target.hand.append(Card(suit: Suit.Clubs, value: 10))
		target.hand.append(Card(suit: Suit.Clubs, value: 12))
		target.hand.append(Card(suit: Suit.Clubs, value: 13))
		XCTAssertEqual(target.score(), 9 + 10 + 12 + 13, "Wrong score")
	}
}
