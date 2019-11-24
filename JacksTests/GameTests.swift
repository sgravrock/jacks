import UIKit
import XCTest

class GameTests: XCTestCase {
    func testWinner() {
		let target = Game()
		for p in target.players {
			for i in 0...3 {
				p.hand[i] = Card(suit: Suit.clubs, value: CardValue.ace)
			}
		}
		
		target.players[2].hand[0] = Card(suit: Suit.clubs, value: CardValue.jack)
		XCTAssertTrue(target.winner() === target.players[2], "Wrong winner")
    }
	
	func testPlayerWithMostJacksWinsTies() {
		let target = Game()
		for i in 0...3 {
			let p = target.players[i]
			for i in 0...3 {
				p.hand[i] = Card(suit: Suit.clubs, value: CardValue.ten)
			}
		}
		
		target.players[0].hand[0] = Card(suit: Suit.diamonds, value: CardValue.jack)
		target.players[0].hand[1] = Card(suit: Suit.clubs, value: CardValue.ace)
		target.players[0].hand[2] = Card(suit: Suit.clubs, value: CardValue.nine)
		target.players[1].hand[0] = Card(suit: Suit.clubs, value: CardValue.jack)
		target.players[1].hand[1] = Card(suit: Suit.clubs, value: CardValue.jack)
		XCTAssertEqual(target.players[0].score(), target.players[1].score(), "Scores should be equal")
		XCTAssertTrue(target.winner() == target.players[1], "Wrong winner")
	}
	
	
	func testPlayerWithHighestJackWinsFurtherTies() {
		let target = Game()
		for p in target.players {
			for j in 0...3 {
				p.hand[j] = Card(suit: Suit.clubs, value: CardValue.ten)
			}
		}
		
		// Give players 1 and 2 each a pair of jacks. "High" jack according to
		// D,C,H,S order should win.
		target.players[0].hand[0] = Card(suit: Suit.hearts, value: CardValue.jack)
		target.players[0].hand[1] = Card(suit: Suit.clubs, value: CardValue.jack)
		target.players[1].hand[0] = Card(suit: Suit.diamonds, value: CardValue.jack)
		target.players[1].hand[1] = Card(suit: Suit.spades, value: CardValue.jack)
		XCTAssertTrue(target.winner() == target.players[1], "Wrong winner")
	}

}
