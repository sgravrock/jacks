import UIKit

enum Suit: CustomStringConvertible {
	case Clubs, Hearts, Spades, Diamonds
	
	var description : String {
		switch self {
		case Clubs: return "♣"
		case Hearts: return "♥"
		case Spades: return "♠"
		case Diamonds: return "♦"
		}
	}
}

enum CardValue: Int, CustomStringConvertible {
	case Ace = 1,
	Two = 2, Three = 3, Four = 4, Five = 5, Six = 6, Seven = 7, Eight = 8, Nine = 9, Ten = 10,
	Jack = 11, Queen = 12, King = 13
	
	var description: String {
		if self == Ace {
			return "A"
		} else if self == Jack {
			return "J"
		} else if self == Queen {
			return "Q"
		} else if self == King {
			return "K"
		} else {
			return "\(rawValue)"
		}
	}
}

struct Card: CustomStringConvertible, Equatable {
	let suit: Suit
	let value: CardValue
	
	func points() -> Int {
		switch (value) {
		case CardValue.Jack:
			return 0
		case CardValue.Queen, CardValue.King:
			return 10
		default:
			return value.rawValue
		}
	}
	
	var description: String {
		return "\(value)\(suit)"
	}
}

func ==(lhs: Card, rhs: Card) -> Bool {
	return lhs.suit == rhs.suit && lhs.value == rhs.value
}
