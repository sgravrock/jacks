import UIKit
import XCTest

class ComputerPlayerTests: XCTestCase, ComputerPlayerDelegate {
	var lastMove: Move?
	
	func testStrategy_takeDiscard() {
		let target = makePlayer([5, 6, 7, 8])
		let topDc = Card(suit: Suit.Clubs, value: CardValue.Four)
		let game = makeGame(nil)
		game.discard(topDc)
		target.takeTurn(game)
		XCTAssertTrue(lastMove != nil, "lastMove wasn't set")
		XCTAssertTrue(lastMove?.cardTakenFromDiscard != nil, "Card wasn't taken from discard")
		
		if let taken = lastMove?.cardTakenFromDiscard {
			// TODO: Is there a cleaner way to test memberwise equality of structures?
			let identical = taken.suit == topDc.suit && taken.value == topDc.value
			XCTAssertTrue(identical, "Wrong card was taken from discard")
		}
	}
		
	func testStrategy_dontTakeDiscard() {
		let target = makePlayer([5, 6, 7, 8])
		let game = makeGame(nil)
		game.discard(Card(suit: Suit.Clubs, value: CardValue.Five))
		target.takeTurn(game)
		XCTAssertTrue(lastMove != nil, "lastMove wasn't set")
		XCTAssertTrue(lastMove?.cardTakenFromDiscard == nil, "Card was taken from discard")
	}
	
	func testStrategy_replaceKnown() {
		let target = makePlayer([9, 10, 7, 8])
		let deck = Deck()
		let game = makeGame(deck)
		deck.cards.append(Card(suit: Suit.Clubs, value: CardValue.Nine))
		target.takeTurn(game)
		XCTAssertTrue(lastMove != nil, "lastMove wasn't set")
		XCTAssertEqual(target.hand[1].suit, Suit.Clubs, "Card wasn't placed correctly")
		XCTAssertEqual(target.hand[1].value, CardValue.Nine, "Card wasn't placed correctly")
		
		if let discarded = lastMove?.cardDiscarded {
			XCTAssertEqual(discarded.suit, Suit.Clubs, "Wrong card was discarded")
			XCTAssertEqual(discarded.value, CardValue.Ten, "Wrong card was discarded")
		}
	}
	
	func testStrategy_dontReplace() {
		let target = makePlayer([5, 6, 1, 1])
		let deck = Deck()
		let game = makeGame(deck)
		deck.cards.append(Card(suit: Suit.Clubs, value: CardValue.Six))
		target.takeTurn(game)
		XCTAssertTrue(lastMove != nil, "lastMove wasn't set")
		let values = target.hand.map({ $0.value.toRaw() })
		XCTAssertEqual(values, [5, 6, 1, 1], "Some cards were replaced")
	}
	
	// Creates a game with a high initial discard.
	// Tests that care about the contents of the deck should provide one.
	func makeGame(deck: Deck?) -> Game {
		let g = deck == nil ? Game() : Game(deck: deck!)
		g.discard(Card(suit: Suit.Clubs, value: CardValue.King))
		return g
	}
	
	func makePlayer(cardValues: [Int]) -> ComputerPlayer {
		let p = ComputerPlayer(name: "test player")
		p.hand = cardValues.map({Card(suit: Suit.Clubs, value: CardValue.fromRaw($0)!)})
		p.delegate = self
		return p
	}
	
	func computerPlayer(computerPlayer: Player, didMove move: Move) {
		lastMove = move
	}
}
