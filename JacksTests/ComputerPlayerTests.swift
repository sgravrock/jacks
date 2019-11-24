import UIKit
import XCTest

class ComputerPlayerTests: XCTestCase, ComputerPlayerDelegate {
	var lastMove: Move?
	
	func testStrategy_takeDiscard() {
		let target = makePlayer([5, 6, 7, 8])
		let topDc = Card(suit: Suit.clubs, value: CardValue.four)
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
		game.discard(Card(suit: Suit.clubs, value: CardValue.five))
		target.takeTurn(game)
		XCTAssertTrue(lastMove != nil, "lastMove wasn't set")
		XCTAssertTrue(lastMove?.cardTakenFromDiscard == nil, "Card was taken from discard")
	}
	
	func testStrategy_replaceKnown() {
		let target = makePlayer([9, 10, 7, 8])
		let deck = Deck()
		let game = makeGame(deck)
		deck.cards.append(Card(suit: Suit.clubs, value: CardValue.nine))
		target.takeTurn(game)
		XCTAssertTrue(lastMove != nil, "lastMove wasn't set")
		XCTAssertEqual(target.hand[1].suit, Suit.clubs, "Card wasn't placed correctly")
		XCTAssertEqual(target.hand[1].value, CardValue.nine, "Card wasn't placed correctly")
		
		if let discarded = lastMove?.cardDiscarded {
			XCTAssertEqual(discarded.suit, Suit.clubs, "Wrong card was discarded")
			XCTAssertEqual(discarded.value, CardValue.ten, "Wrong card was discarded")
		}
	}
	
	func testStrategy_dontReplace() {
		let target = makePlayer([5, 6, 1, 1])
		let deck = Deck()
		let game = makeGame(deck)
		deck.cards.append(Card(suit: Suit.clubs, value: CardValue.six))
		target.takeTurn(game)
		XCTAssertTrue(lastMove != nil, "lastMove wasn't set")
		let values = target.hand.map({ $0.value.rawValue })
		XCTAssertEqual(values, [5, 6, 1, 1], "Some cards were replaced")
	}
	
	func testDoesntDiscardCardTakenFromDiscard() {
		let target = makePlayer([3, 3, 10, 10])
		XCTAssertEqual(target.takeDiscardThreshold, 4, "Test may need to be updated")
		let game = makeGame(Deck())
		let suspectCard = Card(suit: Suit.clubs, value: CardValue.four)
		game.discard(suspectCard)
		game.discard(Card(suit: Suit.clubs, value: CardValue.jack))
		game.discard(Card(suit: Suit.spades, value: CardValue.jack))
		// Player should replace the two unknowns with the jacks from the discard.
		target.takeTurn(game)
		_ = game.takeTopOfDiscards() // Remove away whatever the player just discarded
		target.takeTurn(game)
		XCTAssertEqual(target.hand.map({ $0.value }),
			[CardValue.three, CardValue.three, CardValue.jack, CardValue.jack], "Wrong hand")
		_ = game.takeTopOfDiscards() // Remove away whatever the player just discarded
		XCTAssertEqual(game.topOfDiscards()!, suspectCard, "Wrong top discard")
		
		// The player now knows that all four cards are better than the top discard.
		// So even though the top discard is better than the player's take threshold,
		// The card should not be taken.
		target.takeTurn(game)
		
		XCTAssertNil(lastMove?.cardTakenFromDiscard, "Discard was taken")
	}

	// Creates a game with a high initial discard.
	// Tests that care about the contents of the deck should provide one.
	func makeGame(_ deck: Deck?) -> Game {
		let g = deck == nil ? Game() : Game(deck: deck!)
		g.discard(Card(suit: Suit.clubs, value: CardValue.king))
		return g
	}
	
	func makePlayer(_ cardValues: [Int]) -> ComputerPlayer {
		let p = ComputerPlayer(name: "test player")
		p.hand = cardValues.map({Card(suit: Suit.clubs, value: CardValue(rawValue: $0)!)})
		p.delegate = self
		return p
	}
	
	func computerPlayer(_ computerPlayer: Player, didMove move: Move) {
		lastMove = move
	}
}
