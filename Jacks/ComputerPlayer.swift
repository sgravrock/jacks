import UIKit

protocol ComputerPlayerDelegate: class {
	func computerPlayer(computerPlayer: Player, didMove move: Move)
}

class ComputerPlayer: Player {
	weak var delegate: ComputerPlayerDelegate?
	private var cardsKnown = [true, true, false, false]
	private let replaceUnknownThreshold = 4
	private let takeDiscardThreshold = 4
	private let willLogStrategy = false
	
	func takeTurn(game: Game) {
		logStrategy("Begin \(name) turn")
		logStrategy("Initial hand: \(formatHandForLogging())")
		let takeFromDiscard = game.topOfDiscards().points() <= takeDiscardThreshold
		let newCard = takeFromDiscard ? game.takeTopOfDiscards() : game.takeTopOfDeck()
		var move: Move

		if takeFromDiscard {
			logStrategy("Taking top discard: \(newCard)")
		} else {
			logStrategy("Skipping top discard \(game.topOfDiscards()) and taking \(newCard) from deck")
		}

		if let i = indexOfChosenSlot(newCard) {
			move = Move(cardTakenFromDiscard: takeFromDiscard ? newCard : nil,
				cardDiscarded: hand[i])
			hand[i] = newCard
			cardsKnown[i] = true
		} else {
			move = Move(cardTakenFromDiscard: takeFromDiscard ? newCard : nil,
				cardDiscarded: newCard)
		}
		
		game.discard(move.cardDiscarded)
		logStrategy("Final hand: \(formatHandForLogging())")
		logStrategy("End \(name) turn")
		delegate?.computerPlayer(self, didMove: move)
	}
	
	func indexOfChosenSlot(newCard: Card) -> Int? {
		// Replace unknowns first if the new card is good enough.
		// Otherwise replace the first known card that's worse than the new card.
		if newCard.points() <= replaceUnknownThreshold {
			if let i = indexOfFirstUnkown() {
				logStrategy("Replacing unknown in slot \(i)")
				return i
			}
			
			logStrategy("Looked for an unknown slot but didn't find one")
		}
		
		return indexOfFirstKnownWorseCard(newCard)
	}
	
	func indexOfFirstUnkown() -> Int? {
		for i in 0...cardsKnown.count - 1 {
			if !cardsKnown[i] {
				return i
			}
		}
		
		return nil
	}
	
	func indexOfFirstKnownWorseCard(newCard: Card) -> Int? {
		for i in 0...cardsKnown.count - 1 {
			if cardsKnown[i] && hand[i].points() > newCard.points() {
				logStrategy("Replacing worse card in slot \(i): \(hand[i])")
				return i
			}
		}
		
		logStrategy("Looked for a known worse card but didn't find one")
		return nil
	}
	
	func logStrategy(msg: String) {
		if willLogStrategy {
			println(msg)
		}
	}
	
	func formatHandForLogging() -> String {
		var result = ""
		
		for i in 0..<hand.count {
			let known = cardsKnown[i] ? "k" : "u"
			result += "\(hand[i].value)(\(known))"
			
			if i < hand.count - 1 {
				result += ", "
			}
		}
		
		return result
	}
}
