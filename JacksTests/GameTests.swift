import UIKit
import XCTest

class GameTests: XCTestCase {
    func testWinner() {
		let target = Game()
		for p in target.players {
			for i in 0...3 {
				p.hand[i] = Card(suit: Suit.Clubs, value: CardValue.Ace)
			}
		}
		
		target.players[2].hand[0] = Card(suit: Suit.Clubs, value: CardValue.Jack)
		XCTAssertTrue(target.winner() === target.players[2], "Wrong winner")
    }
}
