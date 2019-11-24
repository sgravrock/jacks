import UIKit
import XCTest

class PlayerTests: XCTestCase {
	func testNormalScores() {
		let target = Player(name: "test player")
		
		for i in 0...3 {
			target.hand.append(Card(suit: Suit.clubs, value: CardValue(rawValue: i + 1)!))
		}
		
		XCTAssertEqual(target.score(), 1 + 2 + 3 + 4, "Wrong score")
	}

	func testJackScore() {
		let target = Player(name: "test player")
		
		for i in 0...2 {
			target.hand.append(Card(suit: Suit.clubs, value: CardValue(rawValue: i + 1)!))
		}
		
		target.hand.append(Card(suit: Suit.clubs, value: CardValue.jack))
		XCTAssertEqual(target.score(), 1 + 2 + 3, "Wrong score")
	}
	
	func testOtherFaceCardScore() {
		let target = Player(name: "test player")
		target.hand.append(Card(suit: Suit.clubs, value: CardValue.nine))
		target.hand.append(Card(suit: Suit.clubs, value: CardValue.ten))
		target.hand.append(Card(suit: Suit.clubs, value: CardValue.queen))
		target.hand.append(Card(suit: Suit.clubs, value: CardValue.king))
		XCTAssertEqual(target.score(), 9 + 10 + 10 + 10, "Wrong score")
	}
}
