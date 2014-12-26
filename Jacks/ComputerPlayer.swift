import UIKit

protocol ComputerPlayerDelegate: class {
	func computerPlayer(computerPlayer: Player, didMove move: Move)
}

class ComputerPlayer: Player {
	weak var delegate: ComputerPlayerDelegate?
	private var cardsKnown = [true, true, false, false]
	private let replaceUnknownThreshold = 4
	private let takeDiscardThreshold = 4
	
	func takeTurn(game: Game) {
		let takeFromDiscard = game.topOfDiscards().points() <= takeDiscardThreshold
		let newCard = takeFromDiscard ? game.takeTopOfDiscards() : game.takeTopOfDeck()
		var move: Move
		
		if let i = indexOfChosenSlot(newCard) {
			move = Move(cardTakenFromDiscard: takeFromDiscard ? newCard : nil,
				cardDiscarded: hand[i])
			hand[i] = newCard
		} else {
			move = Move(cardTakenFromDiscard: takeFromDiscard ? newCard : nil,
				cardDiscarded: newCard)
		}
		
		game.discard(move.cardDiscarded)
		delegate?.computerPlayer(self, didMove: move)
	}
	
	func indexOfChosenSlot(newCard: Card) -> Int? {
		// Replace unknowns first if the new card is good enough.
		// Otherwise replace the first known card that's worse than the new card.
		if newCard.points() <= replaceUnknownThreshold {
			if let i = indexOfFirstUnkown() {
				return i
			}
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
				return i
			}
		}
		
		return nil
	}
}
