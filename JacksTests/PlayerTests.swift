import UIKit
import XCTest

class PlayerTests: XCTestCase {
	func testNormalScores() {
		let target = Player(name: "test player")
		
		for i in 0...3 {
			target.hand.append(Card(suit: Suit.Clubs, value: CardValue.fromRaw(i + 1)!))
		}
		
		XCTAssertEqual(target.score(), 1 + 2 + 3 + 4, "Wrong score")
	}

	func testJackScore() {
		let target = Player(name: "test player")
		
		for i in 0...2 {
			target.hand.append(Card(suit: Suit.Clubs, value: CardValue.fromRaw(i + 1)!))
		}
		
		target.hand.append(Card(suit: Suit.Clubs, value: CardValue.Jack))
		XCTAssertEqual(target.score(), 1 + 2 + 3, "Wrong score")
	}
	
	func testOtherFaceCardScore() {
		let target = Player(name: "test player")
		target.hand.append(Card(suit: Suit.Clubs, value: CardValue.Nine))
		target.hand.append(Card(suit: Suit.Clubs, value: CardValue.Ten))
		target.hand.append(Card(suit: Suit.Clubs, value: CardValue.Queen))
		target.hand.append(Card(suit: Suit.Clubs, value: CardValue.King))
		XCTAssertEqual(target.score(), 9 + 10 + 10 + 10, "Wrong score")
	}
}
