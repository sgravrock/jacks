import UIKit

class Deck: NSObject {
	var cards = [Card]()
	
	override init() {
		for suit in [Suit.Clubs, Suit.Hearts, Suit.Spades, Suit.Diamonds] {
			for value in 1...13 {
				cards.append(Card(suit: suit, value: value))
			}
		}
	}
	
	func pop() -> Card {
		return cards.removeLast()
	}
	
	func empty() -> Bool {
		return cards.count == 0
	}
	
	func shuffle() {
		// Fisher-Yates shuffle
		for var i = cards.count - 1; i > 0; i-- {
			let j = Int(arc4random_uniform(i + 1))
			let tmp = cards[i]
			cards[i] = cards[j]
			cards[j] = tmp
		}
	}
}
