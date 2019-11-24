import UIKit

class Deck: NSObject {
	var cards = [Card]()
	
	override init() {
		for suit in [Suit.clubs, Suit.hearts, Suit.spades, Suit.diamonds] {
			for value in 1...13 {
				cards.append(Card(suit: suit, value: CardValue(rawValue: value)!))
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
		for i in ((0 + 1)...cards.count - 1).reversed() {
			let j = Int(arc4random_uniform(UInt32(i) + UInt32(1)))
			let tmp = cards[i]
			cards[i] = cards[j]
			cards[j] = tmp
		}
	}
}
